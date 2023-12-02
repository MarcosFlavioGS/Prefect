(* opening modules *)
module Create = Creator.New_project.CreateProject
module Gen = Generator.Generate.GenerateStruct
module Build = Builder.Build_project.BuildProject
module Run = Runner.Run_project.RunProject
module Help = Help.HelpModule

(* Checks if there are arguments *)
let check_args (): string list =
  if Array.length Sys.argv < 2 then
    (
      print_endline "Please provide one or more arguments...";
      exit 1
    )
  else
    Array.to_list Sys.argv

(* Entrypoint *)
let () =
  let argv: string list = check_args () in
  let exec_commands (_len: int) = function
    | _ :: ("new" | "n") :: args -> Create.create_project args
    | _ :: ("build" | "b") :: args -> Build.build_project args
    | _ :: ("run" | "r") :: args -> Run.run_project args
    | _ :: ("generate" | "g") :: args -> Gen.generate args
    | _ :: ("help" | "h") :: _args -> Help.help ()
    | _  -> failwith "Invalid_argument..."
  in

  exec_commands (List.length argv) argv;
