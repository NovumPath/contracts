:: Contract preparation steps
node .\members\setContractAddress.js
node .\creatives\setContractAddress.js
node .\utilities\setContractAddress.js
node .\utilities\changeMembersAddress.js
node .\creatives\changeMembersAddress.js
node .\utilities\changeTokenAddress.js

:: Bidder registration steps
node .\members\allowBidders.js true
node .\members\registerMember.js
node .\members\allowBidders.js false

:: Deposit, withdraw and fine functionality
node .\token\balanceOf.js
node .\token\transfer.js 100000
node .\token\approve.js 0x1563915e194D8CfBA1943570603F7606A3115508 100000
node .\utilities\makeDeposit.js
node .\utilities\getDeposit.js
node .\token\balanceOf.js 0x1563915e194D8CfBA1943570603F7606A3115508
node .\utilities\withdrawDeposit.js
node .\token\balanceOf.js 0x1563915e194D8CfBA1943570603F7606A3115508
node .\utilities\fineDeposit.js
node .\utilities\getDeposit.js
node .\token\balanceOf.js

:: Payment functionality
node .\token\approve.js 0x1563915e194D8CfBA1943570603F7606A3115508 100000
node .\utilities\makePaymentToBidder.js
node .\token\balanceOf.js 0x1563915e194D8CfBA1943570603F7606A3115508
node .\token\approve.js 0x19e7e376e7c213b7e7e7e46cc70a5dd086daff2a 100000
node .\utilities\makePaymentToPublisher.js
node .\token\balanceOf.js 0x5CbDd86a2FA8Dc4bDdd8a8f69dBa48572EeC07FB

:: Member functionality
node .\members\getMember.js
node .\members\getMemberRole.js
node .\members\blockMember.js
node .\members\unblockMember.js
node .\members\participateInVoting.js
node .\members\getMember.js
node .\members\changeInformation.js
node .\members\getMember.js

:: Creatives functionality
node .\creatives\getCreatives.js
node .\creatives\announceCreative.js
node .\creatives\announceCreatives.js
node .\creatives\getCreatives.js
node .\creatives\changeInitialThreshold.js
node .\creatives\changeThresholdStep.js