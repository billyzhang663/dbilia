const { expect } = require("chai");
const bigNum = num=>(num + '0'.repeat(18))

describe("DbiliaToken", function () {
  it("Should return the new greeting once it's changed", async function () {
  let Token;
  let hardhatToken;
  let owner;
  let other;
  
    beforeEach(async function () {
      Token = await ethers.getContractFactory("DbiliaToken");
      [owner, other] = await ethers.getSigners();
      hardhatToken = await Token.deploy("DbiliaToken", "DT");
    });

    describe('mintWithUSD', function() {
      it ("Should set the right owner", async function () {
        try {
          expect(await hardhatToken.mintWithUSD(other.address, 1, 1, ""));
        } catch (err) {
          expect(err.message).to.equal("No Dbilia Owner Account");
        }        
      })

      it ("Should mint with USD successfully", async function () {
        await hardhatToken.connect(owner).mintWithUSD(other.address, 1, 1, "token");
        let dbiliaInfo = await hardhatToken.dbiliaInfo(0);
        expect(dbiliaInfo.cardId).to.equal('1');
        expect((await hardhatToken.balanceOf(other.address)).toString()).to.equal('1');
      })

      it ("Should mint with ETH successfully", async function () {
        try {
          await hardhatToken.connect(other).mintWithETH(2, 2, "tokenETH", {value:bigNum(1)});
      } catch (err) {
          console.log('Error Message', err.message)
      }
        
        let dbiliaInfo = await hardhatToken.dbiliaInfo(0);
        expect(dbiliaInfo.cardId).to.equal('2');
        expect((await hardhatToken.balanceOf(other.address)).toString()).to.equal('1');
      })
    })
  });
});
