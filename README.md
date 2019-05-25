# Evlock - A secure Klaytn-based energy trading system

## Introduction

 Due to the emergence of people who can generate their own energy from Renewable Energy Sources (RESs), and the problems of central management overhead, peer-to-peer (P2P) energy trading has become a promising technology in smart grids. Blockchain technology has become popular in P2P transactions because of its disintermediation, transparency, tamper-proof transactions, and ensuring privacy and anonymity features. According to a report by Eurelectric in 2017, the Union of the electricity industry, more than 1000 projects are currently using Ethereum [1]. While research and development pertaining to the blockchain-based energy trading is prolific, we have observed that research into security issues is still limited. In this project, we identify 35 security issues in the blockchain-based P2P energy transactions, and show some limitations of current studies. We propose to solve these security issues using blockchain technology, Transport Layer Security (TLS) cryptographic protocols, sensor checking modules, and hardware support from ARM Trustzone. We demonstrate an implementation of a smart grid node based on a Klaytn smart contract using a Samsung ARTIK Internet-of-Things (IoT) platform, a solar panel, a rechargeable battery, and a smartphone.

 [1] Eurelectric. Eurelectric launches expert discussion platform on blockchain, 〈http://www.eurelectric.org/news/2017/eurelectric-launches-expert-discussion-platform-on-blockchain/〉, [accessed 25 May 2019].

## Security Issues

 We investigate security issues in P2P Energy Trading Platforms and divide them into four categories: Device Security, Network, Trade System, and Data Security. The possible security issues in P2P energy trading platforms are collected from existing researches [1, 2, 3].

