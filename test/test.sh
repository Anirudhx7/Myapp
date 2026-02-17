#!/bin/bash
 
echo "Running simple test..."
 
if [ -f app/index.html ]; then
    echo "index.html exists ✅"
    exit 0
else
    echo "index.html missing ❌"
    exit 1
fi
