#!/bin/bash

# Requesting a token code from the user
read -p "Enter token code: " token_code

# Command execution aws sts assume-role с подстановкой значения кода токена
output_aws=$(aws sts assume-role --role-arn arn:aws:iam::<AccountID>:role/Admins --role-session-name tf --serial-number <your_mfa_id> --token-code "$token_code" --profile <your_profile>)

# Retrieving the values of variables
access_key_id=$(echo "$output_aws" | jq -r '.Credentials.AccessKeyId')
secret_access_key=$(echo "$output_aws" | jq -r '.Credentials.SecretAccessKey')
session_token=$(echo "$output_aws" | jq -r '.Credentials.SessionToken')

# Export variables
export AWS_ACCESS_KEY_ID="$access_key_id"
export AWS_SECRET_ACCESS_KEY="$secret_access_key"
export AWS_SESSION_TOKEN="$session_token"

# Output of current values.
echo ""
echo "current parameters AWS."
env | grep AWS
