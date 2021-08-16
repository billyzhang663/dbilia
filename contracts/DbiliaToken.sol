//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DbiliaToken is Ownable, ERC721 {
  struct DbiliaInfo {
    uint cardId;
    uint edition;
    string tokenURI;
  }

  DbiliaInfo[] public dbiliaInfo;

  mapping (uint => address) public dbiliaToOwner;

  event MintWithUSD(address _userId, uint _cardId, uint _edition, string _tokenURI);
  event MintWithETH(uint _cardId, uint _edition, string _tokenURI);

  constructor(  
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        
    }

  function mintWithUSD(address _userId, uint _cardId, uint _edition, string memory _tokenURI) external onlyOwner {
    dbiliaInfo.push(DbiliaInfo(_cardId, _edition, _tokenURI));
    uint id = dbiliaInfo.length - 1;
    _mint(_userId, id);
    dbiliaToOwner[id] = _userId;
    emit MintWithUSD(_userId, _cardId, _edition, _tokenURI);
  }

  function mintWithETH(uint _cardId, uint _edition, string memory _tokenURI)  external payable {
    require(msg.value > 0.1 ether, "Insufficient Input");
    address userId = msg.sender;
    dbiliaInfo.push(DbiliaInfo(_cardId, _edition, _tokenURI));
    uint id = dbiliaInfo.length - 1;
    _mint(userId, id);
    dbiliaToOwner[id] = userId;
    emit MintWithETH(_cardId, _edition, _tokenURI);
  }

  function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        return "";
    }
}
