(** Module tp create a new project *)
module CreateProject = struct
  let create_project = function
    | [elem] -> Printf.printf "Created a new project named %s\n" elem
    | _ -> print_endline "Nothing to do"
end
