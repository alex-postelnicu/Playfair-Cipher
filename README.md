# Playfair Cipher
Playfair cipher encoder and decoder implemented in x86 Assembly

## Overview

This project implements a variant of the Playfair cipher in x86 Assembly. It supports both encoding and decoding messages using a 5×5 key matrix, with a focus on low-level string manipulation and memory addressing without relying on high-level libraries.

## Features

- Playfair cipher encoding
- Playfair cipher decoding
- 5×5 key matrix generation
- Duplicate character removal when constructing the matrix
- `J` → `I` character replacement
- Message preprocessing that removes spaces, splits the message into character pairs, inserts `X` between identical characters in a pair and adds `X` if the length of the message is odd
- Terminal-based input and output

## Playfair Cipher

The cipher uses a 5x5 matrix built from a key the user chooses.
The matrix is filled by:
1. Adding the characters from the key without duplicates
2. Replacing `J` with `I`
3. Filling the remaining positions with the unused letters of the English alphabet

## Encoding and Decoding

For each pair of characters:
- If both characters are on the same row, they are replaced by the characters to their right when encoding and to their left when decoding
- If both characters are in the same column, they are replaced by the characters below when encoding and above when decoding
- Otherwise, the characters form the corners of a rectangle and are replaced by the characters at the opposite corners
- Row and column operations wrap around when reaching the edge of the matrix

## Input Format

The program reads three distinct lines from standard input:
1. `codare` or `decodare` (specifies the operation mode)
2. The encryption/decryption key
3. The message to process
