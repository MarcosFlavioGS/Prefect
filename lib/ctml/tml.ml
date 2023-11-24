module TmlUtils = struct
  open Toml
  let read_toml (path: string) (item: string): string =
    let table_key: Types.Table.key = Toml.Min.key item in
    let toml: Parser.result = Toml.Parser.from_filename (path ^ "/Prefect.toml") in

    match toml with
    | `Ok table ->
      let result = Toml.Types.Table.find_opt table_key table in

      (
        match result with
        | Some value ->
          Toml.Printer.string_of_value value
        | _ -> "Not found"
      )
    | `Error (message, _) -> failwith message
end
