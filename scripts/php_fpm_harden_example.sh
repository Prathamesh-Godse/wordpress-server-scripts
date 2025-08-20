# Filename: php_fpm_harden_example.sh
#!/bin/bash
set -e

USER="example"
DOMAIN="example.com"
PHP_VERSION="8.3"
WEBROOT="/var/www/$DOMAIN/public_html"
FPM_POOL_CONF="/etc/php/$PHP_VERSION/fpm/pool.d/$DOMAIN.conf"

# --- Set ownership and permissions ---
sudo chown -R "$USER:$USER" "$WEBROOT"
sudo find "$WEBROOT" -type d -exec chmod 770 {} \;
sudo find "$WEBROOT" -type f -exec chmod 660 {} \;

# --- Create phpinfo test file ---
PHPINFO_FILE="$WEBROOT/info123.php"
echo "<?php phpinfo(); ?>" | sudo tee "$PHPINFO_FILE" > /dev/null

echo "✅ phpinfo() test file created at $PHPINFO_FILE"
echo "Visit in browser: http://$DOMAIN/info123.php"

# --- Harden PHP-FPM pool: disable dangerous functions ---
DISABLED_FUNCS="shell_exec, opcache_get_configuration, opcache_get_status, disk_total_space, diskfreespace, dl, exec, passthru, pclose, pcntl_alarm, pcntl_exec, pcntl_fork, pcntl_get_last_error, pcntl_getpriority, pcntl_setpriority, pcntl_signal, pcntl_signal_dispatch, pcntl_sigprocmask, pcntl_sigtimedwait, pcntl_sigwaitinfo, pcntl_strerror, pcntl_waitpid, pcntl_wait, pcntl_wexitstatus, pcntl_wifcontinued, pcntl_wifexited, pcntl_wifsignaled, pcntl_wifstopped, pcntl_wstopsig, pcntl_wtermsig, popen, posix_getpwuid, posix_kill, posix_mkfifo, posix_setpgid, posix_setsid, posix_setuid, posix_uname, proc_close, proc_get_status, proc_nice, proc_open, proc_terminate, show_source, system"

sudo sed -i "/; ENABLED FUNCTIONS/ a php_admin_value[disable_functions] = $DISABLED_FUNCS" "$FPM_POOL_CONF"

# --- Reload PHP-FPM ---
sudo systemctl reload php"$PHP_VERSION"-fpm

# --- Remove test file after verification ---
# Uncomment below line if you want to auto-remove immediately
# sudo rm -f "$PHPINFO_FILE"

echo "✅ PHP-FPM hardening applied and PHP-FPM reloaded."
