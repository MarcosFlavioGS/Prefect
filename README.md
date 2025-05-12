# Prefect

![logo-no-background](https://github.com/user-attachments/assets/9b716f21-c368-4a4c-8e2f-ef6c414f63e6)

A modern C package manager and build tool that simplifies your development workflow.

## Overview

![Typing SVG](https://readme-typing-svg.herokuapp.com/?color=D5CCA3&size=35&center=true&vCenter=true&width=1000&lines=Drink+up.;The+world's+about+to+end.)

Prefect is a powerful C package and build system crafted with the elegance of OCaml. It streamlines your entire development workflow, from project initialization to deployment, with a focus on simplicity and efficiency.

## Features

### 🚀 Project Management
- Create standardized C project structures
- Automatic Git repository initialization
- Configurable project templates
- Dependency management

### 🛠️ Build System
- Smart compilation with automatic dependency tracking
- Multiple build modes (debug, release)
- Object file compilation support
- Customizable compiler flags

### 📦 Package Management
- Easy dependency installation
- Version management
- Project-specific configurations
- Support for external libraries

### 🎓 Educational Support
- Specialized templates for 42 school projects
- Built-in support for common project structures
- Standardized build configurations
- Easy project submission preparation

## Quick Start

### Installation

#### From Release
1. Download the latest release from the [Releases page](https://github.com/MarcosFlavioGS/Prefect/releases)
2. Ensure you have GLIBC 2.38 or higher
3. Make the binary executable: `chmod +x prefect`
4. Move to your PATH: `sudo mv prefect /usr/local/bin/`

#### From Source
```bash
# Clone the repository
git clone https://github.com/MarcosFlavioGS/Prefect.git

# Navigate to the project directory
cd Prefect

# Build and install
make
```

### Basic Usage

#### Create a New Project
```bash
prefect new my_project
```
This creates a new C project with the following structure:
```
my_project/
├── src/
│   └── main.c
├── include/
├── obj/
├── test/
└── bin/
```

#### Build Your Project
```bash
# Standard build
prefect build

# Build with optimizations
prefect build --release

# Build with debug information
prefect build --debug

# Compile to object files
prefect build -c

# Compile objects and build executable
prefect build -cb
```

#### Run Your Project
```bash
prefect run
```

#### Generate Project Dependencies
```bash
# Generate a Makefile
prefect generate makefile

# Short form
prefect g makefile
```

## Advanced Usage

### Project Configuration
Prefect uses S-expressions for configuration. A basic configuration looks like:
```lisp
(
  (name "project_name")
  (project_dir "/path/to/project")
  (src ("/src/main.c"))
  (compiler "gcc")
  (flags ("-Wall" "-Wextra" "-Werror"))
)
```

### Custom Templates
Create custom project templates by modifying the configuration:
```bash
prefect generate template my_template
```

### Build Options
- `--release`: Enable optimizations
- `--debug`: Include debug information
- `-c`: Compile to object files
- `-b`: Build executable
- `-cb`: Compile objects and build

## Requirements

- OCaml 4.14.0 or higher
- OPAM 2.1.0 or higher
- Dune 3.0.0 or higher
- GLIBC 2.38 or higher

## Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

## License

This project is licensed under the [MIT License](https://opensource.org/license/mit/).

## Acknowledgments

Special thanks to:
- The OCaml community for their excellent tools and support
- The C programming community for their continuous innovation
- All contributors who have helped shape Prefect

---

*Thank you for choosing Prefect! Happy coding!* 🚀
