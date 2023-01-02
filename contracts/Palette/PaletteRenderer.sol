// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
import "@openzeppelin/contracts/utils/Strings.sol";
import "solidity-bytes-utils/contracts/BytesLib.sol";
import "../libraries/Utils.sol";

contract PaletteRenderer {

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

    function getPalette(uint256 _tokenId) public pure returns (bytes[32] memory){
        uint256[3] memory color;
        bytes[32] memory palette;
        
        uint256 i = 0;
        color[0] = Utils.randomRange(_tokenId, string.concat("colorR", Utils.uint2str(i)), 0, 255);
        color[1] = Utils.randomRange(_tokenId, string.concat("colorG", Utils.uint2str(i)), 0, 255);
        color[2] = Utils.randomRange(_tokenId, string.concat("colorB", Utils.uint2str(i)), 0, 255);
        
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
}
