// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract StreamingPayments {
    struct Stream {
        address sender;
        address recipient;
        uint256 ratePerSecond;
        uint64 start;
        uint64 stop;
        uint256 withdrawn;
    }

    uint256 public nextStreamId = 1;
    mapping(uint256 => Stream) public streams;

    event StreamCreated(uint256 indexed streamId, address indexed sender, address indexed recipient, uint256 ratePerSecond, uint64 start, uint64 stop);
    event StreamWithdrawn(uint256 indexed streamId, uint256 amount);
    event StreamCancelled(uint256 indexed streamId);

    function createStream(address recipient, uint256 ratePerSecond, uint64 duration) external payable returns (uint256 streamId) {
        require(ratePerSecond > 0, "rate must be > 0");
        require(duration > 0, "duration must be > 0");
        uint256 deposit = ratePerSecond * duration;
        require(msg.value == deposit, "incorrect deposit");

        streamId = nextStreamId++;
        streams[streamId] = Stream({
            sender: msg.sender,
            recipient: recipient,
            ratePerSecond: ratePerSecond,
            start: uint64(block.timestamp),
            stop: uint64(block.timestamp + duration),
            withdrawn: 0
        });

        emit StreamCreated(streamId, msg.sender, recipient, ratePerSecond, uint64(block.timestamp), uint64(block.timestamp + duration));
    }

    function withdraw(uint256 streamId) external {
        Stream storage stream = streams[streamId];
        require(stream.recipient == msg.sender, "not recipient");
        uint256 amount = withdrawableAmount(streamId);
        require(amount > 0, "nothing to withdraw");
        stream.withdrawn += amount;
        (bool ok, ) = stream.recipient.call{value: amount}("");
        require(ok, "transfer failed");
        emit StreamWithdrawn(streamId, amount);
    }

    function cancel(uint256 streamId) external {
        Stream storage stream = streams[streamId];
        require(msg.sender == stream.sender || msg.sender == stream.recipient, "not authorized");
        uint256 recipientAmount = withdrawableAmount(streamId);
        uint256 senderRefund = (stream.ratePerSecond * (stream.stop - stream.start)) - stream.withdrawn - recipientAmount;
        delete streams[streamId];

        if (recipientAmount > 0) {
            (bool okRecipient, ) = stream.recipient.call{value: recipientAmount}("");
            require(okRecipient, "recipient transfer failed");
        }

        if (senderRefund > 0) {
            (bool okSender, ) = stream.sender.call{value: senderRefund}("");
            require(okSender, "sender refund failed");
        }

        emit StreamCancelled(streamId);
    }

    function withdrawableAmount(uint256 streamId) public view returns (uint256) {
        Stream memory stream = streams[streamId];
        if (block.timestamp <= stream.start) {
            return 0;
        }
        uint256 elapsed = block.timestamp < stream.stop ? block.timestamp - stream.start : stream.stop - stream.start;
        uint256 totalEntitled = stream.ratePerSecond * elapsed;
        if (totalEntitled <= stream.withdrawn) {
            return 0;
        }
        return totalEntitled - stream.withdrawn;
    }
}
