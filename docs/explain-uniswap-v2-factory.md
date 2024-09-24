# Explain UniswapV2Factory

The most important method in the factory contract is `createPair`:

```solidity
function createPair(address tokenA, address tokenB) external returns (address pair) {
    require(tokenA != tokenB, 'UniswapV2: IDENTICAL_ADDRESSES');
    (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
    require(token0 != address(0), 'UniswapV2: ZERO_ADDRESS');
    require(getPair[token0][token1] == address(0), 'UniswapV2: PAIR_EXISTS'); // single check is sufficient
    bytes memory bytecode = type(UniswapV2Pair).creationCode;
    bytes32 salt = keccak256(abi.encodePacked(token0, token1));
    assembly {
        pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
    }
    IUniswapV2Pair(pair).initialize(token0, token1);
    getPair[token0][token1] = pair;
    getPair[token1][token0] = pair; // populate mapping in the reverse direction
    allPairs.push(pair);
    emit PairCreated(token0, token1, pair, allPairs.length);
}
```

Firstly, `token0` and `token1` are sorted to ensure `token0`'s literal address is less than `token1`'s. Then, a contract is created using `assembly` + `create2`. [`assembly`](https://docs.soliditylang.org/en/develop/assembly.html#inline-assembly) allows for direct EVM manipulation in Solidity using the [Yul](https://docs.soliditylang.org/en/develop/yul.html#yul) language, representing a lower-level method of operation. As discussed in the whitepaper, `create2` is mainly used to create deterministic trading pair contract addresses, meaning the pair address can be computed directly from the two token addresses without on-chain contract queries.

`CREATE2` comes from [EIP-1014](https://eips.ethereum.org/EIPS/eip-1014), according to which, the final generated address is influenced by the custom `salt` value provided during pair contract generation. For a trading pair of two tokens, the `salt` value should be consistent; naturally, using the trading pair's two token addresses comes to mind. To ensure order does not affect the pair, the contract starts by sorting the two tokens to generate the `salt` value in ascending order.

In the latest EVM versions, passing the `salt` parameter directly to the `new` method is supported, shown as:

```solidity
pair = new UniswapV2Pair{salt: salt}();
```

Due to the lack of this functionality during the development of Uniswap v2 contracts, `assembly create2` was used.

According to the [Yul specification](https://docs.soliditylang.org/en/develop/yul.html#yul), `create2` is defined as follows:

> create2(v, p, n, s)
> 
> create new contract with code mem[p…(p+n)) at address keccak256(0xff . this . s . keccak256(mem[p…(p+n))) and send v wei and return the new address, where 0xff is a 1 byte value, this is the current contract’s address as a 20 byte value and s is a big-endian 256-bit value; returns 0 on error

In the source code, the `create2` method call:

```solidity
pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
```

The parameters are interpreted as follows:

- v=0: The amount of ETH tokens (in wei) sent to the newly created pair contract
- p=add(bytecode, 32): The starting position of the contract bytecode
  > Why add 32? Because the `bytecode` type is `bytes`, and per the ABI specification, `bytes` is a variable length type. The first 32 bytes store the length of the `bytecode`, followed by the actual content, making the start of the actual contract bytecode at `bytecode+32` bytes.
- n=mload(bytecode): The total byte length of the contract bytecode
  > As mentioned, the first 32 bytes of `bytecode` store the actual length of the contract bytecode (in bytes), and `mload` fetches the value of the first 32 bytes of the passed parameter, making `mload(bytecode)` equal to `n`.
- s=salt: The custom `salt`, which is the combination of `token0` and `token1` addresses encoded together.





