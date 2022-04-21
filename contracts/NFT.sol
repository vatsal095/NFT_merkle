pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import  "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SPECTNFT is ERC721, ERC721Enumerable, Ownable{
    using Address for address;

    string private _baseURIextended;

    // uint256 public maxMintable = 2; //Max mintable per wallet
    //uint256 public remainingReserved = 33; // 33 reserved for giveaway and team.

    // bool public saleIsActive;
    // bool public preSaleIsActive;
    bool public locked;

 
    address private _signer;

    mapping(address => uint256) public minted;
    mapping(uint256 => bool) public usedNonces;
    

    constructor(string memory __baseURI, address __signer) ERC721("", "ALGN") {
            _baseURIextended = __baseURI;
            _signer = __signer;
    }
    // /// @notice For giveaway winners and team. Cannot mint more than reserved.
    // /// @param nonce random nonce
    // /// @param signature signature
    // function claim(uint256 nonce, bytes calldata signature)
    //     external {
    //     uint tokenCount = totalSupply();
    //     require(!usedNonces[nonce], "cannot use same signature twice");
    //     require(minted[msg.sender]<= maxMintable, "exceeds max tokens per wallet");
    //     bytes32 hash = keccak256(abi.encodePacked(msg.sender, nonce));
    //     require(ECDSA.recover(hash, signature) == _signer, "invalid signature");
    //     usedNonces[nonce] = true;
    //     remainingReserved--;
    //     minted[msg.sender]+=1;
    //     tokenCount++;
    //     _safeMint(msg.sender, tokenCount);

    // }
    /// @notice presale mint, only allowed addresses be able to mint. max 2 per wallet
    /// @param amount number of NFT to mint
    /// @param nonce number of max mint allowed
    /// @param signature signature
    // function preSaleMint(uint256 amount, 
    //     uint256 nonce, 
    //     bytes calldata signature)
    //     external payable{
    //         uint tokenCount = totalSupply();
    //         require(preSaleIsActive,"presale must be active");
    //         uint256 mp = minted[msg.sender];
    //         require(mp + amount <= maxMintable, "exceeds max tokens per wallet");
    //         bytes32 data = keccak256(abi.encodePacked(msg.sender, nonce));
    //         address signer = ECDSA.recover(data, signature);
    //         require(signer == _signer, "invalid signature");
    //         minted[msg.sender] = mp + amount;
    //         for(uint i=0; i < amount; i++){
    //             tokenCount++;
    //             _safeMint(msg.sender, tokenCount);
    //         }
    // }
    /// @notice public mint,a nybody can mint NFT. max 2 per wallet
    /// @param _amount number of NFT to mint
    function mint()
        external payable {
            uint tokenCount = totalSupply();
            require(!whitelistMint(msg.sender),"you are not able to mint");
            require(!Address.isContract(msg.sender),"contracts are not allowed");
            uint256 mp = minted[msg.sender];
            require(mp + _amount <= maxMintable, "exceeds max tokens per wallet");
            minted[msg.sender] = mp +  1;
            _safeMint(msg.sender, tokenCount);
            
    }

    // Control functions
    function closeNonce(uint _nonce) external onlyOwner {
        usedNonces[_nonce] = true;
    }
    // function toggleSale() external onlyOwner {
    //     saleIsActive = !saleIsActive;
    // }
    // function togglePreSale() external onlyOwner{
    //     preSaleIsActive = !preSaleIsActive;
    // }
    function setSigner(address __signer) external onlyOwner {
        _signer = __signer;
    }


    function setBaseURI(string memory __baseURI) external onlyOwner {
        require(!locked, "locked...");
        _baseURIextended = __baseURI;
    }
    // function setMaxMintablePerAcc(uint256 n) external onlyOwner {
    //     maxMintable = n;
    // }
    function withdrawAll(address payable receiver) external onlyOwner {
        uint balance = address(this).balance;
        receiver.transfer(balance);
    }

        //And for the eternity...
    function lockMetadata() external onlyOwner {
		locked = true;
	}
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    /// View functions

    function tokensOfOwner(address _owner1) external view returns (uint256[] memory) {
		uint256 tokenCount = balanceOf(_owner1);
		if (tokenCount == 0) {
			return new uint256[](0);
		} else {
			uint256[] memory result = new uint256[](tokenCount);
			uint256 index;
			for (index = 0; index < tokenCount; index++) {
				result[index] = tokenOfOwnerByIndex(_owner1, index);
			}
			return result;
		}
	}
    function _baseURI() internal view override returns (string memory) {
        return _baseURIextended;
    }
    
    receive() external payable{
    }

}