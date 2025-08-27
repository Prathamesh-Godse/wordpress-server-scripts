#!/bin/bash
# UFW Configuration with State Preservation

TASK_LOG="/var/log/task-manager.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - UFW: $1" | sudo tee -a "$TASK_LOG"
}

case "${1:-}" in
    "continue")
        # Continue from saved state
        case "$2" in
            "step2")
                step2_configuration
                ;;
            "step3")
                step3_post_reboot
                ;;
        esac
        ;;
    *)
        # Normal execution
        step1_initial_setup
        ;;
esac

step1_initial_setup() {
    log "Starting UFW configuration..."
    
    # Save state before reboot
    /usr/local/bin/task-manager-helper save_state "ufw-config" "step2"
    
    # Do initial setup
    sudo ufw allow http
    sudo ufw allow https
    # ...
    
    log "Step 1 complete, rebooting..."
    sudo reboot
}

step2_configuration() {
    log "Continuing UFW configuration after reboot..."
    
    # More configuration
    sudo ufw enable
    sudo ufw reload
    
    # Save state for final step
    /usr/local/bin/task-manager-helper save_state "ufw-config" "step3"
    
    log "Step 2 complete, final reboot..."
    sudo reboot
}

step3_post_reboot() {
    log "Final post-reboot check..."
    sudo ufw status verbose
    log "UFW configuration complete!"
    
    # Clear state
    /usr/local/bin/task-manager-helper clear_state
}
