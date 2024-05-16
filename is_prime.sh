#!/bin/bash

# Memeriksa apakah terdapat argumen yang dimasukkan
if [[ "$#" -ne 1 ]]; then
  echo "$0 <angka>"
  exit 1
fi

# Memeriksa apakah argumen telah sesuai
if ! [[ $1 =~ ^-?[0-9]+$ ]]; then
  echo "Error: Argumen harus merupakan bilangan bulat lebih dari 1"
  exit 1
fi

# Bilangan kurang dari sama dengan 1 bukan bilangan prima
if [[ $1 -le 1 ]]; then
  echo "bilangan ini bukan bilangan prima"
  exit 0
fi

# Memeriksa apakah argumen dapat dibagi dengan salah satu bilangan yang kurang dari argumen tersebut
i=2
while [[ $i -lt $1 ]]; do
  if [[ $(($1 % $i)) -eq 0 ]]; then
    echo "bilangan ini bukan bilangan prima"
    exit 0
  fi
  (( i += 1 ))
done

echo "bilangan ini adalah bilangan prima"
exit 0