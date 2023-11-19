(** Module tp create a new project *)
module CreateProject = struct
  open Unix
  let create_C_structure (name: string): unit =
      let directories: string list = [
        "src";
        "obj";
        "include";
        "test";
        "bin"
      ]
      in
      let create_dir (dir_name: string) =
        let mode = 0o755 in
        try
          Unix.mkdir dir_name mode;
          Printf.printf "'%s' created successfully\n" dir_name
        with
        | Unix.Unix_error (EEXIST, _, _) ->
          Printf.printf "'%s' already exists\n" dir_name
        | Unix.Unix_error (e, _, _) ->
          Printf.eprintf "Error creating directory: %s\n" (Unix.error_message e);
          failwith (Unix.error_message e)
      in
      let rec build_struct (name: string) = function
        | [] -> print_endline "Done building structure..."
        | [dir] -> create_dir (name ^ "/" ^ dir)
        | dir :: t ->
          create_dir (name ^ "/" ^ dir);
          build_struct name t
      in

      create_dir name;
      build_struct name directories

  let create_C_files (name: string): unit =
    let files: string list = [
      "include/" ^ name ^ ".h";
      "src/main.c";
      "Prefect.toml"
    ]
    in
    let return_string (name: string) (file: string): string =
      match String.get file (String.length file - 1) with
        | 'c' ->
          (
            "#include \"../include/" ^ name ^ ".h\""
            ^ "\n\n"
            ^ "int main(void) {"
            ^ "\n"
            ^ "    printf(\"Hello, Prefect !\");"
            ^ "\n"
            ^ "    return (0);"
            ^ "\n}"
          );
        | 'h' -> (
            "#ifndef "
            ^ (String.uppercase_ascii name) ^ "_H"
            ^ "\n"
            ^ "# define "
            ^ (String.uppercase_ascii name) ^ "_H"
            ^ "\n"
            ^ "# include <stdio.h>"
            ^ "\n"
            ^ "#endif"
          );
        | 'l' ->
          let result = (Unix.open_process_in "pwd") in

          (
            "[project]\n"
            ^ "name = " ^ "\"" ^ name ^ "\"" ^ "\n"
            ^ "project_dir = " ^ "\"" ^ (input_line result) ^ "/" ^ name ^ "\"" ^ "\n"

            ^ "\n[deps]\n"
            ^ "src = [" ^ "\"" ^ "main.c" ^ "\"]\n"

            ^ "\n[options]\n"
            ^ "compiler = " ^ "gcc\n"
            ^ "gdb = " ^ "false\n"
            ^ "flags = " ^ "[" ^ "\"-Wall\", \"-Wextra\", \"-Werror\"" ^ "]"
          );
        | _ -> "Drink up. The world’s about to end.\n"
    in
    let create (name: string) (file: string) =
      let oc = open_out (name ^ "/" ^ file) in
      output_string oc (return_string name file);
      close_out oc
    in
    let rec create_files' (name: string) = function
      | [] -> print_endline "Empty file information"
      | [file] -> create name file
      | file :: t ->
        create name file;
        create_files' name t
    in

    create_files' name files

  let init_git (project_name: string): unit =
    let git_commands project_name =
      try
        Sys.command (
          "git init " ^ project_name
          ^ ";"
          ^ "cd " ^ project_name
          ^ ";"
          ^ "git add ."
          ^ ";"
          ^ "git commit -m \"Initial commit\""
          ^ ";"
          ^ "cd .."
        )
      with
      | Failure msg -> Printf.printf "\nFailed to create git with: %s\n" msg; 1
      | _ -> 0
    in
    let result = git_commands project_name in

    if result = 0 then
      print_endline "Git repository created !"
    else
      Printf.printf "Failed to create git repository with error: %d" result

  let initial_message (name: string): unit =
    let message =
     (
       "\nCreated a new project named " ^ name ^ "\n"
       ^ "\ncd " ^ name ^ "\n"
       ^ "\nprefect build\n"
       ^ "\nprefect run\n"
     )
    in

    print_endline message

  let create_project = function
    | [project_name] ->
      create_C_structure project_name;
      create_C_files project_name;
      init_git project_name;
      initial_message project_name
    | _ -> print_endline "Nothing to do"
end
