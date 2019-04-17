bs-winston
===

Bucklescript bindings for (subset of) [winston](https://github.com/winstonjs/winston)@3.x

```ocaml
module Log = Winston.SyslogMake(struct
    let transports = [Winston.Transport.console ()]
    let formats = [
      Winston.Format.label ~label: "test" ~message: false;
      Winston.Format.timestamp ();
      Winston.Format.json ();
    ]
    let level = `Debug
  end)

let () =
  Log.log `Info "Hello World" ();
  Log.log `Crit "OCaml. Not Ocaml." ();
  Log.log `Err "Oops" ();;
```

## contents
```ocaml
module Winston : sig
  module type LogLevel
  module type LOG

  module Transport
  module Format
  module Make
  module SyslogMake
end
```

### `Transport` submodule for [transports](https://github.com/winstonjs/winston#transports)

```ocaml
module Transport : sig
  type t
  val console : ?eol:string -> unit -> t
end
```

Currently we support only `Console`.

### `Format` submodule for [formats](https://github.com/winstonjs/winston#formats)

```ocaml
module Format : sig
  type t
  val label : label:string -> message:bool -> t
  val json : ?space:int -> unit -> t
  val timestamp : ?format:string -> unit -> t
end
```

### `LogLevel` signature
This signature represents the first argument of `Make`.

```ocaml
module type LogLevel = sig
  type t

  val string_of_t : t -> string
  val enabled : t list
end
```

### `Make` functor
This functor generates a logger module.

`LOG` signature represents the logger module.

```ocaml
module type LOG = sig
  type t

  val log: t -> string -> ?meta:string Js.Dict.t -> unit -> unit
end
```

```ocaml
module Make(Level : LogLevel)(Conf : sig
    val transports : Transport.t
    val formats : Format.t list
    val level : Level.t
  end)
  : LOG with type t = Level.t
```

#### `SyslogMake` and `NpmMake` functor
These functors are ones partially applied `Make`.

```ocaml
module SyslogMake(Conf : sig
    val transports : Transport.t
    val formats : Format.t list
    val level : Winston_syslog.LogLevel.t
  end)
  : LOG with type t = Winston_syslog.LogLevel.t
```

```ocaml
module NpmMake(Conf : sig
    val transports : Transport.t
    val formats : Format.t list
    val level : Winston_npm.LogLevel.t
  end)
  : LOG with type t = Winston_npm.LogLevel.t
```

and we provide `Winston_syslog.LogLevel.t` and `Winston_npm.LogLevel` as polymorphic variant type
```ocaml
module Winston_syslog.LogLevel : LogLevel = struct
  type t = [
      | `Emerg  [@bs.as   "emerg"]
      | `Alert  [@bs.as   "alert"]
      | `Crit   [@bs.as    "crit"]
      | `Err    [@bs.as   "error"]
      | `Warn   [@bs.as "warning"]
      | `Notice [@bs.as  "notice"]
      | `Info   [@bs.as    "info"]
      | `Debug  [@bs.as   "debug"]
  ] [@@bs.deriving jsConverter]

  let enabled = [`Emerg; `Alert; `Crit; `Err; `Warn; `Notice; `Info; `Debug]
  let string_of_t x = tToJs x
end
```

```ocaml
module Winston_npm.LogLevel : LogLevel = struct
  type t = [
    | `Err     [@bs.as   "error"]
    | `Warn    [@bs.as    "warn"]
    | `Info    [@bs.as    "info"]
    | `Http    [@bs.as    "http"]
    | `Verbose [@bs.as "verbose"]
    | `Debug   [@bs.as   "debug"]
    | `Silly   [@bs.as   "silly"]
  ] [@@bs.deriving jsConverter]

  ......
end
```

You can follow these implementatoins to write custom module denoting `LogLevel`.

## License
See `LICENSE`
