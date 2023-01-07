// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

// import "./ColorConverter.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "solidity-bytes-utils/contracts/BytesLib.sol";

import "../libraries/Utils.sol";

import "./PaletteRenderer.sol";

contract Palette is ERC721 {
  error MaxSupplyReached();

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIdCounter;
  
  uint256 MAX_SUPPLY = 10000;
  uint8[3] color;
  mapping(uint256 => bytes32) private _palettes;
  
  PaletteRenderer public renderer;
  
  constructor(PaletteRenderer _renderer) ERC721("Palettes", "PAL") {
    renderer = PaletteRenderer(_renderer);
  }
  
  function safeMint(address to) public returns (uint256){
    
    if(_tokenIdCounter.current() >= MAX_SUPPLY) {
        revert MaxSupplyReached();
    }
    _tokenIdCounter.increment();
    uint256 tokenId = _tokenIdCounter.current();
    _palettes[tokenId] = generateSeed(tokenId);
    _safeMint(to, tokenId);
    
    return tokenId;
  }

  function minted() external view returns(uint256){
    return _tokenIdCounter.current();
  }

  function generateSeed(uint256 _tokenId) private view returns (bytes32){
    return Utils.randomBytes32(string(abi.encode(block.timestamp, msg.sender, _tokenId)));
  }

  function getSeed(uint256 _tokenId) external view returns (bytes32){
    if(_tokenId > _tokenIdCounter.current()) {
      revert("TokenId does not exist");
    }
    return _palettes[_tokenId];
  }

  // function palette(uint256 _tokenId) public view returns (bytes3[32] memory) {
  //   return renderer.getBasePalette(_palettes[_tokenId]);
  // }

  // function paletteToString(uint256 _tokenId) public view returns (string[32] memory) {
  //   return  renderer.getPalette(_tokenId,  _palettes[_tokenId]);
  // }
  
  // function image(uint256 _tokenId) public view returns(string memory) {
  //   return renderer.drawPalette(_tokenId, _palettes[_tokenId]);
  // }

}