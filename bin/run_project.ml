(** Run Project module *)
module RunProject = struct
  let run_project = function
    | [] -> print_endline "Run Project !"
    | arg :: _ -> Printf.printf "Argument %s is invalid\n" arg
end
