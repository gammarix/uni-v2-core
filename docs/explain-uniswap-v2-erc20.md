# Explain UniswapV2ERC20

This contract mainly defines UniswapV2's ERC20 standard implementation, with relatively straightforward code. Here, we'll introduce the `permit` method:

```solidity
function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
    require(deadline >= block.timestamp, 'UniswapV2: EXPIRED');
    bytes32 digest = keccak256(
        abi.encodePacked(
            '\x19\x01',
            DOMAIN_SEPARATOR,
            keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
        )
    );
    address recoveredAddress = ecrecover(digest, v, r, s);
    require(recoveredAddress != address(0) && recoveredAddress == owner, 'UniswapV2: INVALID_SIGNATURE');
    _approve(owner, spender, value);
}
```

The `permit` method implements the "Meta transactions for pool shares" feature introduced in section 2.5 of the whitepaper. [EIP-712](https://eips.ethereum.org/EIPS/eip-712) defines the standard for offline signatures, i.e., the format of `digest` that a user signs. The signature's content is the authorization (`approve`) by the owner to allow a contract (`spender`) to spend a certain amount (`value`) of tokens (Pair liquidity tokens) before a deadline. Applications (periphery contracts) can use the original information and the generated v, r, s signatures to call the Pair contract's `permit` method to obtain authorization. The `permit` method uses `ecrecover` to restore the signing address to the token owner; if verification passes, the approval is granted.