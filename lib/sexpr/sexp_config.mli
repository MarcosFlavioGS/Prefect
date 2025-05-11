(** Module to write and read to config file *)
module SexpConfig : sig
  (** Writes default config file *)
  val write_config : name:string -> file:string -> cwd:string -> unit

  (** Read from config file*)
  val read_config : path:string -> item:string -> string
end
