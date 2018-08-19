#!/usr/bin/env bash

die() {
  printf '%s\n' "$1" >&2
  exit 1
}

show_help() {
  printf "Run with 'eval \$(./awslogin your-profile mfa-token)\n"
  printf "Make sure the .aws/config file has a role_arn, source_profile, and mfa_serial.\n"
  printf "Also make sure there is a matching credentials file."
}

case $1 in
  -h|-\?|--help)
    show_help
    exit
    ;;
esac

if [ -z "$(which aws)" ]; then
  die 'Error: aws cli must be installed.'
fi

if [ -z "$(which jq)" ]; then
  die 'Error: jq must be installed.'
fi

login() {
  profile=$1
  token=$2

  if [ -z "$profile" ]; then
    die 'Error: profile must be provided.'
  fi

  if [ -z "$token" ]; then
    die 'Error: token must be provided.'
  fi

  role=$(awk '/profile[[:blank:]]admin/,/ENDFILE/' < ~/.aws/config | awk '/role_arn.*=.*(arn)+/ { print $3 }')

  mfa_serial=$(awk '/profile[[:blank:]]admin/,/ENDFILE/' < ~/.aws/config | awk '/mfa_serial.*=.*(arn)+/ { print $3 }')

  # Log in to AWS with a role
  result="$(aws sts assume-role --role-arn "$role" --role-session-name "$profile" --duration-seconds 43200 --serial-number "$mfa_serial" --token-code "$token")"

  success="$(echo "$result" | grep SessionToken)"
  if [ -z "$success" ]; then
    exit 1
  fi

  AWS_ACCESS_KEY_ID=$(echo "$result" | jq '.Credentials.AccessKeyId')
  echo export "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID;"

  AWS_SECRET_ACCESS_KEY=$(echo "$result" | jq '.Credentials.SecretAccessKey')
  echo export "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY;"

  AWS_SESSION_TOKEN=$(echo "$result" | jq '.Credentials.SessionToken')
  echo export AWS_SESSION_TOKEN="$AWS_SESSION_TOKEN"
}

login "$1" "$2"
