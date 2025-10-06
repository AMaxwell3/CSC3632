#!/bin/bash
# Generate 4096-bit RSA keys
openssl genpkey -algorithm RSA -out private.pem -pkeyopt rsa_keygen_bits:4096
openssl rsa -pubout -in private.pem -out public.pem

# Create random message files
dd if=/dev/urandom of=msg_1KB.bin bs=1K count=1 status=none
dd if=/dev/urandom of=msg_10KB.bin bs=1K count=10 status=none
dd if=/dev/urandom of=msg_100KB.bin bs=1K count=100 status=none

for f in msg_*.bin; do
  echo "Signing $f"
  { time openssl dgst -sha256 -sign private.pem -out "$f.sig" "$f"; } 2>> rsa_times.txt
  echo "Verifying $f"
  { time openssl dgst -sha256 -verify public.pem -signature "$f.sig" "$f"; } 2>> rsa_times.txt
done

echo "RSA timing results in rsa_times.txt"

