#!/bin/sh

DIR="./nginx-certs"
KEY_FILE="$DIR/tls.key"
CRT_FILE="$DIR/tls.crt"

# Check if the directory exists, if not create it
if [ -d "$DIR" ]; then
  echo "Directory '$DIR' already exists."
else
  echo "Directory '$DIR' not found — creating it now."
  mkdir -p "$DIR"
  echo "Directory '$DIR' created."
fi

# Generate a self-signed certificate and private key
if [ -f "$KEY_FILE" ] && [ -f "$CRT_FILE" ]; then
  echo "Certificate and key already exist in $DIR"
else
  echo "Generating self-signed certificate and key in $DIR"
  openssl req \
    -newkey rsa:2048 -nodes \
    -keyout "$KEY_FILE" \
    -x509 -days 90 \
    -out "$CRT_FILE" \
    -subj "/C=TH/ST=TH/L=BKK/O=HC/CN=tls" \
    -addext "subjectAltName = DNS:tls"
  echo "Generated ssl certificates successfully."
fi