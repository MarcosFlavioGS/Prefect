(** Genrate Module *)
module GenerateStruct = struct
  let generate = function
    | [arg] -> Printf.printf "Generated %s dependencies\n" arg
    | _ -> failwith "No option available"
end
