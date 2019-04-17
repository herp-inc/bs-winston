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

  let file ?eol ?dirname ?filename () =
    let opt = Winston_internal.mk_file_transport_option ?eol ?dirname ?filename () in
    Winston_internal.file_transport opt
end

module Format = struct
  type t = Winston_internal.format

  let label ~label ~message =
    let opt = Winston_internal.mk_label_format_option ~label ~message in
    Winston_internal.label_format opt

  let json ?space () =
    let opt = Winston_internal.mk_json_format_option ?space () in
    Winston_internal.json_format opt

  let timestamp ?format () =
    let opt = Winston_internal.mk_timestamp_format_option ?format () in
    Winston_internal.timestamp_format opt

  let combine fs = Winston_internal.apply Winston_internal.combine @@ Array.of_list fs
end

module type LOG = sig
  type t

  val log: t -> string -> ?meta:string Js.Dict.t -> unit -> unit
end

module Make(Level : LogLevel)(Conf : sig
    val transports: Winston_internal.transport list
    val formats: Format.t list
    val level: Level.t
  end): LOG with type t = Level.t = struct
  type t = Level.t

  let _levels = Level.enabled |> List.mapi (fun i l -> (Level.string_of_t l, i)) |> Js.Dict.fromList

  let w =
    let f = Format.combine Conf.formats in
    Winston_internal.(create_logger @@ mk_option
                        ~levels: _levels
                        ~level: (Level.string_of_t Conf.level)
                        ~format: f
                        ~transports: (Conf.transports |> Array.of_list)
                        ()
                     )

  let log level message ?meta () =
    let dict = meta |> function
      | Some x -> x
      | None -> Js.Dict.empty () in
    let l = Level.string_of_t level in
    Winston_internal.log w l message dict
end

module SyslogMake = Make(Winston_syslog.LogLevel)
module NpmMake = Make(Winston_npm.LogLevel)
