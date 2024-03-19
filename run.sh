#!/usr/bin/env zsh


if ! command -v julia &> /dev/null
then
    echo "Installing Juliaup..."
    if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
        curl -fsSL https://install.julialang.org | sh
        hash -r
    elif cat /proc/version | grep Microsoft; then
        winget install julia -s msstore
    fi
fi

julia --proj src/NewsSummarised.jl


