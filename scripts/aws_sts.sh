#!/bin/bash

# Requesting a token code from the user
read -p "Enter your aws user: " aws_user
read -p "Enter your MFA authenticator name: " mfa
read -p "Enter token code: " token_code
read -p "Enter your name profile: " name_profile

# Get caller identity
caller_identity=$(aws sts --profile $name_profile get-caller-identity)
AccountID=$(echo "$caller_identity" | jq -r '.Account')

# Command execution aws sts assume-role с подстановкой значения кода токена
output_aws=$(aws sts assume-role --role-arn arn:aws:iam::"$AccountID":role/Admins --role-session-name "$aws_user"\
 --serial-number arn:aws:iam::"$AccountID":mfa/"$mfa" --token-code "$token_code" --profile "$name_profile")

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
echo "AWS logging in successfully"
#env | grep AWS
