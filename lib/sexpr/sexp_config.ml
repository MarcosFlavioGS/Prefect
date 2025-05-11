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


  let write_config (name : string) (file : string) (cwd: string) : unit =
    let sexp = default_config name cwd in
    (* atomically write a human-readable sexp *)
    Sexp.save_hum (cwd ^ "/" ^ name ^ "/" ^ file) sexp
    (* returns () on success, or raises on I/O error *)


  let read_config ~(file : string) ~(item : string) : string =
  (* load exactly one sexp from [file] *)
  let sexp = Sexp.load_sexp file in
  match sexp with
  | List fields ->
    let find_pair = function
      | List [Atom key; Atom v] when String.equal key item -> Some v
      | _ -> None
    in
    (match List.find_map fields ~f:find_pair with
     | Some v -> v
     | None   -> failwith ("Key not found: " ^ item))
  | _ -> failwith "Invalid config format: expected a list of pairs"

end
