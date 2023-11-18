(** Build project module_ *)
module BuildProject = struct
  open Toml
  let find_git_project_root () =
    let result = Unix.open_process_in "git rev-parse --show-toplevel" in
    input_line result

  let compile (path: string) =
    let read_toml (path: string) (_item: string): string =
      let toml: Parser.result = Toml.Parser.from_filename (path ^ "/Prefect.toml") in
      match toml with
      | `Ok value -> Toml.Printer.string_of_table value;
      | `Error (message, _) -> failwith message
    in
    let cc = "gcc" in (* TODO: Get compiler info *)
    let debug = "" in (* TODO: Get if debug true *)
    let flags = "-Wall" ^ " " ^ "-Wextra" ^ " " ^ "-Werror" ^ " " ^ debug in
    let name = "idea" in (* TODO: Get name of the project *)
    let src = path ^ "/src/main.c" in (* TODO: Get path to src files *)
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
    let exit_code = Unix.system compilation_command in

    match exit_code with
    | Unix.WEXITED 0 ->
      print_endline (read_toml path "item");
      print_endline "compilation successful !"
    | _ ->
      print_endline "Compilation failed..."

  let build_project  = function
    | [] ->
      find_git_project_root ()
      |> compile
    | arg :: _ -> Printf.printf "Argument %s is invalid\n" arg
end
