pragma solidity ^0.4.17;

contract CampaignFactory {
    address[] public deployedCampaigns;
    
    function createCampaign(uint minimum) public {
        address newCampaign = new Campaign(minimum, msg.sender);
        deployedCampaigns.push(newCampaign);
    }
    
    function getDeployedCampaigns() public view returns (address[]) { // View: no data is modified
        return deployedCampaigns;
    }
}

contract Campaign {
    // Definition, not instance.
    // This is a type
    struct Request {
        string description;
        uint value;
        address recipient;
        bool complete;
        uint approvalCount; // Value types
        mapping(address => bool) approvals; // People who have provided approval. Reference types
    }
    
    // Single value lookups
    // "All values exist" (default values, value type)
    
    
    // Storage variables
    address public manager;
    uint public minimumContribution;
    mapping(address => bool) public approvers;
    uint public approversCount;
    Request[] public requests;
    
    modifier restricted() {
        require(msg.sender == manager);
        _;
    }
    
    function Campaign(uint minimum, address creator)  public {
        manager = creator;
        minimumContribution = minimum;
    }
    
    function contribute() public payable {
        require(msg.value > minimumContribution);
        
        
        approvers[msg.sender] = true;
        approversCount++;
    }
    
    function createRequest(string description, uint value, address recipient) 
        public restricted {
        Request memory newRequest = Request({ // Unable to create storage type
            description: description,
            value: value,
            recipient: recipient,
            complete: false,
            approvalCount: 0
        });  
        
        requests.push(newRequest);
    }
    
    function approveRequest(uint index) public {
        Request storage request = requests[index]; // Do not create a copy, manipulate the storage copy
        
        require(approvers[msg.sender]); // Require donator
        require(!request.approvals[msg.sender]); // Require not have voted
        
        request.approvals[msg.sender] = true;
        request.approvalCount++;
    }
    
    function finalizeRequest(uint index) public restricted {
        Request storage request = requests[index];
        
        require(request.approvalCount > (approversCount / 2));
        require(!request.complete);
        
        request.recipient.transfer(request.value); // Transfer the money
        request.complete = true;
        
    }

    function getSummary() public view returns (
        uint, uint, uint, uint, address
        ) {
        return (
            minimumContribution,
            this.balance,
            requests.length,
            approversCount,
            manager
        );
    }

    function getRequestsCount() public view returns (uint) {
        return requests.length;
    }
}