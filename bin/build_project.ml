(** Build project module_ *)
module BuildProject = struct
  let build_project  = function
    | [] -> print_endline "Building Project !"
    | arg :: _ -> Printf.printf "Argument %s is invalid\n" arg
end
