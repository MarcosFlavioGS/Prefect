(** Genrate Module *)
module GenerateStruct = struct
  let generate = function
    | [arg] ->
      (* TODO: Generate project dependencies *)
      Printf.printf (
        "DON'T PANIC !!!\nFunctionality to generate %s not yet implemented, come back in a couple of world ending events."
      ) arg
    | _ -> failwith "No option available"
end
