# Update NodeSource for Node.js 20, install Node.js, and install Gemini CLI
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && \
sudo apt update -y
sudo apt install -y nodejs && \
sudo npm install -g @google/gemini-cli && \
echo 'export PATH=$PATH:$(npm config get prefix)/bin' >> ~/.bashrc && \
source ~/.bashrc && \
echo "Installation complete. Type 'gemini' to start."
