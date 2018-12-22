type transport

type mk_console_transport_option = {
  eol: string [@bs.optional]
} [@@bs.deriving abstract]

external console_transport: mk_console_transport_option -> transport = "Console" [@@bs.new][@@bs.module "winston/lib/winston/transports/index"]

(* winston本体 *)

type mk_option = {
  levels: int Js.Dict.t;
  level: string;
  transports: transport array;
} [@@bs.deriving abstract]

type winston

external create_logger: mk_option -> winston = "createLogger" [@@bs.module "winston"]

type mk_log_entry = {
  level: string;
  message: string;
} [@@bs.deriving abstract]

external log: winston -> mk_log_entry -> unit = "" [@@bs.send]
