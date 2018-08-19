#!/usr/bin/env bats

@test "hashes the test cases correctly" {
  result="$(echo 12345678901234567890 | hotp 0)"
  echo "$result"
  [ "$result" -eq "755224" ]
}
