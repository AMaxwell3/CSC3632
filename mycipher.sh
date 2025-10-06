#!/bin/bash
# Usage: ./mycipher.sh -op Enc/Dec -algo AES128/192/256 -mode CBC/ECB -in input -out output

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -op) operation="$2"; shift ;;
    -algo) algorithm="$2"; shift ;;
    -mode) mode="$2"; shift ;;
    -in) inputfile="$2"; shift ;;
    -out) outputfile="$2"; shift ;;
  esac
  shift
done

case $operation in
  Enc) op="-e" ;;
  Dec) op="-d" ;;
  *) echo "Use -op Enc or Dec"; exit 1 ;;
esac

case $algorithm in
  AES128) algo="aes-128-" ;;
  AES192) algo="aes-192-" ;;
  AES256) algo="aes-256-" ;;
  *) echo "Algo must be AES128/192/256"; exit 1 ;;
esac

case $mode in
  CBC) mod="cbc" ;;
  ECB) mod="ecb" ;;
  *) echo "Mode must be CBC/ECB"; exit 1 ;;
esac

cipher="${algo}${mod}"

echo "Enter passphrase:"
read -s passphrase

openssl enc -"${cipher}" ${op} -in "$inputfile" -out "$outputfile" -pass pass:"$passphrase"

echo "Done: $operation using $cipher"

