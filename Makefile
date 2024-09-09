.POSIX:
site: mkdocs.yml $(shell find docs -type f)
	mkdocs build
clean:
	rm -rf site
