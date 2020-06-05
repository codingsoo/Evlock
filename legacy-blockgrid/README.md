# Implementation of Blockchain-based Secure Energy Trading System using ARM TrustZone

## Why do we make this?

While research and development is prolific in smart grid, there are only few research in security issues in energy transaction. In this project, we identify four security issues in smart grid and limitations of current P2P energy platforms - Trust, Communication Security, Device security, Privacy. We propose to solve security issues using blockchain technology, Transport Layer Security (TLS) cryptographic protocol and hardware support from ARM Trustzone. We demonstrate an implementation of a such smart grid node, based on Ethereum smart contract using a Samsung ARTIK Internet-of-Things (IoT) platform, a solar panel, a rechargeable battery, and a smartphone.

## Four Security Issues

- Trust : The participant in the transaction should be able to verify self and the user in opposite side of transaction.
- Communication Security : Safe communication sould be available.
- Device Security : Device should be protected.
- Privacy : We should prevent from disclosing the use pattern of electricity, specific user’s behavior could be revealed.

## Software Architecture

![software_architecture](https://github.com/EVlock/Blockgrid/blob/master/pictures/software_architecture.PNG)  
We use ethereum smart contract as a mediator. All communication is protected by TLS, and device is guarded by ARM TrustZone.

## Hardware Architecture

![hardware_architecture](https://github.com/EVlock/Blockgrid/blob/master/pictures/hardware_architecture.png)  
The hardware system is composed of an ARTIK 710s platform, AS0437 Relay Module, ACS712 Current Measurement Sensor, a smartphone, a rechargeable battery, and a solar panel.
