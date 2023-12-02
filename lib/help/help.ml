module HelpModule = struct
  let help (): unit =
    let new_option: string =
      "\tnew | n -> Generates C project structure with initial directories and files."
    in
    let build_option: string =
      "\tbuild | g -> Build the project binary unsing options contained inside Prefect.toml:\n"
        ^ "\t\t-c -> Compiles just the object files: \n"
        ^ "\t\t\t--b -> Generates the binary from the object files.\n"
        ^ "\t\trelease -> Builds optimized binary using the -O3 gcc flag.\n"
        ^ "\t\tdebug -> Make debug optimizations to the builded binary.\n"
    in
    let run_option: string =
      "\trun | r -> Builds and runs the project.\n"
    in
    let generate_option: string =
      "\tGenerate | g -> Generates project dependencies such as makefiles."
    in
    let str: string =
      "Prefect is a C package manager or build tool."
      ^ " It is made to provide more modern features to C projects.\n\n"
      ^ "OPTIONS: \n"
      ^ new_option ^ "\n\n"
      ^ build_option ^ "\n\n"
      ^ run_option ^ "\n\n"
      ^ generate_option ^ "\n\n"
    in

    print_endline str
end
