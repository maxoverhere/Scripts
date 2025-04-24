#!/bin/bash

# Install kubectl via Homebrew (if not installed)
echo "Checking kubectl installation..."
if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl via Homebrew..."
    brew install kubectl
else
    echo "✓ kubectl already installed. Skipping."
fi

echo ""


# Install Krew (if not installed)
echo "Checking Krew installation..."
if ! command -v kubectl-krew &> /dev/null && ! command -v kubectl krew &> /dev/null; then
    echo "Installing Krew..."
    (
      set -x; cd "$(mktemp -d)" &&
      OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
      ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
      KREW="krew-${OS}_${ARCH}" &&
      curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
      tar zxvf "${KREW}.tar.gz" &&
      ./"${KREW}" install krew
    )
else
    echo "✓ Krew already installed. Skipping."
fi

echo ""


# Add Krew to PATH (if not already added)
echo "Checking Krew PATH configuration..."
KREW_PATH="${KREW_ROOT:-$HOME/.krew}/bin"
if ! grep -q "export PATH=\"$KREW_PATH:\$PATH\"" ~/.zprofile; then
    echo "Adding Krew to PATH in ~/.zprofile..."
    echo "export PATH=\"$KREW_PATH:\$PATH\"" >> ~/.zprofile
    export PATH="$KREW_PATH:$PATH"
else
    echo "✓ Krew PATH already set in ~/.zprofile. Skipping."
fi

echo ""


# Install Relay plugin (if not installed)
echo "Checking Relay plugin installation..."
if ! kubectl krew list | grep -q relay; then
    echo "Installing Relay plugin via Krew..."
    kubectl krew install relay
else
    echo "✓ Relay plugin already installed. Skipping."
fi

echo ""

echo "✅ Setup completed successfully!"

echo ""
echo ""


echo "Verify relay installation by running 'kubectl relay -V'"

echo ""


echo "To connect to a PostgreSQL database in Kubernetes via Relay:"
echo "  kubectl relay postgresql <pod-name> --namespace <namespace> --port 5432"
echo ""
echo "Replace <pod-name> and <namespace> with your actual values."
echo "This forwards PostgreSQL to localhost so you can connect with:"
echo "  psql -h localhost -U <username> -d <database>"

