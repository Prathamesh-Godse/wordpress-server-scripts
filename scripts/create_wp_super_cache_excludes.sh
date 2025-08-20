#!/bin/bash
# Script to create wp_super_cache_excludes.conf for prathameshgodse.com

INCLUDE_DIR="/etc/nginx/includes"
CONF_FILE="$INCLUDE_DIR/wp_super_cache_excludes.conf"

echo "Creating WP Super Cache Nginx cache exclusions file..."

sudo tee "$CONF_FILE" > /dev/null << 'EOF'
# WP Super Cache NGINX Cache Exclusions Rules.
set $cache_uri $request_uri;
 
# POST requests and urls with a query string should always go to PHP
if ($request_method = POST) {
	set $cache_uri 'null cache';
}

if ($query_string != "") {
        set $cache_uri 'null cache';
}

# Don't cache uris containing the following segments
if ($request_uri ~* "(/wp-admin/|/xmlrpc.php|/wp-(app|cron|login|register|mail).php|wp-.*.php|/feed/|index.php|wp-comments-popup.php|wp-links-opml.php|wp-locations.php|sitemap(_index)?.xml|[a-z0-9_-]+-sitemap([0-9]+)?.xml)") {
        set $cache_uri 'null cache';
}

# Don't use the cache for logged in users or recent commenters
if ($http_cookie ~* "comment_author|wordpress_[a-f0-9]+|wp-postpass|wordpress_logged_in") {
        set $cache_uri 'null cache';
}

# Use cached or actual file if they exists, otherwise pass request to WordPress
location / {
        try_files /wp-content/cache/supercache/$http_host/$cache_uri/index-https.html $uri $uri/ /index.php?$args ;
}
EOF

echo "WP Super Cache exclusions file created at $CONF_FILE"
