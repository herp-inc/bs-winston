module Log = Winston.SyslogMake(struct
    let transports = [Winston.Transport.console ()]
    let formats = [
      Winston.Format.label ~label: "test" ~message: false;
      Winston.Format.timestamp ~format:"YYYY-MM-DD HH:mm:ss" ();
      Winston.Format.json ();
    ]
    let level = `Debug
  end)

let () =
  Log.log `Info "Hello World" [@bs];
  Log.log `Crit "OCaml. Not Ocaml." [@bs];
  Log.log `Err "Oops" [@bs];;
