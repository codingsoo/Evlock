작성 중..

## Prerequisites

### node and yarn

알아서 설치

### truffle.js

```bash
npm install -g truffle@4.1.15
```

## Install Dependencies

```bash
$ yarn install
```

## Setup Environment Variables

`.env` 파일을 하나 만들어야 하며 개인 키와 컨트렉트 주소가 들어있어야 함. 형식은 아래 참고.

```
PRIVATE_KEY=0xe01d2...
CONTRACT_ADDRESS=0x2e147a...
```

## Setup Contracts

### compile contracts

```bash
$ yarn compile
```

It's will be `truffle compile`

### deploy contracts

```bash
$ yarn deploy
```

compile reset도 같이 하며 주소를 `.env`에 저장함.  

## Start Server

default port is 5000

```bash
$ yarn start
```



