# file that we are modifying
filename = EDA.ipynb

# add file
add_file:
	git add $(filename)

# commit file changes
commit_file:
	git commit $(filename)

# commit all files
commit_all:
	git commit -a
