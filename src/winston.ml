module type LogLevel = sig
  type t
  val string_of_t : t -> string
  val enabled : t list
end

module Transport = struct
  type t = Winston_internal.transport

  let console ?eol () =
    let opt = Winston_internal.mk_console_transport_option ?eol () in
    Winston_internal.console_transport opt
end

module Format = struct
  type t = Winston_internal.format

  let label ~label ~message =
    let opt = Winston_internal.mk_label_format_option ~label ~message in
    Winston_internal.label_format opt

  let json ?space () =
    let opt = Winston_internal.mk_json_format_option ?space () in
    Winston_internal.json_format opt

  let timestamp () = Winston_internal.timestamp_format ()

  let combine fs = Winston_internal.combine @@ Array.of_list fs
end

module Make(Level: LogLevel)(Conf: sig
    val transports: Winston_internal.transport list
    val level: Level.t
    val formats: Format.t list
  end) = struct
  type t = Level.t

  let _levels = Level.enabled |> List.mapi (fun i l -> (Level.string_of_t l, i)) |> Js.Dict.fromList

  let w = Winston_internal.(create_logger @@ mk_option
                              ~levels: _levels
                              ~level: (Level.string_of_t Conf.level)
                              ~transports: (Conf.transports |> Array.of_list)
                           )

  let log ~level ~message ?meta () =
    let dict = meta |> function
      | Some x -> x
      | None -> Js.Dict.empty () in
    Winston_internal.log w level message dict
end

module SyslogMake = Make(Winston_syslog.LogLevel)