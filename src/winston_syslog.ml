module LogLevel = struct
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
