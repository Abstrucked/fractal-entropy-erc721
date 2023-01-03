// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
import "@openzeppelin/contracts/utils/Strings.sol";
import "solidity-bytes-utils/contracts/BytesLib.sol";
import "../libraries/Utils.sol";
import "hardhat/console.sol";

contract PaletteRenderer {
    uint256 SIZE = 512;

    function getBasePalette(bytes32 _seed) public pure returns (bytes3[32] memory){
        bytes memory basePalette = bytes(abi.encodePacked(_seed));
        // uint8 size = uint8(basePalette.length);
        bytes3[32] memory palette;
        uint8 start = 0;
        uint8 module = 1;
        for(uint8 i=0;i<32; i++) {
            palette[i] = bytes3(abi.encodePacked(BytesLib.slice(basePalette, start, module)));
            start++;
        }
        return palette;
    
    }

    function SquareSVG(uint256 _tokenId, bytes32 _seed) private view returns (string memory) {
        uint[3][32] memory palette = getPalette(_tokenId, _seed);
        // uint256 red = BytesLib.toUint256(palette[0], 0);
        string memory colorTuple;
        uint256 HEIGHT = 16;
        string memory renderSvg;
        for(uint256 i=0; i<palette.length; i++) {
            colorTuple = string.concat(
                Utils.uint2str(palette[i][0]),
                ",",
                Utils.uint2str(palette[i][1]),
                ",",
                Utils.uint2str(palette[i][2])
              );
            renderSvg = string.concat(
                renderSvg,
                '<rect width="',
                    Utils.uint2str(SIZE),
                    '" y="',
                    Utils.uint2str(i*HEIGHT),
                    '" height="',
                    Utils.uint2str(HEIGHT),
                    '" fill="rgb(',
                    colorTuple,
                    ')"></rect>'
                );
        }
        return renderSvg;
    }

    function drawPalette(uint256 _tokenId, bytes32 _seed) public view returns (string memory) {
        
        
          
        // console.log("fff", palette[0][0]);
        string memory renderSvg = string.concat(
            '<svg width="',
            Utils.uint2str(SIZE),
            '" height="',
            Utils.uint2str(SIZE),
            '" viewBox="0 0 ',
            Utils.uint2str(SIZE),
            " ",
            Utils.uint2str(SIZE),
            '" xmlns="http://www.w3.org/2000/svg">'
          );
          string memory blocks = SquareSVG(_tokenId, _seed);
          renderSvg = string.concat(renderSvg, blocks, "</svg>");
          return renderSvg;
    }

    
    function getPalette(uint256 _tokenId, bytes32 _seed) public pure returns (uint256[3][32] memory){
        uint256[3] memory color;
        uint256[3][32] memory palette;
        uint256 seed = asciiToInteger(_seed);
        uint256 i = 0;
        color[0] = Utils.randomRange(_tokenId, string.concat("Red", Utils.uint2str(seed)), 0, 255);
        color[1] = Utils.randomRange(_tokenId, string.concat("Green", Utils.uint2str(seed)), 0, 255);
        color[2] = Utils.randomRange(_tokenId, string.concat("Blue", Utils.uint2str(seed)), 0, 255);
        
        uint256[3][4] memory base;
        base[0] = color;
        base[1] = [color[1], color[0], 255-color[0]];
        base[2] = [color[2], color[1], color[0]];
        base[3] = [color[0], color[1], 255-color[2]];
        uint256 x = 0;
        for(; i<32; i++) {
            color[0] = base[0][x] + i*4;
            color[1] = base[1][x] + i*4;
            color[2] = base[2][x] + i*4;
            for(uint8 c=0; c<3; c++) {
                if(color[c]>255) {
                    color[c] = 255;
                }
            }
            
            palette[i] = [ color[0], color[1], color[2]];
            if(x%8 == 0) {
                x = i/8;
            }
        }

        return palette;
    }
    function getWebPalette(uint256 _tokenId, bytes32 _seed) public pure returns (bytes[32] memory){
        uint256[3] memory color;
        bytes[32] memory palette;
        uint256 seed = asciiToInteger(_seed);
        uint256 i = 0;
        color[0] = Utils.randomRange(_tokenId, string.concat("Red", Utils.uint2str(seed)), 0, 255);
        color[1] = Utils.randomRange(_tokenId, string.concat("Green", Utils.uint2str(seed)), 0, 255);
        color[2] = Utils.randomRange(_tokenId, string.concat("Blue", Utils.uint2str(seed)), 0, 255);
        
        uint256[3][4] memory base;
        base[0] = color;
        base[1] = [color[1], color[0], 255-color[0]];
        base[2] = [color[2], color[1], color[0]];
        base[3] = [color[0], color[1], 255-color[2]];
        uint256 x = 0;
        for(; i<32; i++) {
            color[0] = base[0][x] + i*4;
            color[1] = base[1][x] + i*4;
            color[2] = base[2][x] + i*4;
            for(uint8 c=0; c<3; c++) {
                if(color[c]>255) {
                    color[c] = 255;
                }
            }
            bytes memory r = BytesLib.slice(abi.encode(color[0]), 31, 1);
            bytes memory g = BytesLib.slice(abi.encode(color[1]), 31, 1);
            bytes memory b = BytesLib.slice(abi.encode(color[2]), 31, 1);
            palette[i] = bytes(abi.encodePacked(r, g, b));
            if(x%8 == 0) {
                x = i/8;
            }
        }

        return palette;
    }
    function asciiToInteger(bytes32 x) public pure returns (uint256) {
        uint256 y;
        for (uint256 i = 0; i < 32; i++) {
            uint256 c = (uint256(x) >> (i * 8)) & 0xff;
            if (48 <= c && c <= 57)
                y += (c - 48) * 10 ** i;
            else
                break;
        }
        return y;
    }
}