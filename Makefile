all:
	@$(MAKE) -s release
release:
	@dmd -O -release -inline -boundscheck=off main.d
