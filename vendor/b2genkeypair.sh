PRIVATE_KEY="priv-key.pem"
PUBLIC_KEY="pub-key.pem"

# Generates a private key. The passphrase for the private
# key is required to be typed in during key creation.

openssl genrsa -aes256 -out $PRIVATE_KEY 2048

# From the private key, generates a public key. This key will be used
# to encrypt the one time password generated for each file's
# encryption. This command will require the private key passphrase.

openssl rsa -in $PRIVATE_KEY -pubout -out $PUBLIC_KEY
