OCAMLC := ocamlc
OPAM := opam
DUNE := dune

# Define the installation paths
PREFIX := /usr/bin
TARGET := $(PREFIX)/prefect
BACKUP_DIR := /tmp/prefect_backup

# Version requirements
OCAML_MIN_VERSION := 4.14.0
OPAM_MIN_VERSION := 2.1.0
DUNE_MIN_VERSION := 3.0.0

# Check if a command exists
command_exists = \
	command -v $(1) >/dev/null 2>&1

# Check version
check_version = \
	$(1) --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1

# Targets
all: check-tools check-versions deps build install

check-tools:
	@echo "Checking for required tools..."
	@if ! $(call command_exists, $(OCAMLC)); then \
		echo "Error: OCaml is not installed."; \
		echo "Please install OCaml using your system package manager."; \
		exit 1; \
	fi
	@if ! $(call command_exists, $(OPAM)); then \
		echo "Error: OPAM is not installed."; \
		echo "Please install OPAM from https://opam.ocaml.org/"; \
		exit 1; \
	fi
	@if ! $(call command_exists, $(DUNE)); then \
		echo "Dune is not installed. Attempting to install..."; \
		$(OPAM) install dune --yes || { echo "Failed to install Dune."; exit 1; }; \
	fi
	@echo "All required tools are installed."

check-versions:
	@echo "Checking tool versions..."
	@OCAML_VERSION=$$($(call check_version, $(OCAMLC))); \
	if [ "$$OCAML_VERSION" \< "$(OCAML_MIN_VERSION)" ]; then \
		echo "Error: OCaml version $$OCAML_VERSION is too old. Required: $(OCAML_MIN_VERSION)"; \
		exit 1; \
	fi
	@OPAM_VERSION=$$($(call check_version, $(OPAM))); \
	if [ "$$OPAM_VERSION" \< "$(OPAM_MIN_VERSION)" ]; then \
		echo "Error: OPAM version $$OPAM_VERSION is too old. Required: $(OPAM_MIN_VERSION)"; \
		exit 1; \
	fi
	@DUNE_VERSION=$$($(call check_version, $(DUNE))); \
	if [ "$$DUNE_VERSION" \< "$(DUNE_MIN_VERSION)" ]; then \
		echo "Error: Dune version $$DUNE_VERSION is too old. Required: $(DUNE_MIN_VERSION)"; \
		exit 1; \
	fi
	@echo "All tool versions are compatible."

deps:
	@echo "Installing dependencies..."
	$(OPAM) install . --deps-only --yes

build:
	@echo "Building the project..."
	$(OPAM) exec -- $(DUNE) build
	@mv _build/default/bin/prefect.exe _build/default/bin/prefect

install:
	@echo "Installing Prefect to $(TARGET)..."
	@if [ -f $(TARGET) ]; then \
		echo "Backing up existing installation..."; \
		mkdir -p $(BACKUP_DIR); \
		cp $(TARGET) $(BACKUP_DIR)/prefect.backup; \
	fi
	@sudo cp _build/default/bin/prefect $(TARGET)
	@echo "Installation complete."

uninstall:
	@echo "Uninstalling Prefect..."
	@if [ -f $(TARGET) ]; then \
		sudo rm $(TARGET); \
		echo "Prefect has been uninstalled."; \
	else \
		echo "Prefect is not installed."; \
	fi

clean:
	@echo "Cleaning up build artifacts..."
	$(DUNE) clean
	@echo "Clean up complete."
