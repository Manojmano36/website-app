#!/bin/bash

set -e

echo "Running CI tests..."

# Test 1: HTML file exists
if [ ! -f app/index.html ]; then
  echo "❌ index.html not found"
  exit 1
fi

# Test 2: Website title check
grep -q "DevOps Production Pipeline" app/index.html || {
  echo "❌ Expected title not found"
  exit 1
}

echo "✅ All tests passed"
