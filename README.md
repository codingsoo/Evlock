# Secure Klaytn-based Energy Trading System using ARM TrustZone

## Introduction

 Due to the emergence of people who can generate their own energy from Renewable Energy Sources (RESs), and the problems of central management overhead, peer-to-peer (P2P) energy trading has become a promising technology in smart grids. Booming of blockchain technology has boosted the research and development of P2P energy trading. At the same time, in the absence of a central authority, the critical issue of providing security for transactions arises in decentralized systems. While research and development pertaining to the smart grid is prolific, we have observed that research into security issues in energy transactions is still limited. In this paper, we identify four security issues in the smart grid, and identify some limitations of current P2P energy platforms. We propose to solve these security issues using blockchain technology, Transport Layer Security (TLS) cryptographic protocols and hardware support from ARM Trustzone. We demonstrate an implementation of a  smart grid node based on a Klaytn smart contract using a Samsung ARTIK Internet-of-Things (IoT) platform, a solar panel, a rechargeable battery, and a smartphone.

## Security Issues

 We investigate security issues in P2P Energy Trading Platforms and divide them into four categories: Device Security, Network, Trade System, and Data Security. The possible security issues in P2P energy trading platforms are collected from existing researches.

![security_issues_p2p_energy_trading](https://github.com/klaytn-hackathon/Evlock/blob/master/pictures/security_issues.png)


## Software Architecture

![software_architecture](https://github.com/klaytn-hackathon/Evlock/blob/master/pictures/software_architecture.PNG)  
We use ethereum smart contract as a mediator. All communication is protected by TLS, and device is guarded by ARM TrustZone.

## Hardware Architecture

![hardware_architecture](https://github.com/klaytn-hackathon/Evlock/blob/master/pictures/hardware_architecture.png)  
The hardware system is composed of an ARTIK 710s platform, AS0437 Relay Module, ACS712 Current Measurement Sensor, a smartphone, a rechargeable battery, and a solar panel.
