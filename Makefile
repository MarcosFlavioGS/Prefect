OCAMLC := ocamlc
OPAM := opam
DUNE := dune

# Define the installation paths
PREFIX := /usr/bin
TARGET := $(PREFIX)/prefect

# Check if a command exists
command_exists = \
	command -v $(1) >/dev/null 2>&1

# Targets
all: check-tools deps build install

check-tools:
	@echo "Checking for required tools..."
	@if ! $(call command_exists, $(OCAMLC)); then \
		echo "Error: OCaml is not installed."; \
		exit 1; \
	fi
	@if ! $(call command_exists, $(OPAM)); then \
		echo "Error: OPAM is not installed."; \
		exit 1; \
	fi
	@if ! $(call command_exists, $(DUNE)); then \
		echo "Dune is not installed. Attempting to install..."; \
		$(OPAM) install dune --yes || { echo "Failed to install Dune."; exit 1; }; \
	fi
	@echo "All required tools are installed."

deps:
	@echo "Installing dependencies..."
	$(OPAM) install . --deps-only --yes

build:
	@echo "Building the project..."
	$(OPAM) exec -- $(DUNE) build
	@mv _build/default/bin/prefect.exe _build/default/bin/prefect

install:
	@echo "Installing Prefect to $(TARGET)..."
	@sudo cp _build/default/bin/prefect $(TARGET)
	@echo "Installation complete."

clean:
	@echo "Cleaning up build artifacts..."
	$(DUNE) clean
	@echo "Clean up complete."
