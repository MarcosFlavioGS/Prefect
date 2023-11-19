(** Run Project module *)
module RunProject = struct
  let find_git_project_root (): string =
    let result = Unix.open_process_in "git rev-parse --show-toplevel" in
    input_line result

  let runnner (path: string): unit =
    let run (path: string): int =
      try
        Sys.command (path ^ "/bin/" ^ "idea")
      with
      |Failure msg -> Printf.printf "Error: %s" msg; 1
      | _ -> 0
    in

    if run path <> 0 then
      print_endline "Failed to run project..."

  let run_project = function
    | [] ->
      find_git_project_root ()
      |> runnner
    | arg :: _ -> Printf.printf "Argument %s is invalid\n" arg
end
