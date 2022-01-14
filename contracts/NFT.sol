// SPDX-License-Identifier: MIT OR Apache-2.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./utils/StringHelper.sol";

contract NFT is ERC721, Ownable {

    // URI's default URI prefix
    string internal baseMetadataURI;

    //mapping for allowed minters
    mapping(address => bool) minterList;

    // start time
    uint256 public startTime;

    // end time
    uint256 public endTime;

    // length of allowed minters
    uint256 internal allowedLength = 666;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    /// @notice Event emitted when user minted NFT
    event MintNFT(
        uint256 indexed id
    );

    /// @notice Event emitted when user transferred NFT
    event TransferNFT(
        address indexed sender,
        address indexed receiver,
        uint256 indexed id
    );

    //constructor for an ERC721 is a name and symbol
    constructor(string memory _baseMetadataURI, address[] memory allowedMinters, uint256 _startTime, uint256 _endTime ) ERC721("PolarNFT", "Polar") {
        baseMetadataURI = _baseMetadataURI;
        for (uint256 _i = 0; _i < allowedMinters.length && _i < allowedLength; _i++) {
            address _address = allowedMinters[_i];
            minterList[_address] = true;
        }
        startTime = _startTime;
        endTime = _endTime;
    }

    /**
     * @notice Will update the base URL of token's URI
     * @param _newBaseMetadataURI New base URL of token's URI
     */
    function setBaseMetadataURI(string memory _newBaseMetadataURI)
        public
        onlyOwner
    {
        baseMetadataURI = _newBaseMetadataURI;
    }

    /**
     * @notice Will update the start time of mint
     * @param _newStartTime New base URL of token's URI
     */
    function setStartTime(uint256 _newStartTime)
        public
        onlyOwner
    {
        startTime = _newStartTime;
    }

    /**
     * @notice Will update the end time of mint
     * @param _newEndTime New base URL of token's URI
     */
    function setEndTime(uint256 _newEndTime)
        public
        onlyOwner
    {
        endTime = _newEndTime;
    }

    
    /**
    * @notice A distinct Uniform Resource Identifier (URI) for a given token.
    * @dev URIs are defined in RFC 3986.
    *      URIs are assumed to be deterministically generated based on token ID
    * @return URI string
    */
    function tokenURI(uint256 _id) public override virtual view returns (string memory) {
        return string(abi.encodePacked(baseMetadataURI, StringHelper.uint2str(_id), ".json"));
    }

    /**
    @notice Will mint new token
    */
    function mintNFT() public {
        require(msg.sender != address(0), "mint to the zero address");
        require(validate(), "!block");
        require(canMint(msg.sender), "not allowed to mint");

        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

       // mint token for the person that called the function
        _mint(msg.sender, newItemId);

        // disable address
        minterList[msg.sender] = false;
        emit MintNFT(newItemId);
    }

    /**
    * @notice Will transfer ownership of the token
    * @param _receiver address to validate
    * @param _tokenId token id to transfer ownership
    */
    function transferNFT(address _receiver, uint256 _tokenId) public {
        safeTransferFrom(msg.sender, _receiver, _tokenId);
        emit TransferNFT(msg.sender, _receiver, _tokenId);
    }

    /**
    * @notice validate if address is allowed to mint or not.
    * @param _address address to validate
    */
    function canMint(address _address) public view returns (bool) {
        if(minterList[_address]){
            return true;
        } else {
            return false;
        }
    }

    /**
    * @notice return last token ID.
    */
    function getLastID() public view returns (uint256) {
        return _tokenIds.current();
    }

    /**
    * @notice validate if time is valid to mint.
    */
    function validate() internal view returns (bool) {
        if(startTime < block.timestamp && endTime > block.timestamp){
            return true;
        } else {
            return false;
        }
    }
}