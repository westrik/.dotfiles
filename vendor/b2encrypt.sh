#!/usr/bin/env bash

FILE_TO_ENCRYPT="$1"
B2_BUCKET_NAME="$2"
PUBLIC_KEY="$3"
B2="/usr/local/bin/b2"

# Generate a one-time per file password that's 180 characters long.
# Save it into RAM only for use by subsequent commands.

ONE_TIME_PASSWORD=`openssl rand -base64 180`

# Now, encrypt the file. The file is encrypted using symmetrical
# encryption along with the 180 character one-time password above.

echo "[b2encrypt] Encrypting file: $FILE_TO_ENCRYPT (with public key: $PUBLIC_KEY)"
echo $ONE_TIME_PASSWORD | \
	openssl aes-256-cbc -a -salt -pass stdin \
	-in $FILE_TO_ENCRYPT -out $FILE_TO_ENCRYPT.enc

# Now, encrypt the 180 character one-time password using the public
# key. This password was computed in RAM and only written to disk
# encrypted for security. Password is encrypted into a binary format.

echo "[b2encrypt] Encrypting OTP (with public key: $PUBLIC_KEY)"
echo $ONE_TIME_PASSWORD | \
	openssl rsautl -encrypt -pubin -inkey $PUBLIC_KEY \
	-out $FILE_TO_ENCRYPT.key.enc

# Upload the encrypted file and the encrypted one time password to B2.

echo "[b2encrypt] Uploading to bucket: $B2_BUCKET_NAME"
$B2 upload_file $B2_BUCKET_NAME $FILE_TO_ENCRYPT.enc \
    $FILE_TO_ENCRYPT.enc
$B2 upload_file $B2_BUCKET_NAME $FILE_TO_ENCRYPT.key.enc \
	$FILE_TO_ENCRYPT.key.enc
