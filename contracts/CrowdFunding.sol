// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.30;

library ArraysPlus {
    function remove(uint[] storage array, uint value) internal {
        for (uint i = 0; i<array.length; i++) {
            if (array[i]==value) {
                array[i] = array[array.length-1];
                array.pop();
            }
        }
    }
}

contract CrowdFundingMarket {
    /*
    Возможно есть смысл добавить время автоматического завершения краудфандинга после которого средства будут возвращены
    */
    using ArraysPlus for uint[];
    struct CrowdFunding {
        uint crowdFundingId;
        address owner;
        string title;
        uint256 target;   
        uint256 collected;
    }

    struct CrowdFundingsData {
        mapping(address=>uint[]) crowdFunders;
        mapping(uint=>CrowdFunding) crowdFundings;
        uint[] crowdFundingsIds;
        uint lastUsedId;
    }

    CrowdFundingsData public crowdFundingsData;

    function createCrowdFunding(string calldata title, uint target) public {
        CrowdFunding memory _crowdFunding = CrowdFunding(crowdFundingsData.lastUsedId++, msg.sender, title, target, 0);
        crowdFundingsData.crowdFunders[msg.sender].push(_crowdFunding.crowdFundingId);
        crowdFundingsData.crowdFundings[_crowdFunding.crowdFundingId] = _crowdFunding;
        crowdFundingsData.crowdFundingsIds.push(_crowdFunding.crowdFundingId);
    }

    function deleteCrowdFunding(uint _crowdFundingId) private {
        CrowdFunding memory _crowdFunding = crowdFundingsData.crowdFundings[_crowdFundingId];
        require(_crowdFunding.owner==msg.sender, "You are not an owner");
        delete crowdFundingsData.crowdFundings[_crowdFundingId];
        crowdFundingsData.crowdFundingsIds.remove(_crowdFundingId);
    }

    function getCrowdFundingsIds() external view returns (uint[] memory) {
        return crowdFundingsData.crowdFundingsIds;
    }

    function donateToCrowdFunding(uint _crowdFundingId, uint _amount) public {
        // Функционал доната в краудфандинг
    }

    function refuseDonation(uint _crowdFundingId, uint amount) public {
        // Функционал отказа от донатовых. С проверкой на то был ли совершен донат и защитой от ReEntrancy
    }

    function cancelCrowdFunding(uint _crowdFundingId) public {
        // Функционал отмены краудфандинга
    }

}