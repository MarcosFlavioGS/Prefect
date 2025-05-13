module Version = struct
  let get_version (): unit =
    Printf.printf "v%s\n"
      (match Build_info.V1.version () with
       | None -> "n/a"
       | Some version -> Build_info.V1.Version.to_string version
      )
end
