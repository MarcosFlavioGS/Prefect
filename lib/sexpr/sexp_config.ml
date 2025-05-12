(* lib/sexpr/sexp_config.ml *)
module SexpConfig = struct
  open Core
  open Sexplib.Sexp

  let default_config (name : string) (cwd: string) : Sexp.t =
    List [
      List [ Atom "name"       ; Atom name ];
      List [ Atom "project_dir"; Atom (cwd ^ "/" ^ name) ];
      List [ Atom "src"        ; List [ Atom "/src/main.c" ] ];
      List [ Atom "compiler"   ; Atom "gcc" ];
      List [ Atom "flags"      ; List [ Atom "-Wall"; Atom "-Wextra"; Atom "-Werror" ] ];
    ]

  let format_sexp sexp =
    let rec format indent = function
      | Atom s -> s
      | List [] -> "()"
      | List [x] -> "(" ^ format 0 x ^ ")"
      | List (x :: xs) ->
        let indent_str = String.make (indent * 2) ' ' in
        let first = "(" ^ format (indent + 1) x in
        let rest = List.map xs ~f:(fun x -> indent_str ^ format (indent + 1) x) in
        first ^ "\n" ^ String.concat ~sep:"\n" rest ^ ")"
    in
    format 0 sexp

  let write_config ~(name : string) ~(file : string) ~(cwd: string) : unit =
    let sexp = default_config name cwd in
    let formatted = format_sexp sexp in
    Out_channel.write_all (cwd ^ "/" ^ name ^ "/" ^ file) ~data:formatted

  let read_config ~(path : string) ~(item : string) : string =
    let sexp = load_sexp path in
    let value_sexp =
      match sexp with
      | List fields ->
        let maybe_v =
          List.find_map fields ~f:(function
            | List [Atom k; v] when String.equal k item -> Some v
            | _ -> None)
        in
        (match maybe_v with
         | Some v -> v
         | None   -> failwith ("Key not found: " ^ item))
      | Atom _ ->
        failwith "Invalid config format: expected a list of pairs"
    in
    (* flatten Atom or List of Atoms into a space-separated string *)
    match value_sexp with
    | Atom s -> s
    | List elems ->
      elems
      |> List.map ~f:(function
           | Atom s -> s
           | _ -> failwith "Unexpected nested sexp")
      |> String.concat ~sep:" "

end
