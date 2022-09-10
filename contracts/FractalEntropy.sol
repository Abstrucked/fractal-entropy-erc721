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
 * - Remove URI setup, all metadata will go onchain
 * - Add metadata variables
 * - Implement the rest of contract
 */

contract FractalEntropy is IFractalEntropy, ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    

    bool private _saleOpen = false;
    // struct Metadata {
    //     uint256 initX;
    //     uint256 initY;
    //     uint112 scale;
    //     bytes32 palette iterations, bailout, pixels
            
    // }
    
    function saleOpen() view external returns (bool){
        return _saleOpen;
    }
    function toggleSale() external onlyOwner {
        _saleOpen = !_saleOpen;
        emit SaleStateChange(_saleOpen);
    }
    uint256 MAX_SUPPLY = 10;
    bool public MINT_ENABLED = false;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("FractalEntropy", "FRCTL") {}

    // function _baseURI() internal pure override returns (string memory) {
    //     return "https://fractalentropy.eth.link/nft/";
    // }


    function safeMint(address to) public {
        if(!_saleOpen) {
            revert SaleIsClosed();
        }
        if(_tokenIdCounter.current() >= MAX_SUPPLY) {
            revert MaxSupplyReached();
        }
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
        _tokenIdCounter.increment();
        _setTokenURI(tokenId, _baseURI());
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