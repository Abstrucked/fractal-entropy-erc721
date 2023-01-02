// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

// Import this file to use console.log
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./interfaces/IFractalEntropy.sol";
import "./libraries/Utils.sol";
import "./Palette/Palette.sol";
/**
 * @dev TODO 
 * - Add metadata variables
 * - Implement the rest of contract
 */

contract FractalEntropy is IFractalEntropy, ERC721, ERC721URIStorage, Ownable {
    
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;


    mapping(uint256 => Fractal) private _fractals;

    bool private _MINT_ENABLED = false;
    string private _baseTokenUri;
    uint256 MAX_SUPPLY = 10;
    
    string private _base_URI = "https://";
    function isSaleOpen() view external returns (bool){
        return _MINT_ENABLED;
    }

    function toggleSale() external onlyOwner {
        _MINT_ENABLED = !_MINT_ENABLED;
        emit SaleStateChange(_MINT_ENABLED);
    }

    constructor() ERC721("FractalEntropy", "FRCTL") {
    }
    
    function _baseURI() internal view override returns (string memory) {
        return _base_URI;
    }
    

    function minted() external view returns(uint256){
        return _tokenIdCounter.current();
    }


    function changeTokenBaseUri(string memory _newTokenBaseUri) external onlyOwner {
        _base_URI = _newTokenBaseUri;
    }

    
    function generateFractal(uint256 tokenId, address to) private pure returns (Fractal memory) {
        uint256 xmin = Utils.randomRange(tokenId, "xmin", 650000000000000000, 680000000000000000);
        uint256 ymin = Utils.randomRange(tokenId, "ymin", 650000000000000000, 680000000000000000);
        uint256 scale = Utils.randomRange(tokenId,  "scale", 100, 2000);
        uint256 pixels = Utils.randomRange(tokenId, "pixels", 1, 6);
        Fractal memory fractal = Fractal(xmin,ymin, uint8(pixels), uint32(scale), "0x0000000");
        return fractal;
    }

    
    function safeMint(address to, string memory _tokenURI) public returns (uint256) {
        if(!_MINT_ENABLED) {
            revert SaleIsClosed();
        }
        if(_tokenIdCounter.current() >= MAX_SUPPLY) {
            revert MaxSupplyReached();
        }
        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        
        _fractals[tokenId] = generateFractal(tokenId, msg.sender);
        
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _tokenURI);
        return tokenId;
    }    

    function getFractalData(uint256 id) public view returns ( Fractal memory) {
        Fractal storage fractal = _fractals[id];
        return fractal;
    }

    function changePalette(uint256 id, bytes memory data) public{
        if(ownerOf(id)!= msg.sender) {
            revert("Only the token owner can change palette");
        }
        Fractal storage fractal = _fractals[id];
        fractal.palette = data;
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