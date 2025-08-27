#!/bin/bash

# UFW Configuration Script with Reboot Persistence
set -e

LOG_FILE="/var/log/ufw_configuration.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

check_ufw_status() {
    log "Checking UFW status..."
    sudo ufw status verbose | tee -a "$LOG_FILE"
}

configure_ufw() {
    if sudo ufw status | grep -q "Status: active"; then
        log "UFW is already enabled. Adding rules..."
        
        sudo ufw allow http
        sudo ufw allow https/tcp
        sudo ufw allow https/udp
        sudo ufw allow ssh
        
    else
        log "UFW is disabled. Configuring from scratch..."
        
        sudo ufw default deny incoming
        sudo ufw default allow outgoing
        sudo ufw allow http
        sudo ufw allow https/tcp
        sudo ufw allow https/udp
        sudo ufw allow ssh
        sudo ufw enable
    fi
    
    log "Final UFW status:"
    sudo ufw status verbose | tee -a "$LOG_FILE"
    sudo ufw reload
}

post_reboot_check() {
    log "=== POST-REBOOT CHECK ==="
    log "System rebooted successfully"
    log "Current UFW status:"
    sudo ufw status verbose | tee -a "$LOG_FILE"
    
    # Clean up the service file
    sudo rm -f /etc/systemd/system/ufw-config.service
    sudo systemctl daemon-reload
    
    log "Configuration complete! Service removed."
}

# Main execution
case "${1:-}" in
    "post-reboot")
        post_reboot_check
        ;;
    *)
        log "=== STARTING UFW CONFIGURATION ==="
        check_ufw_status
        configure_ufw
        
        # Create service file for post-reboot execution
        cat > /tmp/ufw-config.service << EOF
[Unit]
Description=UFW Post-Reboot Configuration
After=network.target

[Service]
Type=oneshot
ExecStart=/bin/bash /usr/local/bin/configure_ufw.sh post-reboot
RemainAfterExit=no

[Install]
WantedBy=multi-user.target
EOF

        sudo mv /tmp/ufw-config.service /etc/systemd/system/
        sudo systemctl daemon-reload
        sudo systemctl enable ufw-config.service
        
        log "Configuration complete. Rebooting in 10 seconds..."
        log "Press Ctrl+C to cancel reboot"
        sleep 10
        
        log "Initiating reboot..."
        sudo reboot
        ;;
esac
