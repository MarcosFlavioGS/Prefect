(** Build project module_ *)
module BuildProject = struct
  open Toml
  open Str

  let find_git_project_root (): string =
    let result = Unix.open_process_in "git rev-parse --show-toplevel" in

    input_line result

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

  let replace (str: string) (reg: string) (sub: string): string =
    let regex = regexp reg in

    global_replace regex sub str

  let compile (path: string): unit =
    let cc = replace (read_toml path "compiler") "\"+" "" in
    let flags = (replace (read_toml path "flags") "\"+" ""
                 |> (fun x -> replace x "\\[+" "")
                 |> (fun x -> replace x "\\]+" "")
                 |> (fun x -> replace x "\\,+" " "))
    in
    let name = replace (read_toml path "name") "\"+" ""  in
    let src = (replace (read_toml path "src") "\"+" ""
                 |> (fun x -> replace x "\\[+" "")
                 |> (fun x -> replace x "\\]+" "")
                 |> (fun x -> replace x "\\ +" "")
                 |> (fun x -> replace x "\\,+" " ")
                 |> (fun x -> split (regexp "\\ +") x)
                 |> List.map (fun element -> path ^ element)
                 |> (fun x -> String.concat " " x))
    in
    let output = "-o" ^ " " ^ path ^ "/bin/" in
    let compilation_command = (
      cc
      ^ " "
      ^ flags
      ^ " "
      ^ src
      ^ " "
      ^ output
      ^ name
    ) in
    (* print_endline compilation_command; *)
    let exit_code = Unix.system compilation_command in

    match exit_code with
    | Unix.WEXITED 0 ->
      print_endline "compilation successful !"
    | _ ->
      print_endline "Compilation failed..."

  let compile_obj (path: string): unit =
    let cc = replace (read_toml path "compiler") "\"+" "" in
    let flags = (replace (read_toml path "flags") "\"+" ""
                 |> (fun x -> replace x "\\[+" "")
                 |> (fun x -> replace x "\\]+" "")
                 |> (fun x -> replace x "\\,+" " "))
    in
    let src = (replace (read_toml path "src") "\"+" ""
                 |> (fun x -> replace x "\\[+" "")
                 |> (fun x -> replace x "\\]+" "")
                 |> (fun x -> replace x "\\ +" "")
                 |> (fun x -> replace x "\\,+" " ")
                 |> (fun x -> split (regexp "\\ +") x)
                 |> List.map (fun element -> path ^ element)
                 |> (fun x -> String.concat " " x))
    in
    let compilation_command = (
      cc
      ^ " "
      ^ flags
      ^ " "
      ^ "-c"
      ^ " "
      ^ src
    ) in
    (* print_endline compilation_command; *)
    let exit_code = Unix.system compilation_command in

    match exit_code with
    | Unix.WEXITED 0 ->
      let result_mv: int = Sys.command ("mv *.o " ^ path ^ "/obj/") in
      if result_mv <> 0 then
        print_endline "Error: Failed to mv object files";
      print_endline "compilation successful !"
    | _ ->
      print_endline "Compilation failed..."

  let build_project  = function
    | [] ->
      find_git_project_root ()
      |> compile
    | "-c" :: _ ->
      find_git_project_root ()
      |> compile_obj
    | arg :: _ -> Printf.printf "Argument %s is invalid\n" arg
end
