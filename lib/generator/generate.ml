(** Generate Module *)
module GenerateStruct = struct
  module Git = Git.Git_utils.GitUtils
  module Sexpr = Sexpr.Sexp_config.SexpConfig
  open Str

  let generate_makefile (path: string) =
    let replace (str: string) (reg: string) (sub: string): string =
      let regex = regexp reg in

      global_replace regex sub str
    in

    let get_makefile_content (path: string) =
      let remove_at (str: string): string =
        let regex = regexp "\\/+" in
        if String.length str > 1 then
          Str.replace_first regex "" str
        else
          str
      in

      let config_path = path ^ "/Prefect.sexp" in

      let name = replace (Sexpr.read_config ~path:config_path ~item:"name") "\"+" "" in
      let cc = replace (Sexpr.read_config ~path:config_path ~item:"compiler") "\"+" "" in
      let flags = Sexpr.read_config ~path:config_path ~item:"flags" in
      let src = (replace (Sexpr.read_config ~path:config_path ~item:"src") "\"+" ""
                 |> (fun x -> split (regexp "\\ +") x)
                 |> List.map (fun element -> (remove_at element) ^ " \\\n\t\t")
                 |> (fun x -> String.concat " " x))(* TODO: Remove last \ char *)
      in
      (
        "NAME = " ^ name ^ "\n\n"
        ^"CC = " ^ cc ^ "\n\n"
        ^ "FLAGS = " ^ flags ^ "\n\n"
        ^ "OBJ_DIR = obj/\n\n"
        ^ "SRC =\t" ^ src ^ "\n"
        ^ "all:\n"
        ^ "\t$(CC) $(FLAGS) $(SRC) -o $(NAME)" ^ "\n\n"
        ^ "clean:\n"
        ^ "\trm -rf $(OBJ_DIR)" ^ "\n\n"
        ^ "fclean: clean\n"
        ^ "\trm -rf bin/$(NAME)\n\n"
        ^ "re: fclean all"
      )
    in

    let create_mf (path: string) (file: string): unit =
      let oc = open_out (path ^ "/" ^ file) in

      output_string oc (get_makefile_content path);
      close_out oc
    in

    create_mf path "Makefile";
    print_endline "Makefile created !"

  let generate = function
    | ["makefile"] ->
      Git.find_git_project_root ()
      |> generate_makefile

    | ["raylib"] ->
      (* TODO: Create Raylib project deps *)
      print_endline "Generating Raylib deps is not yet implemented, come back in a couple of world ending events."

    | [arg] ->
      (* TODO: Generate project dependencies *)
      Printf.printf (
        "DON'T PANIC !!!\nFunctionality to generate %s not yet implemented."
      ) arg

    | _ -> failwith "No option available"
end
