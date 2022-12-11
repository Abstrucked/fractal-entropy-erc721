// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interfaces/IFractalEntropy.sol";
/**
 * @dev TODO 
 * - Add metadata variables
 * - Implement the rest of contract
 */

contract FractalEntropy is IFractalEntropy, ERC721, ERC721URIStorage, Ownable {
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    bool private _MINT_ENABLED = false;
    
    uint256 MAX_SUPPLY = 10;
    uint256 public minX;
    uint256 public minY;

    function saleOpen() view external returns (bool){
        return _MINT_ENABLED;
    }

    function toggleSale() external onlyOwner {
        _MINT_ENABLED = !_MINT_ENABLED;
        emit SaleStateChange(_MINT_ENABLED);
    }

    

    constructor() ERC721("FractalEntropy", "FRCTL") { }
    
    /**
     * learn how to manmage IPFS
     * probably using the ipfsDB from turinglabs?
     */
    function _baseURI() internal pure override returns (string memory) {
        return "https://fractalentropy.eth.link/nft/";
    }


    function safeMint(address to, string memory tokenURI) public returns (uint256) {
        if(!_MINT_ENABLED) {
            revert SaleIsClosed();
        }
        if(_tokenIdCounter.current() >= MAX_SUPPLY) {
            revert MaxSupplyReached();
        }
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, tokenURI);
        return tokenId;
    }    

    function _burn(uint256 tokenId) internal onlyOwner override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

}