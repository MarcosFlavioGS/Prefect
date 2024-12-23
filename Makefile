all: build
	@echo "hello, Prefect will be installed to your system !"
	@sudo cp _build/default/bin/prefect /usr/bin/

build:
	@opam exec -- dune build
	@mv _build/default/bin/prefect.exe _build/default/bin/prefect
