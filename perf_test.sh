#!/bin/bash
sizes=(10 100)
algos=(AES128 AES192 AES256)
modes=(CBC ECB)

for s in "${sizes[@]}"; do
  dd if=/dev/urandom of=file_${s}KB.txt bs=1K count=$s status=none
done

read -s -p "Enter passphrase: " passphrase
echo

for algo in "${algos[@]}"; do
  for mode in "${modes[@]}"; do
    for s in "${sizes[@]}"; do
      echo "Testing ${algo}-${mode} on ${s}KB file"
      { time ./mycipher.sh -op Enc -algo $algo -mode $mode -in file_${s}KB.txt -out enc_${s}_${algo}_${mode}.bin <<< "$passphrase"; } 2>> time_results.txt
      { time ./mycipher.sh -op Dec -algo $algo -mode $mode -in enc_${s}_${algo}_${mode}.bin -out dec_${s}_${algo}_${mode}.txt <<< "$passphrase"; } 2>> time_results.txt
    done
  done
done

echo "Results saved in time_results.txt"

