# Prefect
<div align="center">
  ![logo-no-background](https://github.com/user-attachments/assets/9b716f21-c368-4a4c-8e2f-ef6c414f63e6)
</div>

A C package manager and build tool if you are too lazy for Makefile.

## Overview

![Typing SVG](https://readme-typing-svg.herokuapp.com/?color=D5CCA3&size=35&center=true&vCenter=true&width=1000&lines=Drink+up.;The+world’s+about+to+end.)

Prefect is a powerful C package and build system crafted with the elegance of OCaml. It simplifies the entire project lifecycle, from creating a new project with a standardized C project structure to building, running, and generating project dependencies like Makefiles or specific structures for 42 school projects such as MiniShell, FDF, ft_printf, Libft, and more.

## Features

### Create Project

Prefect makes project initiation a breeze. It sets up a comprehensive C project structure with directories like src, obj, include, test, and bin. To create a new project, use the following command:

``` sh
prefect new <project_name>
```

This command not only creates the necessary directories but also initializes a Git repository for version control.

### Build Project

Building your C project is a seamless process with Prefect. It compiles your source code, taking care of compiler flags and other configurations. To build your project, run:

``` sh
prefect build
```

Prefect can also build to object files.

``` sh
prefect build -c
```

It will compile the object files and put them inside your obj/ directory. If you want to compile the object files and also build the executable, add an extra option to the build command:

``` sh
prefect build -cb
```
 or:
 
 ```sh
 prefect build -c -b
 ```

This command will both compile the object files into the obj folder and build the executable.
 
The build option also has optimization options and debug optimization.

``` sh
prefect build --release
```
and

``` sh
prefect build --debug
```

### Run Project

Executing your C project is as simple as running:

``` sh
prefect run
```

This command ensures that your project is compiled and then executes the compiled binary.

### Generate Project Dependencies

Need project-specific configurations like Makefiles or 42 school project structures? Prefect has you covered. To generate project dependencies, use:

``` sh
prefect generate <dependencie_type>
```

Replace <dependency_type> with the specific dependency you need, such as Makefile.

## Getting started

![Typing SVG](https://readme-typing-svg.herokuapp.com/?color=D5CCA3&size=35&center=true&vCenter=true&width=1000&lines=$>+prefect+new+project;)

### Installation

### *Release*

The binary is available on the release page [Release](https://github.com/MarcosFlavioGS/Prefect/releases)

You will need GLIBC_2.38 or higher to run the executable.

### Build and install from source

Clone this repository and run the *make* command to build the project from source and install the binary.

``` sh
git clone https://github.com/MarcosFlavioGS/Prefect.git

cd Prefect

make
```

You will need both *Makefile* and *Dune* installed to build the project

## Examples

### Creating a new project

``` sh
prefect new my_c_project
```

This command creates a new C project named "my_c_project" with the standard project structure.

### Generating a Makefile

``` sh
prefect generate makefile
```

the generate command, as well as all other commands, can be used in it's short form:

``` sh
prefec g makefile
```

## License

This project is licensed under the [MIT license](https://opensource.org/license/mit/)

## Acknowledgments

We would like to express our gratitude to the OCaml and C communities for their continuous support and inspiration.

###

*Thank you for choosing Prefect for your C projects! Happy coding!* 🚀
