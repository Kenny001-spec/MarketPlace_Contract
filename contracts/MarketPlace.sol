// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

contract SimpleMarketplace {
    address public admin;

    enum ItemStatus {

        None,
        Created,
        Pending,
        Sold,
        Available
    }

    struct Listing {
        string name;
        uint256 price;
        address payable seller;
        ItemStatus status;
    }

    Listing[] public listings;

    event ItemListed(uint256 indexed itemId, string name, uint256 price, address seller);
    event ItemPurchased(uint256 indexed itemId, address buyer, uint256 price);

    constructor() {
        admin = msg.sender;
    }


    function listItem(string memory _name, uint256 _price) external {
        require(_price > 0, "Price must be greater than zero");

        listings.push(Listing({
            name: _name,
            price: _price,
            seller: payable(msg.sender),
            status: ItemStatus.Available
        }));

        emit ItemListed(listings.length - 1, _name, _price, msg.sender);
    }


    function purchaseItem(uint256 _itemId) external payable {
        require(_itemId < listings.length, "Item does not exist");

        Listing storage listing = listings[_itemId];

        require(listing.status == ItemStatus.Available, "Item is already sold");
        require(msg.value == listing.price, "Incorrect amount sent");

        listing.status = ItemStatus.Sold;
        listing.seller.transfer(msg.value);

        emit ItemPurchased(_itemId, msg.sender, listing.price);
    }


    function getItem(uint256 _itemId)
        external
        view
        returns (string memory, uint256, address, ItemStatus)
    {
        require(_itemId < listings.length, "Item does not exist");

        Listing memory listing = listings[_itemId];
        return (listing.name, listing.price, listing.seller, listing.status);
    }
}
