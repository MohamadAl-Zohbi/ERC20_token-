pragma solidity ^0.8.0;

contract MyICO {
    // Token properties
    string public name;
    string public symbol;
    uint256 public totalSupply;

    // ICO properties
    uint256 public startTime;
    uint256 public endTime;
    uint256 public tokenPrice;
    uint256 public minInvestment;
    uint256 public maxInvestment;
    uint256 public raised;
    uint256 public tokensSold;

    // Investor information
    mapping(address => uint256) public balanceOf;
    address[] public investors;

    // Events
    event TokenPurchase(address indexed _from, uint256 _value, uint256 _amount);

    // Modifiers
    modifier onlyDuringICO() {
        require(now >= startTime && now <= endTime);
        _;
    }

    // Constructor
    constructor() public {
        name = "My Token";
        symbol = "MTK";
        totalSupply = 1000000;
        startTime = now;
        endTime = startTime + 1 weeks;
        tokenPrice = 0.01 ether;
        minInvestment = 0.1 ether;
        maxInvestment = 10 ether;
    }

    // Fallback function
    function() external payable {
        buyTokens();
    }

    // Token purchase function
    function buyTokens() public payable onlyDuringICO {
        require(msg.value >= minInvestment && msg.value <= maxInvestment);
        uint256 tokens = msg.value.div(tokenPrice);
        balanceOf[msg.sender] += tokens;
        raised += msg.value;
        tokensSold += tokens;
        emit TokenPurchase(msg.sender, msg.value, tokens);
    }

    // Refund function
    function refund() public onlyDuringICO {
        require(raised < minInvestment);
        msg.sender.transfer(balanceOf[msg.sender]);
        balanceOf[msg.sender] = 0;
    }

    // Distribution function
    function distribute() public onlyDuringICO {
        require(now > endTime);
        require(raised >= minInvestment);
        // Code to distribute tokens to investors
    }
}
