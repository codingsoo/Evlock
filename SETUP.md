작성 중..

## Prerequisites

### node and yarn

알아서 설치

### truffle.js

이거도 알아서

## install dependencies

```bash
$ yarn install
```
## setup .env

.env 파일을 하나 만들어야 하며 개인 키와 컨트렉트 주소가 들어있어야 함. 형식은 아래 참고.

```
PRIVATE_KEY=0xe01d2...
CONTRACT_ADDRESS=0x2e147a...
```

## setup contracts

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
현재 `Truffle v5.0.8`에서 동작하지 않음. https://ide.klaytn.com에서 deploy 필요. 

## start server

default port is 5000

```bash
$ yarn start
```



