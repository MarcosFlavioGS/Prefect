(* opening modules *)
open New_project.CreateProject;;
open Generate.GenerateStruct;;
open Build_project.BuildProject;;
open Run_project.RunProject;;

(* Checks if there are arguments *)
let check_args (): string list =
  if Array.length Sys.argv < 2 then
    (print_endline "Please provide one or more arguments..."; exit 1)
  else
    Array.to_list Sys.argv

(* Entrypoint *)
let () =
  let argv: string list = check_args () in
  let exec_commands (args: string list) (_len: int) =
    match args with
    | ("new" | "n") :: arg -> create_project arg
    | ("generate" | "g") :: arg -> generate arg
    | ("build" | "b") :: arg -> build_project arg
    | ("run" | "r") :: arg -> run_project arg
    | _  -> failwith "Invalid_argument..."
  in
  match argv with
  | [] -> assert false
  | _ :: rest -> let args: string list = rest in

  exec_commands args (List.length args);
