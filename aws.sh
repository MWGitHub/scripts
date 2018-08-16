#! /usr/bin/env bash

aws sts get-session-token --duration-seconds 129600 --serial-number "$1" --token-code "$2"
