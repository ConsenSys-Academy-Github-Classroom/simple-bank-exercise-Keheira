/*
 * This exercise has been updated to use Solidity version 0.8.5
 * See the latest Solidity updates at
 * https://solidity.readthedocs.io/en/latest/080-breaking-changes.html
 */
// SPDX-License-Identifier: MIT
pragma solidity >=0.5.16 <0.9.0;

contract SimpleBank {

    /* State variables
     */
    mapping (address => uint) private balances ;
    
    mapping (address => bool) public enrolled;

    address public owner = msg.sender;
    
    /* Events - publicize actions to external listeners
     */
    
    event LogEnrolled(address accountAddress);

    event LogDepositMade(address accountAddress, uint amount);

    event LogWithdrawal(address accountAddress, uint newBalance, uint withdrawAmount);

    /* Functions
     */

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    fallback () external payable {
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public returns (uint) {
      // 1. A SPECIAL KEYWORD prevents function from editing state variables;
      //    allows function to run locally/off blockchain
      // 2. Get the balance of the sender of this transaction
      return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public returns (bool){
      // 1. enroll of the sender of this transaction
      enrolled[msg.sender] = true;
      emit LogEnrolled(msg.sender);

      return enrolled[msg.sender];
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
      // 1. Add the appropriate keyword so that this function can receive ether
    
      //emit LogAmount(msg.value);
      // 2. Users should be enrolled before they can make deposits
      bool isEnrolled = enrolled[msg.sender];
      if(!isEnrolled)
        isEnrolled = enroll();

      // 3. Add the amount to the user's balance. Hint: the amount can be
      //    accessed from of the global variable `msg`
      balances[msg.sender] += msg.value;

      // 4. Emit the appropriate event associated with this function
      emit LogDepositMade(msg.sender, msg.value);

      // 5. return the balance of sndr of this transaction
      return balances[msg.sender];
    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint) {
      require(
        balances[msg.sender] >= withdrawAmount,
        "Not enough funds"
      );

      // 2. Transfer Eth to the sender and decrement the withdrawal amount from
      //    sender's balance
      balances[msg.sender] -= withdrawAmount;
      emit LogWithdrawal(msg.sender, balances[msg.sender], withdrawAmount);

      return balances[msg.sender];
    }
}
