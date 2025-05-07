// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../erc20/BaseERC20CallBack.sol";
import "./MyNFT.sol";
import "../erc20/BaseERC20.sol";

contract NFTMarket is BaseERC20CallBack {

    mapping(uint256 => uint256) pricesOfNFT;

    MyNFT public immutable _nft;
    BaseERC20 public immutable _erc20;

    constructor(address nftAddr, address erc20Addr) {
        _nft = MyNFT(nftAddr);
        _erc20 = BaseERC20(erc20Addr);
    }

    // NFT的持有者上架NFT, 两种实现方式: 1.授权 2.转到该合约
    function list(uint256 tokenId, uint256 amount) public  {
        address owner = _nft.ownerOf(tokenId);
        require(owner == msg.sender, "not the nft holder");
        require(amount > 0, "price must more then zero");
        // 查看NFTMarket是否有授权
        address approveAddr = _nft.getApproved(tokenId);
        require((approveAddr == address(this)), "NFTMarket has not get approved");
        // 上架
        pricesOfNFT[tokenId] = amount;
    }

    // 普通的购买 NFT 功能，用户转入所定价的 token 数量，获得对应的 NFT
    function buyNFT(uint256 tokenId) public {
        uint256 price = pricesOfNFT[tokenId];
        require(price > 0, "nft not on list");
        address old_holder = _nft.ownerOf(tokenId);
        address nft_new_holder = msg.sender;
        // 转账
        bool success = _erc20.transferFrom(msg.sender, old_holder, price);
        require(success, "thansfer success");
        _nft.transferFrom(old_holder, nft_new_holder, tokenId);
    }

    // 实现NFT购买功能
    function tokensReceived(address account, uint256 amount, bytes calldata data) external override returns(bytes4) {
        uint256 tokenId = abi.decode(data, (uint256));
        uint256 price = pricesOfNFT[tokenId];
        require(price > 0, "nft not on list");
        require(amount >= price, "amount is not enougn");
        address old_holder = _nft.ownerOf(tokenId);
        address nft_new_holder = msg.sender;
        _nft.transferFrom(old_holder, nft_new_holder, tokenId);
        return BaseERC20CallBack.tokensReceived.selector;
    }

}
