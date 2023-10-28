(** Genrate Module *)
module GenerateStruct = struct
  let generate (args: string list) =
    match args with
    | [arg] -> Printf.printf "Generated %s dependencies\n" arg
    | _ -> failwith "No option available"
end
