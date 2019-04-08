module type LogLevel = sig
  type t

  val string_of_t : t -> string
  val enabled : t list
end

module Transport : sig
  type t = Winston_internal.transport

  val console : ?eol:string -> unit -> t
end

module Format : sig
  type t = Winston_internal.format

  val label : label:string -> message:bool -> t
  val json : ?space:int -> unit -> t
  val timestamp : unit -> t
end

module type LOG = sig
  type t

  val log : t -> string -> ?meta:string Js.Dict.t -> unit -> unit
end

module Make(Level : LogLevel)(Conf : sig
    val transports : Transport.t list
    val formats: Format.t list
    val level : Level.t
  end)
  : LOG with type t = Level.t

module SyslogMake(Conf : sig
    val transports : Transport.t list
    val formats: Format.t list
    val level : Winston_syslog.LogLevel.t
  end)
  : LOG with type t = Winston_syslog.LogLevel.t