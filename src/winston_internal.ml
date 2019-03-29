(* transport *)
type transport

type mk_console_transport_option = {
  eol: string [@bs.optional];
} [@@bs.deriving abstract]

external console_transport: mk_console_transport_option -> transport = "Console" [@@bs.new][@@bs.module "winston/lib/winston/transports/index"]

(* format *)
type format

type mk_label_format_option = {
  label: string;
  message: bool;
} [@@bs.deriving abstract]

external label_format: mk_label_format_option -> format = "label" [@@bs.module "logform"]

type mk_json_format_option = {
  space: int [@bs.optional];
} [@@bs.deriving abstract]

external json_format: mk_json_format_option -> format = "json" [@@bs.module "logform"]

external timestamp_format: unit -> format = "timestamp" [@@bs.module "logform"]

external combine: format array -> format = "combine" [@@bs.module "logform"]

(* Logger *)
type winston

type mk_option = {
  levels: int Js.Dict.t;
  level: string;
  transports: transport array;
} [@@bs.deriving abstract]

external create_logger: mk_option -> winston = "createLogger" [@@bs.module "winston"]

external log: winston -> string -> string -> string Js.Dict.t -> unit = "" [@@bs.send]
