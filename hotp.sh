#!/usr/bin/env bash

to_six() {
  string=$1

  # Get the offset half byte
  offset="$((16#$string & 0x00000000000000000000000000000000000000f))"
  # Retrieve the range of 4 bytes
  range="${string:$((offset << 1)):$((4 << 1))}"
  separated="$(echo "$range" | sed -e 's/\(..\)/\1\n/g')"
  result=0
  multiplier=3
  while read -r line; do
    result="$((result | (16#$line << (multiplier * 8))))"
    multiplier="$((multiplier-1))"
  done <<< "$separated"

  echo -n "$((result % 1000000))"
}

hotp() {
  k=$1
  c=$2
  sha=$(echo -n "$c" | openssl sha1 -hmac "$k" | awk '/.*[[:blank:]]/     { print $2 }' -)

  result=$(to_six "$sha")
  echo -n "$result"
}

hotp "$1" "$2" 1>&2
