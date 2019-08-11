#!/usr/bin/env bash

FILE_TO_DECRYPT="$1"
BUCKET_NAME="$2"
PRIVATE_KEY="$3"
B2="/usr/local/bin/b2"

# Download the encrypted file and encrypted one time password from B2.

echo "[b2decrypt] Downloading encrypted file for $FILE_TO_DECRYPT from $BUCKET_NAME"
$B2 download_file_by_name $BUCKET_NAME $FILE_TO_DECRYPT.enc \
	$FILE_TO_DECRYPT.enc
echo "[b2decrypt] Downloading encrypted OTP for $FILE_TO_DECRYPT from $BUCKET_NAME"
$B2 download_file_by_name $BUCKET_NAME $FILE_TO_DECRYPT.key.enc \
	$FILE_TO_DECRYPT.key.enc

# Then, decrypt the file. The command is excuted as one command to
# ensure that the one time password remains in memory and isn't ever
# written to disk in plaintext.

# openssl rsautl -decrypt -inkey $PRIVATE_KEY
# This command decrypts the one time password using the private key.
# This command requires the private key passphrase to be typed into
# the console. Once decrypted, the plaintext one time password is
# passed via stdin to:

# openssl enc -aes-256-cbc -d -a -pass stdin -in \
# $FILE_TO_DECRYPT.enc -out $FILE_TO_DECRYPT
# This command decrypts the file using the one-time password and
# saves to the filesystem.

echo "[b2decrypt] Decrypting with private key: $PRIVATE_KEY"
openssl rsautl -decrypt -inkey $PRIVATE_KEY -in \
	$FILE_TO_DECRYPT.key.enc | \
	openssl enc -aes-256-cbc -d -a -pass stdin -in \
	$FILE_TO_DECRYPT.enc -out $FILE_TO_DECRYPT
