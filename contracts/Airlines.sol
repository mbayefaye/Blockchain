// SPDX-License-Identifier: MIT
pragma solidity >=0.4.20;

contract Airlines {
  address chairperson; // identity of the chairperson.

  // collectively define the data of the airlines, including the escrow .
  struct details {
    uint256 escrow; // deposit for payment settlement
    uint256 status;
    uint256 hashDetails;
  }

  // airline account payments and membership mapping
  // mapping to map account addresses (identities) of members to their details.
  mapping(address => details) public balanceDetails;
  mapping(address => uint256) public membership;

  // modifiers or rules : Modifier for onlychairperson rule
  modifier onlyChairperson() {
    require(msg.sender == chairperson);
    _;
  }
  // Modifier for onlyMember rule
  modifier onlyMember() {
    require(membership[msg.sender] == 1);
    _;
  }

  // contructor function
  constructor() public payable {
    chairperson = msg.sender;
    membership[msg.sender] = 1; // automatically registered
    balanceDetails[msg.sender].escrow = msg.value;
  }

  function register() public payable {
    address AirlineA = msg.sender;
    membership[AirlineA] = 1;
    balanceDetails[msg.sender].escrow = msg.value;
  }

  function unregister(address payable AirlineZ) public onlyChairperson {
    if (chairperson != msg.sender) {
      revert();
    }
    membership[AirlineZ] = 0;
    AirlineZ.transfer(balanceDetails[AirlineZ].escrow);
    balanceDetails[AirlineZ].escrow = 0;
  }

  function request(address toAirline, uint256 hashOfDetails) public onlyMember {
    if (membership[toAirline] != 1) {
      revert();
    }
    balanceDetails[msg.sender].status = 0;
    balanceDetails[msg.sender].hashDetails = hashOfDetails;
  }

  function response(
    address fromAirline,
    uint256 hashOfDetails,
    uint256 done
  ) public onlyMember {
    if (membership[fromAirline] != 1) {
      revert();
    }
    balanceDetails[msg.sender].status = done;
    balanceDetails[fromAirline].hashDetails = hashOfDetails;
  }

  function settlePayment(address payable toAirline) public payable onlyMember {
    address fromAirline = msg.sender;
    uint256 amt = msg.value;
    balanceDetails[toAirline].escrow = balanceDetails[toAirline].escrow + amt;
    balanceDetails[fromAirline].escrow =
      balanceDetails[fromAirline].escrow -
      amt;
    // amount subtracted from msg.sender and givern to Airline
    toAirline.transfer(amt);
  }
}
