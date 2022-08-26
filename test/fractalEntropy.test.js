
const { ethers, waffle } = require("hardhat");
const { expect } = require("chai");

describe("EntropicFractals contract", async () => {
  let AEFToken;
  let token721;
  let _name='FractalEntropy';
  let _symbol='FRCTL';
  let MAX_SUPPLY = 10;
  let account1,otheraccounts;

  beforeEach(async function () {
    AEFToken = await ethers.getContractFactory("EntropicFractals");
   [owner, account1, ...otheraccounts] = await ethers.getSigners();

    token721 = await AEFToken.deploy();
  });

  describe("Should Deploy", async function () {

    it("Should has the correct name and symbol ", async function () {
      expect(await token721.name()).to.equal(_name);
      expect(await token721.symbol()).to.equal(_symbol);
    });

    it("Should mint a token with token ID 1 & 2 to account1", async function () {
      const address1=account1.address;
      
      await token721.safeMint(address1);
      expect(await token721.ownerOf(ethers.BigNumber.from(0))).to.equal(address1);     
      
      await token721.safeMint(address1);
      expect(await token721.ownerOf(ethers.BigNumber.from(1))).to.equal(address1);
      
      expect(await token721.balanceOf(address1)).to.equal(ethers.BigNumber.from(2));
    });

    it("Should mint up to MAX_SUPPLY", async function () {
      const address1=account1.address;
      let i;
      for(i = 1; i < (MAX_SUPPLY+1); i++){
        await token721.safeMint(address1); 
      }
      expect(i == MAX_SUPPLY)
    });
    
    it("Should revert with 'Max supply reached!'", async function () {
      const address1=account1.address;
      let i;
      for(i = 1; i < (MAX_SUPPLY + 1); i++){
        await token721.safeMint(address1); 
        if(i == MAX_SUPPLY) {
          console.log(i)
          let response =  token721.safeMint(address1);
          await expect(response).to.be.revertedWith("MaxSupplyReached()");
        }
      }
    });
  });
});