#!/bin/bash

if [ -f "../.env" ]; then
  echo "Loading environment variables from .env"
  set -a
  source ../.env
  set +a
else
  echo "No .env file found. Please create one with the required environment variables."
  exit 1
fi