---
layout: post
title: Matrix Crypto Terminal
date: 2024-02-03 05:00:00  -500
categories: [python]
tags: [windows,linux,bitcoin,crypto,terminal]
image:
  path: /assets/images/headers/matrix.webp
  alt: Matrix Crypto
---

## Matrix Crypto Terminal Display 💻


The Matrix Crypto Display is a Python-based terminal application that provides a visually appealing display of cryptocurrency information in a matrix-style animation. This project offers two main functionalities: one version displays real-time cryptocurrency prices, and another displays cryptocurrency names without prices for a simplified, aesthetic experience.
Features

-    Real-time Price Updates: Fetch and display the latest cryptocurrency prices in real-time. Uses coingecko public api to get prices every 90 seconds
-    Cryptocurrency Name Display: A no-prices version that focuses on displaying the names of cryptocurrencies.
-    Customizable Display: Users can customize the display speed and color to suit their preferences.
-    Flexible Configuration: Easy configuration through JSON files to specify which cryptocurrencies to display.
-    Command-line Options: Includes options for adjusting display settings directly through command-line arguments.
-   Custom scripts for getting latest crypto ecosystem lists, Top 20 Solana or Ethereum tokens

---


{% include embed/youtube.html id='JbEp2Fjlzb0' %}
📺 [Watch Video](https://www.youtube.com/watch?v=7JbEp2Fjlzb0)



## Windows and Linux Terminal using Python 3.6+

Download python if you don't already have it 
[Python Download](https://www.python.org/downloads/)

## Installation

Clone the Repository

```bash
git clone https://github.com/bigsk1/matrix-crypto.git
cd matrix-crypto
```


## Quick start

### Windows

Double click the run_windows.bat file

### Linux/MacOS

```bash
chmod +x run_linux.sh && ./run_linux.sh
```

if you have trouble running then run

sed -i 's/\r$//' ./run_linux.sh

and try again  ./run_linux.sh

## Manual Install
 Create and Activate a Virtual Environment (Optional but Recommended)

```bash
python -m venv venv
source venv/bin/activate  # On Windows use `venv\Scripts\activate`
```

Install Required Packages

```bash
pip install -r requirements.txt
```
## Usage

```bash
python matrix_crypto.py
```
CTL+C to Exit

## Advanced Usage

Run the application:

```bash
python matrix_crypto.py [--speed SPEED] [--color COLOR] [--bold] [--solana] [--eth]
```

Command-line Options

 --speed: Adjust the speed of the falling text (default is 300, higher is slower).

 --color: Choose the color of the falling text (e.g., green, red, blue).

 --bold: (Price display version only) Display text in bold.

 --solana, --eth: (Price display version only) Use a specific cryptocurrency list (e.g., Solana or Ethereum ecosystems).

Example
```bash
python matrix_crypto.py --color white --bold --eth
```


## Update crypto ecosystem list

Use the prefilled crypto_list.json or modify and add your own tickers
(optional) You can run any of the .py files to get current list of Solana or Ethereum top 20 to populate the .json config
which is to get token id's and names for prices. Only really need to run once in awhile if you want a fresh list. I would remove stable coins like USDC and USDT

- python crypto_list.py = gets top 20 overall cryptos by marketcap (default list of cryptos)

- python solana_crypto_list.py = gets top 20 solana tokens by marketcap

- python ethereum_crypto_list.py = gets top 20 ethereum tokens by marketcap

## Configuration

Edit the crypto_list.json file for the name display version or the respective ecosystem files (e.g., solana_ecosystem_crypto_list.json) for the price display version to customize which cryptocurrencies are shown.

Example configuration for name display:

```json
{
    "speed": 300,
    "color": "green",
    "cryptos": [
        {
            "id": "bitcoin",
            "ticker": "BTC",
            "name": "Bitcoin"
        },
        {
            "id": "ethereum",
            "ticker": "ETH",
            "name": "Ethereum"
        }
    ]
}
```

Customizing the Cryptocurrency List

To modify the list of displayed cryptocurrencies, edit the appropriate .json configuration file by adding or removing entries under the "cryptos" key.

## Logging

The application generates a log file (matrix_crypto.log) to store runtime information, errors, and other log messages. The log is rotated every 10 days to prevent excessive file size.

## Cryptocurrency Name Display only

Run the simplified version that displays only cryptocurrency names under offline-version-no-prices folder:

```bash
python matrix_crypto.py [--speed SPEED] [--color COLOR]
```

## Github

[Matrix-Crypto Github](https://github.com/bigsk1/matrix-crypto)


{% include embed/youtube.html id='I21_yDeOwpk' %}

---

{% include embed/youtube.html id='cUqM0PKzWeU' %}

---

{% include embed/youtube.html id='mo50IZh6VL8' %}

---

{% include embed/youtube.html id='YRX-jYRmNZQ' %}
