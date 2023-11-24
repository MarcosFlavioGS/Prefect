(** Lib to manage git utils*)
module GitUtils : sig
  (** Find git project root and returns a string*)
  val find_git_project_root : unit -> string

  (** Init a git repo in path parameter*)
  val init_git : string -> unit
end
