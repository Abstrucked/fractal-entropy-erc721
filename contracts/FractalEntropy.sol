// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Import this file to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

/**
 * @dev TODO 
 * - Remove URI setup, all metadata will go onchain
 * - Add metadata variables
 * - Implement the rest of contract
 */

contract FractalEntropy is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    error MaxSupplyReached();


    uint256 MAX_SUPPLY = 10;

    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("FractalEntropy", "FRCTL") {}

    // function _baseURI() internal pure override returns (string memory) {
    //     return "https://fractalentropy.eth.link/nft/";
    // }


    function safeMint(address to) public onlyOwner {
        if(_tokenIdCounter.current() >= MAX_SUPPLY){
            revert MaxSupplyReached();
        }
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(to, tokenId);
        _tokenIdCounter.increment();
        _setTokenURI(tokenId, _baseURI());
    }    

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

}