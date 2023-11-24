module GitUtils = struct
  let find_git_project_root (): string =
    let result = Unix.open_process_in "git rev-parse --show-toplevel" in

    input_line result

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
end
