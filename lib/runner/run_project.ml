(** Run Project module *)
module RunProject = struct
  open Toml
  open Str
  let find_git_project_root (): string =
    let result = Unix.open_process_in "git rev-parse --show-toplevel" in
    input_line result

  let runnner (path: string): unit =
    let read_toml (path: string) (item: string): string =
      let table_key: Types.Table.key = Toml.Min.key item in
      let toml: Parser.result = Toml.Parser.from_filename (path ^ "/Prefect.toml") in
      match toml with
      | `Ok table ->
        let result = Toml.Types.Table.find_opt (table_key) table in

        (
          match result with
        | Some value ->
          Toml.Printer.string_of_value value
        | _ -> "Not found"
        )
      | `Error (message, _) -> failwith message
    in
    let replace (str: string) (reg: string) (sub: string) =
      let regex = regexp reg in
      global_replace regex sub str
    in
    let run (path: string): int =
      let name = replace (read_toml path "name") "\"+" ""  in
      try
        Sys.command (path ^ "/bin/" ^ name)
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
