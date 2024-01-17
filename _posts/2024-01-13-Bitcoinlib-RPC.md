---
title: Send a Message in Bitcoin Transactions
date: 2024-1-13 12:00:00  -500
categories: [bitcoin]
tags: [bitcoin,python,linux] 
image:
  path: /assets/images/headers/bitcoinlib_header.webp
---

## Bitcoinlib RPC Project
So I wanted to see if I could add a message in a bitcoin transaction and have it permanently on the blockchain. The recent hack with the SEC's twitter account and post of the bitcoin Spot ETF was kinda funny considering the SEC didn't secure there account with 2fa and they had a post recently about security and recommending just that using 2fa online. 

![Image](/assets/images/sec_twitter.webp)
[https://twitter.com/SECGov/status/1744837121406349714](https://twitter.com/SECGov/status/1744837121406349714)

So I went about trying to do this with no experiance adding a message in a bitcoin transaction. I'm sure there are tools or wallets out there that would make this process easy, but I wondered if I could do this in python and also use my own bitcoin node. Also building something new can be fun. 

Searching for python options I found bitcoinlib on github a library for creating and managing bitcoin wallets with quite a few stars and contributors. I was pretty straight forward to make a wallet and get the first public key address and private key, which I made a script shown in the instructions below. 

Once I sent a few sats to the public address and checked on the block explorer I was ready to create a transaction, sign it, add a message using the OP_RETURN method and send it to another address I own.

I was able to add the RPC local network connection to use my own node ( umbrel OS ) but I'm sure citidel or raspiblitz or others would also work just need the RPC creds, I'm also sure you could use the RPC connection on a public clearnet ip if you have the correct https certs setup but that involves a deeper dive and modifying the script. 

Once the script ran succesfully I got a TXID along with the Raw Hex code and instantly (cause my vsat was high enough to get into the next block) got a notification on my other wallet so I knew it was a success. 

Copying the TXID and pasting it into the bitcoin block explorer you can see the details and the OP_RETURN message and in my case was the twitter url to the SEC post. 

---

## What the scripts do

Allows you to use your locally hosted Bitcoin node (like Umbrel) and bitcoinlib in Python to create a wallet and send `OP_RETURN` message in a Bitcoin transaction with small changes in the python files by adding your info.

Used with Linux ( tested in WSL2 Ubuntu on one machine and umbrel bitcoin node on your local network like a Raspiberry Pi ) below is an example of a successful transaction.

![Image](/assets/images/OP_RETURN_message.png)

[mempool block explorer btc transaction](https://mempool.space/tx/aceee291b364905098aa28019c6521b9941daa1104772bad358e1334e1bd19a7)

Another bitcoin block explorer is opreturn.net which shows the op_return messages better 

[OpReturn block explorer btc transaction](https://opreturn.net/aceee291b364905098aa28019c6521b9941daa1104772bad358e1334e1bd19a7)

## Overview

- Create a new wallet and generate a text file with wallet name, public address, and private key.
- Modify Python files to add your details.
- Run a curl command to test RPC connection to your node.
- Send a small amount of funds to your new wallet to cover the outgoing transaction and fees.
- Run a script to get updated info about your wallet.
- Run a script to send a transaction with your message.
- Check the block explorer with the TXID to see your message.

## Installation and Setup

- Install Python 3.10 (3.11 might work but is untested). You can create a conda environment with Python 3.10.4.
- Install bitcoinlib: `pip install bitcoinlib`
- Install required dependencies: `sudo apt install build-essential python3-dev libgmp3-dev`

## Create Wallet

- Open `create_test_wallet.py` and change the wallet name at the bottom (avoid spaces).
- Run `python create_test_wallet.py`
- You will get a `.txt` file with wallet details, including the private key in WIF format.

## Set Environment Variables

Added your details and run the following to your terminal or you can add the secrets to your `.bashrc`
If using umbrel or similar select bitcoin node, connect, RPC local network credintials

```bash
export BITCOIN_NODE_HOST='your_node_ip'
export BITCOIN_NODE_PORT='your_node_port'
export BITCOIN_RPC_USERNAME='your_rpc_username'
export BITCOIN_RPC_PASSWORD='your_rpc_password'
export MY_BTC_PRIVATE_KEY='your_private_key_here'
```

## Configure Bitcoin RPC Connection in bitcoinlib

- Edit ~/.bitcoinlib/bitcoin.conf and add your details:

```bash
[rpc]
rpcconnect=192.168.x.xx
rpcport=8332
rpcuser=umbrel
rpcpassword=XXXXXXXXXXXXXXXXXXXXXXXXXX
txindex=1
server=1
```

## Test RPC Connection

- Run the following curl command to check if the RPC connection is working (fill in your username, password, IP, and port):

```bash
curl --user rpc_user_name:rpc_password --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getblockchaininfo", "params": [] }' -H 'content-type: text/plain;' http://ip:port/
```

## Fund Your Wallet

- Send funds to your new wallet's public address (from the .txt file). Make sure to send enough to cover the amount you send out of the wallet + mining fees, you can check current mempool fees before sending at [https://mempool.space/](https://mempool.space/)
- Wait for confirmations on a block explorer or run `python wallet_scan_details.py` (enter the correct wallet name inside file).

## Prepare and Send Transaction

- Open btcmessage_rpc.py , look under Configuration code block
- Add your wallet name, public address, sender's address, fee, sending amounts, and your message (less than 80 bytes). Note the amount to send and fees are in btc like (0.001), so use a calculator to convert BTC to USD,  [https://coinmarketcap.com/converter/btc/usd](https://coinmarketcap.com/converter/btc/usd)
- Run the script to send your transaction when ready.

Run `python btcmessage_rpc.py`  This script uses the wallet you created in bitcoinlib, gets it up to date with UTXOs, creates the transaction, extracts the raw transaction hex, and then sends it to your Bitcoin node for broadcasting. If successful, you will see the TXID and the raw transaction hex.

Copy your TXID and paste it in a block explorer like Mempool [https://mempool.space/](https://mempool.space/) to see your OP_RETURN message and details.

## Github Repo
Github repo: [https://github.com/bigsk1/bitcoinlib_rpc](https://github.com/bigsk1/bitcoinlib_rpc)