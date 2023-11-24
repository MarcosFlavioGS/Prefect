(** Build project module_ *)
module BuildProject = struct
  module Git = Git.Git_utils.GitUtils
  module Tml = Ctml.Tml.TmlUtils
  open Str

  let replace (str: string) (reg: string) (sub: string): string =
    let regex = regexp reg in

    global_replace regex sub str

  let compile (path: string): unit =
    let cc = replace (Tml.read_toml path "compiler") "\"+" "" in
    let flags = (replace (Tml.read_toml path "flags") "\"+" ""
                 |> (fun x -> replace x "\\[+" "")
                 |> (fun x -> replace x "\\]+" "")
                 |> (fun x -> replace x "\\,+" " "))
    in
    let name = replace (Tml.read_toml path "name") "\"+" ""  in
    let src = (replace (Tml.read_toml path "src") "\"+" ""
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
    let cc = replace (Tml.read_toml path "compiler") "\"+" "" in
    let flags = (replace (Tml.read_toml path "flags") "\"+" ""
                 |> (fun x -> replace x "\\[+" "")
                 |> (fun x -> replace x "\\]+" "")
                 |> (fun x -> replace x "\\,+" " "))
    in
    let src = (replace (Tml.read_toml path "src") "\"+" ""
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
      Git.find_git_project_root ()
      |> compile
    | "-c" :: _ ->
      Git.find_git_project_root ()
      |> compile_obj
    | arg :: _ -> Printf.printf "Argument %s is invalid\n" arg
end
