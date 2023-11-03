(* opening modules *)
module New = Prefect.New_project.CreateProject;;
module Gen = Prefect.Generate.GenerateStruct;;
module Build = Prefect.Build_project.BuildProject;;
module Run = Prefect.Run_project.RunProject;;

(* Checks if there are arguments *)
let check_args (): string list =
  if Array.length Sys.argv < 2 then
    (print_endline "Please provide one or more arguments..."; exit 1)
  else
    Array.to_list Sys.argv

(* Entrypoint *)
let () =
  let argv: string list = check_args () in
  let exec_commands (_len: int) = function
    | _ :: ("new" | "n") :: args -> New.create_project args
    | _ :: ("generate" | "g") :: args -> Gen.generate args
    | _ :: ("build" | "b") :: args -> Build.build_project args
    | _ :: ("run" | "r") :: args -> Run.run_project args
    | _  -> failwith "Invalid_argument..."
  in
  exec_commands (List.length argv) argv;
