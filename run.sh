#!/usr/bin/env bash

if ! command -v julia &> /dev/null
then
    echo "Installing Juliaup..."
    if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
        curl -fsSL https://install.julialang.org | sh
        if ! command -v ollama &> /dev/null
            echo "Installing ollama..."
            curl -fsSL https://ollama.com/install.sh | sh
            echo "Pulling mistral from ollama repository..."
            ollama pull mistral
        fi
        hash -r
    elif cat /proc/version | grep Microsoft; then
        winget install julia -s msstore
        echo "Please install ollama before continuing https://ollama.com/download/OllamaSetup.exe"
        echo "Please pull `mistral` before continuing https://ollama.com/library/mistral"
        echo "then run `julia --proj src/NewsSummarised.jl` in a terminal"
        exit 1
    fi
fi

julia --proj src/NewsSummarised.jl
