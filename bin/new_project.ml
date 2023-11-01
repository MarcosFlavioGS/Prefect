(** Module tp create a new project *)
module CreateProject = struct
  let create_structure (name: string) =
      let directories: string list = ["src"; "include"; "test"; "bin"] in
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

  let create_files (name: string) =
    let files: string list = ["include/" ^ name ^ ".h"; "src/main.c"] in
    let create (name: string) (file: string) =
      let oc = open_out (name ^ "/" ^ file) in
      output_string oc "Hello\n";
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

  let create_project = function
    | [project_name] ->
      create_structure (project_name);
      create_files (project_name);
      Printf.printf "Created a new project named %s\n" project_name
    | _ -> print_endline "Nothing to do"
end
