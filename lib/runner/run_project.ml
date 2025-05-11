(** Run Project module *)
module RunProject = struct
  module Build = Builder.Build_project.BuildProject
  module Git = Git.Git_utils.GitUtils
  module Sexpr = Sexpr.Sexp_config.SexpConfig

  open Str

  let runnner (path: string): unit =
    let config_path = path ^ "/Prefect.sexp" in

    let replace (str: string) (reg: string) (sub: string) =
      let regex = regexp reg in

      global_replace regex sub str
    in

    let run (path: string): int =
      let name = replace (Sexpr.read_config ~path:config_path ~item:"name") "\"+" ""  in

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
      Build.build_project [];
      Git.find_git_project_root ()
      |> runnner

    | arg :: _ -> Printf.printf "Argument %s is invalid\n" arg
end
