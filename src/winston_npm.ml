module LogLevel = struct
  type t = [
    | `Err [@bs.as "error"]
    | `Warn [@bs.as "warn"]
    | `Info [@bs.as "info"]
    | `Http [@bs.as "http"]
    | `Verbose [@bs.as "verbose"]
    | `Debug [@bs.as "debug"]
    | `Silly [@bs.as "silly"]
  ] [@@bs.deriving jsConverter]

  let enabled = [`Err; `Warn; `Info; `Http; `Verbose; `Debug; `Silly]
  let string_of_t x = tToJs x
end
