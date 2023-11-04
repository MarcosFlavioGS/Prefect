(** Builf project interface *)
module BuildProject : sig
  (** Build project *)
  val build_project : string list -> unit
end