![security_issues_p2p_energy_trading](https://github.com/klaytn-hackathon/Evlock/blob/master/pictures/security_issues.png)

<details>
<summary> Expand descriptions and goals of security issues </summary>
<div markdown="1">

|Number|Description|Goal|
|--|--|--|
|1|This attack causes the value change of some registers that hold calibration parameters to make erroneous measurement adjustments during sensor's operation.|In the case of a Buyer, hackers adjust the current measurement sensor so that even if the hackers send less current, the buyer feels as if he or she has received more current. For Sellers, hackers lower the current measurement sensor to make them send more current to the hackers. It could be also performed for terror purpose.|
|2|This is an attack that physically damages or adjusts the sensor to cause the wrong recognition of power sales/purchase information.|In the case of a Buyer, hackers adjust the current measurement sensor so that even if the hackers send less current, the buyer feels as if he or she has received more current. For Sellers, hackers lower the current measurement sensor to make them send more current to the hackers. It could be also performed for terror purpose.|
|3|This attack makes the content of the energy accumulation registers to be removed. |Each time the amount of energy is read, it is executed to make it appear that little energy is stored and cannot be sold. An erroneous behavior also could be found.|
|4|This attack puts the sensor into sleep mode, so that no measurements are taken. While in sleep mode, the sensor SPI interface still replies to the processor module, but the energy consumption is not accumulated.|The value cannot be read from the sensors and therefore the transaction cannot be made.|
|5|It Changes the wires connected to your ESS to be charged elsewhere.|Some, or all, of the electrical wiring is changed by the hacker to his or her home so that the ESS in the hacker's home is charged when the power deal takes place at the victim's home.|
|6|Hackers put malicious data or codes into the memory directly.|By putting malicious codes into the memory directly, the hacker can access critical data, monitor user key input, and connect remotely to steal user information.|
|7|Poor seed randomness helps hackers make public/private key-pair|Hackers can create public/private key-pair identical to victim’s to hijack transaction and signature.|
|8|When a hash value is given, look for the input value to output the hash value.|The hash function is often used to authenticate data. These attacks are aimed at destroying hash functions and invalidating encryption so that data can be manipulated, faked authentication.|
|9|When an input value is given, look for another input that outputs hash values such as that input.|The hash function is often used to authenticate data. These attacks are aimed at destroying hash functions and invalidating encryption so that data can be manipulated, faked authentication.|
|10|This attack tries to find two inputs producing the same hash value.|The hash function is often used to authenticate data. These attacks are aimed at destroying hash functions and invalidating encryption so that data can be manipulated, faked authentication.|
|11|This attack involves a middleman breaking in between two people connecting the communication, who think they have connected to the other side, but in reality the two are connected to the middleman.|The middleman eavesdrops and manipulates the information delivered from one side and forwards it to the other.|
|12|It is a hacking method that uses computer programs or computer hardware that can intercept or record traffic through a digital network or part of a network.|Similar to man in the middle attack, the purpose is to see important information such as ID and password.|
|13|Anyone can view other people's transactions on the Blockchain network. This attack analyzes the transaction patterns of etherium network accounts, matches them with people with similar patterns,|By monitoring specific users, privacy is violated. Homes which has rarely trade history can be considered deserted, so they would be easily targeted.|
|14|This attack occurs when an actor acts as several separate entities. Since many distributed systems have no form of identity management beyond the account, any actor can create unlimited accounts.|Because many distributed systems have no form of identity management beyond accounts, a user can make a lot of accounts in P2P network to gain control of the network.|
|15|If attacker could have majority of computational power, he could reverse and alter transactions in Ethereum. |This attack manipulates the transaction and causes double-spending.|
|16|A Denial of Service (DoS) attack is a malicious attempt to adversely affect the availability of target systems, such as websites or applications, and legitimate end users. Typically, an attacker generates a large amount of packets or requests.|The attacks paralyze and disable the network. Hackers sometimes demand money from service providers in return for stopping the attacks.|
|17|This attack increases the size of transactions by artificially padding valid transactions inside each other.|The attacks paralyze and disable the network.|
|18|An attacker can send illegal content via message or insert illegal content into a transaction to broadcast it on the network.|The purpose of this is to record what is not legally permissible on the blockchain network. This includes illegally writing books that are banned or copyrighted.|
|19|Finney attack is an attack that must cooperate with a malicious minor. 1.The Miner creates new blocks, including transactions from the attacker's wallet address (A) to another attacker's wallet address (B), and has not broadcast them. 2.Pay from the attacker's purse address (A) to the victim's purse address (C), buy electricity and leave. 3.If attacker B broadcasts a new block, invalidate an unidentified transaction (A→C).|It is a double spending attack. The goal is to purchase power without spending.|
|20|Race Attack is an attack that takes advantage of the fact that only one faster transaction is accepted in the network. 1.When purchasing a product to a seller (the victim), it sends two transactions in rapid succession.
Transaction1-Transfer from attacker wallet address (A) to other attacker's wallet address (B) Transaction2-Transfer from attacker wallet address (A) to seller's wallet address (C) 2.The attacker takes the electicity and leaves. 3.The transaction with the seller is canceled with a probability of one-half, depending on the transaction that was first accepted by the other nodes, and no cryptocurrency is obtained.
|It is a double spending attack. The goal is to purchase power without spending.|
|21|This is an issue when allowing a new call to a call contract before the initial execution of an external contract call is completed.|Hackers get the money by repeatedly executing the code which withdraws the money.|
|22|This is a problem that uses timestamp as an important part of the code. Timestamp could be manipulated by minors.|Hackers manipulate timestamp to earn undue profits.|
|23|There is a moment in the memory pool before the behavior of smart contracts appears in the Ethereum network. |It's a way for hackers to know and use transaction information illegally.|
|24|This issue is generated by mishandled exceptions such as underflow and overflow. This makes unexpected behaviors in smart contract.|Hackers may not actually meet the conditions set by the smart contract author, but may be checked as satisfied, resulting in unexpected code execution.|
|25|This is a problems that arise when a function that is not accessible is accessible to users who are not allowed to access it.|Hackers are able to own smart contracts. They can drain all of the money which smart contract has.|
|26|tx.origin can set the attacker’s address as the owner of the contract. The attacker obtains full access to the smart contract funds. It should be removed from critical authorization point.|Hackers are able to own smart contracts. They can drain all of the money which smart contract has.|
|27|This is a problem that stops smart contracts from operating by reaching the Gas Limit.|This attack disables the smart contract.|
|28|This is a problem that smart contract uses blockhach for an important code part.|Minors can manipulate it and change the output to their favor.|
|29|This is an attack that the buyer or seller fakes trade system. A typical example is to pretend to have paid money or current, but not actually send it.|This is an attack that the buyer receiving power without paying the seller, or the seller receiving the money gives less power to the buyer.|
|30|An adversary makes an attack by manipulating data from a set of smart meters.|The goal of this attack is influencing revenues of the market.|
|31|Before the smart meter sends the checksum, the hacker attempts to forward pre-computed checksum.|While the defense mechanism investigates changed memory addresses, the attacker can change a position in memory where it stores the original values.|
|32|This is an attack which attempts to speed up checksum computation.|The goal of this attack is to perform another illegal operation during extra time.|
|33|This attack is a cyber-attack in control and commands, and bulk data.|To make undue profits by demanding data as hostages or deceiving victims' smart meters with false data. Hackers make undue profits by demanding money for their data as hostages or deceiving their smart meters with false data.|
|34|This attack is the act of planting reporting software into a smart meter or reading information through hacking into a smart meter.|The purpose is to read the user's confidential information and to violate privacy.|
|35|This attack secretly or stealthily listen to the smart meter's private conversation or communications without any consent.|The purpose is to read the user's confidential information and to violate privacy.|

</div>
</details>


[1] HALIM, Fatemeh; YUSSOF, Salman; RUSLI, Mohd Ezanee. Cyber Security Issues in Smart Meter and Their Solutions. International Journal of Computer Science and Network Security, 2018, 18.3: 99-109.
[2] AITZHAN, Nurzhan Zhumabekuly; SVETINOVIC, Davor. Security and privacy in decentralized energy trading through multi-signatures, blockchain and anonymous messaging streams. IEEE Transactions on Dependable and Secure Computing, 2018, 15.5: 840-852.
[3] DIKA, Ardit. Ethereum Smart Contracts: Security Vulnerabilities and Security Tools. 2017. Master's Thesis. NTNU.

## Software Architecture

![software_architecture](https://github.com/klaytn-hackathon/Evlock/blob/master/pictures/software_architecture.PNG)  
We use ethereum smart contract as a mediator. All communication is protected by TLS, and device is guarded by ARM TrustZone.

## Hardware Architecture

![hardware_architecture](https://github.com/klaytn-hackathon/Evlock/blob/master/pictures/hardware_architecture.png)  
The hardware system is composed of an ARTIK 710s platform, AS0437 Relay Module, ACS712 Current Measurement Sensor, a smartphone, a rechargeable battery, and a solar panel.
