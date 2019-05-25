# Evlock - A secure Klaytn-based energy trading system

## Introduction

 Due to the emergence of people who can generate their own energy from Renewable Energy Sources (RESs), and the problems of central management overhead, peer-to-peer (P2P) energy trading has become a promising technology in smart grids. Blockchain technology has become popular in P2P transactions because of its disintermediation, transparency, tamper-proof transactions, and ensuring privacy and anonymity features. According to a report by Eurelectric in 2017, the Union of the electricity industry, more than 1000 projects are currently using Ethereum [1]. While research and development pertaining to the blockchain-based energy trading is prolific, we have observed that research into security issues is still limited. In this project, we identify 35 security issues in the blockchain-based P2P energy transactions, and show some limitations of current studies. We propose to solve these security issues using blockchain technology, Transport Layer Security (TLS) cryptographic protocols, sensor checking modules, and hardware support from ARM Trustzone. We demonstrate an implementation of a smart grid node based on a Klaytn smart contract using a Samsung ARTIK Internet-of-Things (IoT) platform, a solar panel, a rechargeable battery, and a smartphone.

 [1] Eurelectric. Eurelectric launches expert discussion platform on blockchain, 〈http://www.eurelectric.org/news/2017/eurelectric-launches-expert-discussion-platform-on-blockchain/〉, [accessed 25 May 2019].

## Security Issues

 We investigate security issues in P2P Energy Trading Platforms and divide them into four categories: Device Security, Network, Trade System, and Data Security. The possible security issues in P2P energy trading platforms are collected from existing researches.

![security_issues_p2p_energy_trading](https://github.com/klaytn-hackathon/Evlock/blob/master/pictures/security_issues.png)


## Software Architecture

![software_architecture](https://github.com/klaytn-hackathon/Evlock/blob/master/pictures/software_architecture.PNG)  
We use ethereum smart contract as a mediator. All communication is protected by TLS, and device is guarded by ARM TrustZone.

## Hardware Architecture

![hardware_architecture](https://github.com/klaytn-hackathon/Evlock/blob/master/pictures/hardware_architecture.png)  
The hardware system is composed of an ARTIK 710s platform, AS0437 Relay Module, ACS712 Current Measurement Sensor, a smartphone, a rechargeable battery, and a solar panel.
