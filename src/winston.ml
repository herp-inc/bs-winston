module type LogLevel = sig
  type t
  val string_of_t : t -> string
  val enabled : t list
end

module Syslog = struct

  type t = [
    | `Emerg [@bs.as "emerg"]
    | `Alert [@bs.as "alert"]
    | `Crit [@bs.as "crit"]
    | `Err [@bs.as "error"]
    | `Warn [@bs.as "warning"]
    | `Notice [@bs.as "notice"]
    | `Info [@bs.as "info"]
    | `Debug [@bs.as "debug"]
  ] [@@bs.deriving jsConverter]

  let enabled = [`Emerg; `Alert; `Crit; `Err; `Warn; `Notice; `Info; `Debug]
  let string_of_t x = tToJs x
end

module Make(Level: LogLevel)(Conf: sig
    val transports: Winston_internal.transport list
    val level: Level.t
  end) = struct
  type t = Level.t

  type log_entry = {
    message: string;
    level: Level.t;
  }

  let _levels = Level.enabled |> List.mapi (fun i l -> (Level.string_of_t l, i)) |> Js.Dict.fromList

  let w = Winston_internal.(create_logger @@ mk_option
                              ~levels: _levels
                              ~level: (Level.string_of_t Conf.level)
                              ~transports: (Conf.transports |> Array.of_list)
                           )

  let log level message  =
    let entry = Winston_internal.mk_log_entry ~level: (Level.string_of_t level) ~message in
    Winston_internal.log w entry
end

module SyslogMake = Make(Syslog)
