#!/bin/bash

echo "Creating virtual environment..."
uv venv

echo "Activating virtual environment..."
source .venv/bin/activate

echo "Installing dependencies..."
uv pip install -r requirements_nt.txt

# Copy .env_example if .env doesn't exist
if [ ! -f .env ]; then
  echo "Copying .env_example to .env..."
  cp .env_example .env
fi

# Prompt for OpenAI API key and update .env
read -p "Enter your OpenAI API key (sk-...): " OPENAI_KEY

# Update or insert the key in .env
if grep -q "^OPENAI_API_KEY=" .env; then
  sed -i.bak "s/^OPENAI_API_KEY=.*/OPENAI_API_KEY=$OPENAI_KEY/" .env
else
  echo "OPENAI_API_KEY=$OPENAI_KEY" >> .env
fi

echo "✅ .env is ready with your OpenAI API key."

echo "Running tests..."
python -m tests.tests_openai
