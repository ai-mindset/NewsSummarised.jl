# NewsSummarised.jl

[![SciML Code Style](https://img.shields.io/static/v1?label=code%20style&message=SciML&color=9558b2&labelColor=389826)](https://github.com/SciML/SciMLStyle) [![Run tests](https://github.com/inferential/NewsSummarised.jl/actions/workflows/tests.yml/badge.svg)](https://github.com/inferential/NewsSummarised.jl/actions/workflows/tests.yml)

## Introduction
This is a small project that has a threefold aim: 
1. learn something new by doing
2. summarise interesting companies' news articles and blog posts
3. summarise the summaries to extract a global overview of a company's activities and aims

The idea was born when I started going through articles posted in a company's own website, showcasing their successes and focus. 
At that time I wondered whether I could easily come up with an overall summary of their activities. It was also a good opportunity to test my theory, that it is possible to utilise LLMs on a modest personal computer to increase the volume of information I can assimilate when my time is limited.

This project was implemented in [Julia](https://julialang.org/), leveraging the good work of the [ollama](https://ollama.com/) project.
Julia is a joyful language to use, enabling productivity from the get go, with a pretty complete ecosystem that enables Data Scientists to implement a wide gamut of solutions within most domains. 

## Usage
On macOS and Linux, launch a terminal window and type:
1. `$ git clone https://github.com:inferential/NewsSummarised.jl`
2. `$ cd NewsSummarised.jl`
3. `$ ./run.sh`

On Windows
* using WSL:  
same as above

* using PowerShell:
1. Clone `https://github.com:inferential/NewsSummarised.jl` with a tool of your choice
2. Navigate to `NewsSummarised.jl`
3. Check if Julia is installed on your system. If not, run `winget install julia -s msstore`
3. Run `julia --proj src/NewsSummarised.jl`


The first run may take a while, as every article is getting summarised and all summaries are summarised into a final document.  
LLM inference on computers with a relatively modern GPU will be faster.  Inference on CPU is possible, but expect a significantly lower output.    
Subsequent runs will be faster, as the tool loads `news/final-summary.txt` from storage before printing.  
⚠️: Every now and again I expand the tool's scope, depending on company websites I stumble across. Check the repo branches for specific companies I've implemented a web scraper for. The list is random, depending on websites I've encountered and the articles' volume that have posted. The more articles the merrier, as this showcases this tool's utility in saving up time and offering an overview of activities.    

## Future work
See [issues](https://github.com/inferential/NewsSummarised.jl/issues) for more information.  

---
*`<base url>`/robots.txt is respected ✅
