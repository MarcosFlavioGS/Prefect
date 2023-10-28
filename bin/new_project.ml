(** Module tp create a new project *)
module CreateProject = struct
  let create_project (args: string list) =
    match args with
    | [elem] -> Printf.printf "Created a new project named %s\n" elem
    | _ -> print_endline "Nothing to do"
end
