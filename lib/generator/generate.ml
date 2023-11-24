(** Generate Module *)
module GenerateStruct = struct
    module Git = Git.Git_utils.GitUtils

    let generate_makefile (path: string) =
    let create_mf (path: string) (file: string): unit =
      let oc = open_out (path ^ file) in

      output_string oc ("Hello");
      close_out oc
    in

    create_mf path "Makefile";
    print_endline "Makefile created !"

  let generate = function
    | ["makefile"] ->
      Git.find_git_project_root ()
      |> generate_makefile
    | [arg] ->
      (* TODO: Generate project dependencies *)
      Printf.printf (
        "DON'T PANIC !!!\nFunctionality to generate %s not yet implemented, come back in a couple of world ending events."
      ) arg
    | _ -> failwith "No option available"
end
