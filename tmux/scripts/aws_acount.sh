#!/usr/bin/env bash
# Prefer AWS_PROFILE if present; otherwise return the numeric account ID.
if [ -n "${AWS_PROFILE}" ]; then
  printf '%s' "${AWS_PROFILE}"
  exit 0
fi
aws sts get-caller-identity --query 'Account' --output text 2>/dev/null || printf 'N/A'
