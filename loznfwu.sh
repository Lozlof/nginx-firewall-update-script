#!/bin/bash

# Path to the configuration file
CONFIG_FILE="/your/path/config.conf"

# Function to update the firewall rules in an Nginx config file
update_nginx_config() {
    local nginx_conf="$1"
    local ips=("${@:2}")

    # Backup the original Nginx config
    cp "$nginx_conf" "$nginx_conf.bak"
    echo "Backup created for $nginx_conf."

    # Remove existing 'allow' rules, but keep 'deny all;' if it exists
    sed -i '/allow /d' "$nginx_conf"

    # Ensure that 'deny all;' is present at the end of each location block
    if ! grep -q "deny all;" "$nginx_conf"; then
        sed -i "/location \/ {/a\ \ \ \ deny all;" "$nginx_conf"
        sed -i "/location \/socket.io\/ {/a\ \ \ \ deny all;" "$nginx_conf"
    fi

    # Insert new IPs with 'allow' statements above the 'deny all;' line
    for ip in "${ips[@]}"; do
        sed -i "/deny all;/i \ \ \ \ allow $ip;" "$nginx_conf"
    done

    echo "Updated firewall rules for $nginx_conf."
}

# Main function to read config file and update all Nginx configs
main() {
    local ips=()
    local nginx_configs=()

    # Read the configuration file
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        if [[ "$line" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            ips+=("$line")
        elif [[ -f "$line" ]]; then
            nginx_configs+=("$line")
        else
            echo "Invalid entry in config file: $line"
        fi
    done < "$CONFIG_FILE"

    # Update each Nginx configuration file
    for nginx_conf in "${nginx_configs[@]}"; do
        update_nginx_config "$nginx_conf" "${ips[@]}"
    done

    # Reload Nginx to apply changes
    sudo nginx -t && sudo systemctl reload nginx
    if [ $? -eq 0 ]; then
        echo "Nginx reloaded successfully."
    else
        echo "Nginx reload failed. Please check the configuration."
        exit 1
    fi
}

# Execute main function
main
