(** Build project module_ *)
module BuildProject = struct
  module Git = Git.Git_utils.GitUtils
  module Sexpr = Sexpr.Sexp_config.SexpConfig
  open Str

  let replace (str: string) (reg: string) (sub: string): string =
    let regex = regexp reg in

    global_replace regex sub str

  let compile ?optimize:(optimize: string = "") (path: string) (obj: bool): unit =
    let config_path = path ^ "/Prefect.sexp" in
    let cc = replace (Sexpr.read_config ~path:config_path ~item:"compiler") "\"+" "" in
    let flags = Sexpr.read_config ~path:config_path ~item:"flags" ^ " " ^ optimize in
    let name = replace (Sexpr.read_config ~path:config_path ~item:"name") "\"+" ""  in
    let src = (replace (Sexpr.read_config ~path:config_path ~item:"src") "\"+" ""
                 |> (fun x -> split (regexp "\\ +") x)
                 |> List.map (fun element ->
                     if obj then
                       let index = String.rindex element '/' in
                       let len = String.length element in

                       path ^ "/obj/"
                       ^ (replace (String.sub element index (len - index)) "\\.c" ".o")
                     else
                       path ^ element
                   )
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
    let config_path = path ^ "/Prefect.sexp" in
    let cc = replace (Sexpr.read_config ~path:config_path ~item:"compiler") "\"+" "" in
    let flags = Sexpr.read_config ~path:config_path ~item:"flags" in
    let src = (replace (Sexpr.read_config ~path:config_path ~item:"src") "\"+" ""
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
      print_endline "Object files compilation successful !"

    | _ ->
      print_endline "Compilation failed..."

  let build_project  = function
    | [] ->
      Git.find_git_project_root ()
      |> fun path -> compile path false

    | ["--debug"] ->
      Git.find_git_project_root ()
      |> fun path -> compile ~optimize: "-Og" path false;

      print_endline "Debug optimizations made !"

    | ["--release"] ->
      Git.find_git_project_root ()
      |> fun path -> compile ~optimize: "-O3" path false;

      print_endline "Optimizations made !"

    | ["-cb"] | ["-c"; "-b"] ->
      let path = Git.find_git_project_root () in

      path
      |> compile_obj;
      compile path true

    | ["-c"] ->
      Git.find_git_project_root ()
      |> compile_obj

    | [arg] -> Printf.printf "Argument %s is invalid...\n" arg

    | arg :: _ -> Printf.printf "Argument %s is invalid or does not have parameters\n" arg
end
