(** Module tp create a new project *)
module CreateProject = struct
  let create_structure (name: string) =
      let directories: string list = ["src"; "include"; "test"; "src/main"] in
      let create_dir (dir_name: string) =
        let mode = 0o755 in
        try
          Unix.mkdir dir_name mode;
          Printf.printf "Directory '%s' created successfully\n" dir_name
        with
        | Unix.Unix_error (EEXIST, _, _) ->
          Printf.printf "Directory '%s' already exists\n" dir_name
        | Unix.Unix_error (e, _, _) ->
          Printf.eprintf "Error creating directory: %s\n" (Unix.error_message e)
      in
      let rec build_struct (name: string) = function
        | [] -> print_endline "Done building structure..."
        | [dir] -> create_dir (name ^ "/" ^ dir)
        | h :: t ->
          create_dir (name ^ "/" ^ h);
          build_struct name t
      in

      create_dir name;
      build_struct name directories

  let create_project = function
    | [project_name] ->
      create_structure (project_name);
      Printf.printf "Created a new project named %s\n" project_name
    | _ -> print_endline "Nothing to do"
end
