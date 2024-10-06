#!/bin/bash

# Проверяем, что Python и pip установлены
if ! command -v python3 &> /dev/null; then
    echo "Error: Python3 is not installed. Please install Python3."
    exit 1
fi

if ! command -v pip3 &> /dev/null; then
    echo "Error: pip3 is not installed. Please install pip3."
    exit 1
fi

# Создаем виртуальную среду
ENV_DIR="venv"

if [ -d "$ENV_DIR" ]; then
    echo "Virtual environment already exists at $ENV_DIR"
else
    echo "Creating virtual environment..."
    python3 -m venv "$ENV_DIR"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create virtual environment."
        exit 1
    fi
    echo "Virtual environment created successfully at $ENV_DIR"
fi

echo "Activating virtual environment..."
source "$ENV_DIR/bin/activate"

echo "Installing required packages..."
pip install --upgrade pip
pip install pyyaml toml

# Проверяем успешность установки
if [ $? -eq 0 ]; then
    echo "Packages installed successfully."
else
    echo "Error: Failed to install packages."
    exit 1
fi

echo "Generating requirements.txt..."
pip freeze > requirements.txt
echo "Requirements saved to requirements.txt."

echo "Virtual environment setup complete. Use 'source $ENV_DIR/bin/activate' to activate it."

