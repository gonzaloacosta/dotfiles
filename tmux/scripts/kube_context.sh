#!/usr/bin/env bash
# Print current kubectl context (shortened a bit if very long)
ctx=$(kubectl config current-context 2>/dev/null || echo "none")
# Optional shortening: drop cluster suffixes like .k8s.local
printf '%s' "${ctx%%.*}"
