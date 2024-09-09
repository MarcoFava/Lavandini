# File that we are modifying
filename = EDA.ipynb

# Add file
add_file:
	git add $(filename)

# Commit file changes
commit_file:
	git commit $(filename)

# Commit all files
commit_all:
	git commit -a

# Push on branch origin/main

# 
all: add_file commit_all


# Default target: all
.DEFAULT_GOAL := commit_all

# Phony targets
.PHONY: add_file commit_file commit_all all

