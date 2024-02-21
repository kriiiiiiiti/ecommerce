// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ecommerce {
    struct Item {
        uint256 id;
        string name;
        uint256 price;
        bool available;
    }

    mapping(uint256 => Item) public items;
    uint256 public itemCount;

    event ItemAdded(uint256 id, string name, uint256 price);
    event ItemFetched(uint256 id);

    constructor() {
        itemCount = 0;
    }

    function addItem(string memory _name, uint256 _price) external {
        itemCount++;
        items[itemCount] = Item(itemCount, _name, _price, true);
        emit ItemAdded(itemCount, _name, _price);
    }

   function fetchItems(uint256[] calldata _ids) external payable {
    uint256 totalPrice = 0;

    for (uint256 i = 0; i < _ids.length; i++) {
        uint256 itemId = _ids[i];
        require(itemId > 0 && itemId <= itemCount, "Invalid item ID");
        require(items[itemId].available, "Item not available");
        totalPrice += items[itemId].price;

        
        items[itemId].available = false;

       
        emit ItemFetched(itemId);
    }

    
    require(msg.value >= totalPrice, "Insufficient funds");

    
    payable(msg.sender).transfer(totalPrice);
}
address payable owner;



modifier onlyOwner() {
    require(msg.sender == owner, "Only the contract owner can call this function");
    _;
}

function withdraw() external onlyOwner {
    payable(owner).transfer(address(this).balance);
}
 function addItem2(string memory _name, uint256 _price) external onlyOwner {
        itemCount++;
        items[itemCount] = Item(itemCount, _name, _price, true);
        emit ItemAdded(itemCount, _name, _price);
    }
function sortItemsById() external {
        for (uint256 i = 0; i < itemCount - 1; i++) {
            for (uint256 j = 0; j < itemCount - i - 1; j++) {
                if (items[j].id > items[j + 1].id) {
                    
                    Item memory temp = items[j];
                    items[j] = items[j + 1];
                    items[j + 1] = temp;
                }
            }
        }

}
