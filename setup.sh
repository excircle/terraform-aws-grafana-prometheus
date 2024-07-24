#!/bin/bash

install_grafana_dependencies() {
  local attempt=0
  local max_attempts=3
  local success=false
  
  echo "### START install_grafana_dependencies"
  while [[ $attempt -lt $max_attempts ]]; do
    echo "Attempting to install Grafana Dependencies (Attempt: $((attempt + 1)))..."
    sudo apt update && sudo apt install awscli tree jq tzdata chrony ca-certificates curl -y

    if [[ $? -eq 0 ]]; then
      success=true
      
      # Set hostname
      sudo hostnamectl set-hostname grafana-host
      
      # Create a file to indicate that the dependencies have been installed
      touch /tmp/grafana_dependencies_installed
      break
    else
      echo "Installation failed. Retrying..."
      attempt=$((attempt + 1))
      sleep 10
    fi
  done

  if [[ $success == false ]]; then
    echo "Installation of Grafana Dependencies failed after $max_attempts attempts."
    exit 1
  fi
  echo "### END install_grafana_dependencies"
}

chrony_configuration() {
  echo "### START chrony_configuration"

  # Set the timezone to America/Los_Angeles
  echo "Setting timezone to America/Los_Angeles..."
  sudo timedatectl set-timezone America/Los_Angeles

  # Enable and start chrony service
  echo "Enabling and starting chrony service..."
  sudo systemctl enable chrony
  sudo systemctl start chrony

  # Verify the time and timezone settings
  echo "Verifying the time and timezone settings..."
  timedatectl

  # Check the status of chrony service
  echo "Checking the status of chrony service..."
  sudo chronyc tracking

  echo "### END chrony_configuration"
}

docker_installation() {
  echo "### START docker_installation"
  
  # Remove any existing docker installations
  for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
    sudo apt remove $pkg -y;
  done;

  # Install docker dependencies
  sudo install -m 0755 -d /etc/apt/keyrings
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
  sudo chmod a+r /etc/apt/keyrings/docker.asc
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
  }

############
### MAIN ###
############

main() {
  # Phase 1
  install_grafana_dependencies

  # Phase 2 - Execute if grafana_dependencies_installed
  if [[ -f /tmp/grafana_dependencies_installed ]]; then
    chrony_configuration
  else
    echo "Grafana Dependencies not installed. Exiting..."
    exit 1
  fi
}

main