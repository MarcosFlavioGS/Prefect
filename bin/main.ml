let check_args () =
  if Array.length Sys.argv < 2 then
    (print_endline "Please provide one or more arguments..."; exit 1)
  else
    Array.to_list Sys.argv


let () = let args = check_args () in
  Printf.printf "%s\n" (String.concat ", " args)
