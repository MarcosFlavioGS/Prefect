(** Lib to manage toml*)
module TmlUtils : sig
  (** Reads an value from a field in a .toml file and returns the value*)
  val read_toml : string -> string -> string
end
