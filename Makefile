# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
PWD           = $(shell pwd)
CURRENT_USER  = $(shell id -u)
SPHINXOPTS    =
SPHINXBUILD   = docker run -e USER_ID=$(CURRENT_USER) -v $(PWD):/medco-documentation ddidier/sphinx-doc:latest sphinx-build
SPHINXPROJ    = MedCoDocumentation
SOURCEDIR     = /medco-documentation/source
BUILDDIR      = /medco-documentation

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

.PHONY: help Makefile

clean: Makefile
	rm -rf docs/ doctrees/

html: clean Makefile
	mkdir -p docs
	mv docs html
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	mv html docs
	touch docs/.nojekyll

publish: clean html
	git pull
	git add -A docs/ source/
	git commit -m "medco-documentation update from Makefile"
	git push

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
