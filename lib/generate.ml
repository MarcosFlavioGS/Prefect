(** Genrate Module *)
module GenerateStruct = struct
  let generate = function
    | [arg] ->
      (* TODO: Generate project dependencies *)
      Printf.printf "Generated %s dependencies\n" arg
    | _ -> failwith "No option available"
end
