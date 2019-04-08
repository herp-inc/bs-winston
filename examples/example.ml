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
