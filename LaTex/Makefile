SHELL := /bin/bash

.PHONY: pdf watch clean distclean publish

pdf:
	./build.sh pdf

watch:
	./build.sh watch

clean:
	./build.sh clean

distclean:
	./build.sh distclean

publish:
	@test -f .latex-build/main.pdf || { echo 'Falta .latex-build/main.pdf; compila primero con LaTeX One-Click.'; exit 1; }
	cp .latex-build/main.pdf main.pdf
