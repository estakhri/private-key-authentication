#!/bin/bash

# Function to check and install sshpass
install_sshpass() {
    if ! command -v sshpass &> /dev/null; then
        echo "sshpass not found. Installing..."
        if command -v apt &> /dev/null; then
            sudo apt update && sudo apt install -y sshpass
        elif command -v yum &> /dev/null; then
            sudo yum install -y epel-release && sudo yum install -y sshpass
        elif command -v brew &> /dev/null; then
            brew install hudochenkov/sshpass/sshpass
        else
            echo "❌ Could not install sshpass: Unsupported OS or package manager"
            exit 1
        fi
    fi
}

install_sshpass

read -p "Enter server address (e.g. 192.168.1.100): " SERVER
read -p "Enter username: " USER
read -sp "Enter password: " PASSWORD
echo

KEY_PATH="$HOME/.ssh/id_rsa"
if [ ! -f "$KEY_PATH" ]; then
    echo "Generating SSH key..."
    ssh-keygen -t rsa -b 4096 -f "$KEY_PATH" -N ""
fi

echo "Copying public key to server..."
sshpass -p "$PASSWORD" ssh-copy-id -o StrictHostKeyChecking=no "$USER@$SERVER"

echo "Disabling password authentication on server..."
sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no "$USER@$SERVER" <<EOF
sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart sshd || sudo service ssh restart
EOF

echo
echo "✅ SSH key setup complete and password authentication disabled."
echo "🔐 Your private key is located at: $KEY_PATH"
