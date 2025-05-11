(lang dune 3.10)

(name prefect)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Marcos Flavio")

(maintainers "Marcos Flavio")

(license MIT)

(documentation https://url/to/documentation)

(package
 (name prefect)
 (version 0.5.0)
 (synopsis "A C package manager and build system")
 (description "This a new C package manager and build system for C without having to use makefile")
 (depends ocaml dune)
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
