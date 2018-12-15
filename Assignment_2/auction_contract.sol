pragma solidity ^0.4.24;

contract auctionVote {
    
    struct buyer {
        address buyerAddress;
        uint tokenBought;
        mapping (bytes32 => uint) myBid;
    }
    
    mapping (address => buyer) public buyers; 
    mapping (bytes32 => uint) public highestBid;
    
    bytes32[] public productNames; 
    
    uint public totalToken; 
    uint public balanceTokens;
    uint public tokenPrice;
    
    constructor(uint _totalToken, uint _tokenPrice) public
    {
        totalToken = _totalToken;
        balanceTokens = _totalToken;
        tokenPrice = _tokenPrice;
        
        productNames.push("iphone7");
        productNames.push("iphone8");
        productNames.push("iphoneX");
        productNames.push("galaxyS9");
        productNames.push("galaxyNote9");
        productNames.push("LGG7");
    }
    
    function buy() payable public returns (int) 
    {
        uint tokensToBuy = msg.value / tokenPrice;
        require(tokensToBuy <= balanceTokens);
        buyers[msg.sender].buyerAddress = msg.sender;
        buyers[msg.sender].tokenBought += tokensToBuy;
        balanceTokens -= tokensToBuy;
    }
    
    function getBid() view public returns (uint, uint, uint, uint, uint, uint)
    {
        return (buyers[msg.sender].myBid["iphone7"],
        buyers[msg.sender].myBid["iphone8"],
        buyers[msg.sender].myBid["iphoneX"],
        buyers[msg.sender].myBid["galaxyS9"],
        buyers[msg.sender].myBid["galaxyNote9"],
        buyers[msg.sender].myBid["LGG7"]);
    }
    
    function getHighestBid() view public returns (uint, uint, uint, uint, uint, uint)
    {
        return (highestBid["iphone7"],
        highestBid["iphone8"],
        highestBid["iphoneX"],
        highestBid["galaxyS9"],
        highestBid["galaxyNote9"],
        highestBid["LGG7"]);
    }
    
    function vote(bytes32 productName, uint tokenBid) public
    {
        uint index = getProductIndex(productName);
        require(index != uint(-1));
        
        require(tokenBid <= buyers[msg.sender].tokenBought);
        
        buyers[msg.sender].myBid[productName] += tokenBid;
        buyers[msg.sender].tokenBought -= tokenBid;
        if(highestBid[productName] < buyers[msg.sender].myBid[productName])
        {
            highestBid[productName] = buyers[msg.sender].myBid[productName];    
        }
    }
    
    function getProductIndex(bytes32 product) view public returns (uint) 
    {
        for(uint i = 0; i < productNames.length; i++)
        {
            if(productNames[i] == product)
            {
                return i;
            }
        }
        
        return uint(-1); 
    }
    
    function getProductsInfo() view public returns (bytes32[])
    {
        return productNames;
    }
    
    function getTotalToken() view public returns(uint)
    {
        return totalToken;
    }
    
    function getBalanceTokens() view public returns(uint)
    {
        return balanceTokens;
    }
    
    function getTokenPrice() view public returns(uint)
    {
        return tokenPrice;
    }
    
    function getTokenBought() view public returns(uint)
    {
        return buyers[msg.sender].tokenBought;
    }
}