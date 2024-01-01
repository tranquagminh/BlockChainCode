// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract FirstCoin {
    address public minter;
    mapping(address => uint) public balances;
    uint public transactionCount;

    struct Transaction {
        address sender;
        address receiver;
        // unsigned integer
        uint amount;
        string transactionMessage;
    }

    mapping(uint => Transaction) public transactions;

    // Mảng để lưu trữ địa chỉ của người nhận
    address[] public receiversList;

    event Sent(address indexed from, address indexed to, uint amount, string transactionMessage);

    constructor() {
        minter = msg.sender;
        transactionCount = 0;
    }

    function mint(address receiver, uint amount) public {
        require(msg.sender == minter);
        require(amount < 1e60);
        balances[receiver] += amount;

        emit Sent(address(0), receiver, amount, "Minted");
    }

    function send(address receiver, uint amount, string memory transactionMessage) public {
    require(amount <= balances[msg.sender], "Khong du tien");

    balances[msg.sender] -= amount;
    balances[receiver] += amount;

    emit Sent(msg.sender, receiver, amount, transactionMessage);

    // Kiểm tra xem địa chỉ đã tồn tại trong mảng hay chưa
    bool addressExists = false;
    for (uint i = 0; i < receiversList.length; i++) {
        if (receiversList[i] == receiver) {
            addressExists = true;
            break;
        }
    }

    // Nếu địa chỉ chưa tồn tại, thêm nó vào mảng
    if (!addressExists) {
        receiversList.push(receiver);
    }

    transactions[transactionCount] = Transaction({
        sender: msg.sender,
        receiver: receiver,
        amount: amount,
        transactionMessage: transactionMessage
    });

    transactionCount++;
    }

    // Show các địa chỉ người nhận
    function getAllReceivers() public view returns (address[] memory) {
        return receiversList;
    }

    // Chi tiết giao dịch
    function getTransactionDetails(uint transactionId) public view returns (
        address sender,
        address receiver,
        uint amount,
        string memory transactionMessage
    ) {
        require(transactionId < transactionCount, "ID khong hop le");
        Transaction storage transaction = transactions[transactionId];
        return (
            transaction.sender,
            transaction.receiver,
            transaction.amount,
            transaction.transactionMessage
        );
    }
}

