(** Build project module_ *)
module BuildProject = struct
  let find_git_project_root () =
    let result = Unix.open_process_in "git rev-parse --show-toplevel" in
    input_line result

  let move_root (path: string) =
    let command path =
      try
        Sys.command ("cd " ^ path)
      with
      | Failure err -> Printf.printf "failed with error: %s" err; 1
      | _ -> 0
    in
    let result = command path in

    if result <> 0 then
      failwith "Failed to move to derectory\n"

  let compile () =
    let flags = "-Wall" ^ " " ^ "-Wextra" ^ " " ^ "-Werror" ^ " " in
    let name = "idea" in
    let compilation_command = (
      "gcc " ^ flags ^ "src/main.c" ^ " " ^ "-o" ^ " " ^ "./bin/" ^ name
    ) in
    let exit_code = Unix.system compilation_command in

    match exit_code with
    | Unix.WEXITED 0 ->
      print_endline "compilation successful !"
    | _ ->
      print_endline "Compilation failed..."

  let build_project  = function
    | [] ->
      find_git_project_root ()
      |> move_root;
      compile ()
      (* TODO: Build project *)
    | arg :: _ -> Printf.printf "Argument %s is invalid\n" arg
end
