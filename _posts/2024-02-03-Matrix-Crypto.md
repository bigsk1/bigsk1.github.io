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


{% include embed/youtube.html id='HOkN3hmoXzs' %}
📺 [Watch Video](https://www.youtube.com/watch?v=HOkN3hmoXzs)



Download python if you don't already have it
[Python Download](https://www.python.org/downloads/release/python-3117/)

## Installation

Clone the Repository

```bash
git clone https://github.com/bigsk1/matrix-crypto.git
cd matrix-crypto
```

## Quick start

### Windows

Double click the run_windows.bat file

If having trouble, Windows users might need to manually download and use Miniconda with python=3.11.4 and run:

```bash
pip install -r requirements.txt
```

### Linux/MacOS

```bash
chmod +x run_linux.sh && ./run_linux.sh
```

If you have trouble running then run:

```bash
sed -i 's/\r$//' ./run_linux.sh
```

And try again:

```bash
./run_linux.sh
```

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


### Add to bashrc or zshrc ( optional for linux )

Want to type matrixc and start the script? cmatrix but for crypto!!!

Ensure your script is executable. Navigate to the directory where your matrix_crypto.py script is located and run:

```bash
chmod +x matrix_crypto.py
```

Open your .zshrc or .bashrc file in a text editor and update your path:

```bash
alias matrixc='cd /path/to/matrix-crypto && python matrix_crypto.py'
```

Replace /path/to/matrix-crypto/matrix_crypto.py with the actual path to your script. 

```bash
source ~/.zshrc
```

Now you can run your script from anywhere in the terminal by typing:

```bash
matrixc
```


## Advanced Usage

Run the application:

```bash
python matrix_crypto.py [--bg-color BG_COLOR] [--crypto-color CRYPTO_COLOR] [--solana] [--eth]
```

Command-line Options

- --bg-color: Adjust the color of the falling background text (e.g., green, red, blue).
- --crypto-color: Choose the color of the crypto tickers (e.g., white, yellow, cyan).
- --solana, --eth: Use a specific cryptocurrency list (e.g., Solana or Ethereum ecosystems).

Example:

```bash
python matrix_crypto.py --bg-color red --crypto-color yellow --eth
```

## Update crypto ecosystem list

Use the prefilled crypto_list.json or modify and add your own tickers.
(Optional) You can run any of the .py files to get the current list of Solana or Ethereum top 20 to populate the .json config, which is to get token IDs and names for prices. Only really need to run once in a while if you want a fresh list. I would remove stable coins like USDC and USDT.

- `python crypto_list.py`: Gets top 20 overall cryptos by market cap (default list of cryptos).
- `python solana_crypto_list.py`: Gets top 20 Solana tokens by market cap.
- `python ethereum_crypto_list.py`: Gets top 20 Ethereum tokens by market cap.

## Configuration

Edit the `crypto_list.json` file for the name display version or the respective ecosystem files (e.g., `solana_ecosystem_crypto_list.json`) for the price display version to customize which cryptocurrencies are shown.

Example configuration for name display:

```json
{
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

## Settings changes 

You can directly change settings in the maxtrix_crypto.py file to fine tune the look your after! 

```python
# User-configurable settings
SETTINGS = {
    'ANIMATION_SPEED': 0.01,  # Lower is faster, higher is slower. This is the delay between frames in seconds.
    'BACKGROUND_PATTERN': [1, 2, 3, 2],  # Gap widths pattern.
    'BACKGROUND_CHARS': 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=[]{}|;:,.<>?/',
    'CRYPTO_DISPLAY_COUNT': 4,  # Maximum number of crypto prices displayed simultaneously.
    'CRYPTO_DISPLAY_CHANCE': 0.1,  # Chance of new crypto display appearing each frame.
    'FADE_LENGTH': 0,  # Length of fade effect at top and bottom in number of characters.
    'BACKGROUND_INTENSITY_LEVELS': 3,  # Number of intensity levels for background.
    'CRYPTO_FALL_SPEED_RANGE': (0.1, 0.2),  # Min and max fall speed for crypto displays in seconds.
    'BACKGROUND_CHANGE_CHANCE': 0.2,  # Chance of a background character changing each update.
    'BACKGROUND_FALL_SPEED_RANGE': (0.06, 0.1),  # Min and max fall speed for background characters in seconds.
    'BACKGROUND_COLUMN_LENGTH_RANGE': (0.3, 0.7),  # Min and max length of background columns as a fraction of screen height.
    'BACKGROUND_COLUMN_GAP_RANGE': (0.2, 0.3),  # Min and max gap between columns as a fraction of screen height.
    'LEAD_CHAR_COLOR': curses.COLOR_WHITE,  # Color of the leading character in each column.
    'LEAD_CHAR_CHANCE': 1,  # Chance of a new leading character appearing when the column updates.
    'CRYPTO_COLOR': 'white',  # Default color for crypto tickers
}
```


## Logging

The application generates a log file (matrix_crypto.log) to store runtime information, errors, and other log messages. The log is rotated every 10 days to prevent excessive file size.

## Cryptocurrency Name Display Only

Run the simplified version that displays only cryptocurrency names under the `offline-version-no-prices` folder:

```bash
python matrix_crypto.py [--bg-color BG_COLOR] [--crypto-color CRYPTO_COLOR]
```


---



## Sample Command-Line Combinations

Below are some sample command-line combinations you can use to run the `matrix_crypto.py` script with various options. Each command is provided in a code block for easy copying.

### Default Run (without any arguments)
```bash
python matrix_crypto.py
```

### Custom Background Color

- Green background (default)
```bash
python matrix_crypto.py --bg-color green
```

- Red background
```bash
python matrix_crypto.py --bg-color red
```

- Blue background
```bash
python matrix_crypto.py --bg-color blue
```

- Yellow background
```bash
python matrix_crypto.py --bg-color yellow
```

### Custom Crypto Ticker Color

- White ticker (default)
```bash
python matrix_crypto.py --crypto-color white
```

- Yellow ticker
```bash
python matrix_crypto.py --crypto-color yellow
```

- Cyan ticker
```bash
python matrix_crypto.py --crypto-color cyan
```

- Magenta ticker
```bash
python matrix_crypto.py --crypto-color magenta
```

### Using Different Crypto Lists

- Use Solana ecosystem crypto list
```bash
python matrix_crypto.py --solana
```

- Use Ethereum ecosystem crypto list
```bash
python matrix_crypto.py --eth
```

### Combination of Arguments

- Red background with yellow ticker and Solana crypto list
```bash
python matrix_crypto.py --bg-color red --crypto-color yellow --solana
```

- Blue background with cyan ticker and Ethereum crypto list
```bash
python matrix_crypto.py --bg-color blue --crypto-color cyan --eth
```

- Green background with magenta ticker and Solana crypto list
```bash
python matrix_crypto.py --bg-color green --crypto-color magenta --solana
```

### Additional Custom Combinations

- Yellow background with white ticker
```bash
python matrix_crypto.py --bg-color yellow --crypto-color white
```

- Cyan background with red ticker
```bash
python matrix_crypto.py --bg-color cyan --crypto-color red
```

- Magenta background with blue ticker
```bash
python matrix_crypto.py --bg-color magenta --crypto-color blue
```