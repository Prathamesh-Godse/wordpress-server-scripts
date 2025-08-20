#!/bin/bash
# Script to get PageSpeed Insights for a website

# Usage: ./pagespeed_check.sh example.com

if [ -z "$1" ]; then
    echo "Usage: $0 <website_url>"
    exit 1
fi

SITE_URL="$1"
API_KEY="YOUR_GOOGLE_API_KEY_HERE"

# Fetch PageSpeed Insights JSON
RESPONSE=$(curl -s "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=$SITE_URL&key=$API_KEY")

# Parse key statistics using jq
MOBILE_SCORE=$(echo "$RESPONSE" | jq '.lighthouseResult.categories.performance.score * 100')
DESKTOP_SCORE=$(echo "$RESPONSE" | jq '.lighthouseResult.categories.performance.score * 100')

echo "PageSpeed Insights for $SITE_URL"
echo "Mobile Performance Score: $MOBILE_SCORE / 100"
echo "Desktop Performance Score: $DESKTOP_SCORE / 100"
