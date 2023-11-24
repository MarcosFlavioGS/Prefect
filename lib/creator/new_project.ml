(** Module tp create a new project *)
module CreateProject = struct
  module Git = Git.Git_utils.GitUtils
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
      let create_dir (dir_name: string): unit =
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
            ^ "    printf(\"Drink up. The world’s about to end.\");"
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
            "name = " ^ "\"" ^ name ^ "\"" ^ "\n"
            ^ "project_dir = " ^ "\"" ^ (input_line result) ^ "/" ^ name ^ "\"" ^ "\n\n"

            ^ "src = [" ^ "\"" ^ "/src/main.c" ^ "\"]\n\n"

            ^ "compiler = " ^ "\"gcc\"\n"
            ^ "flags = " ^ "[" ^ "\"-Wall\", \"-Wextra\", \"-Werror\"" ^ "]"
          );
        | _ -> "Drink up. The world’s about to end.\n"
    in

    let create (name: string) (file: string): unit =
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
      Git.init_git project_name;
      initial_message project_name
    | _ -> print_endline "Nothing to do"
end
