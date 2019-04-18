module Log = Winston.SyslogMake(struct
    let transports = [Winston.Transport.file ~filename: "/dev/null" ()]
    let formats = [
      Winston.Format.label ~label: "test" ~message: false;
      Winston.Format.timestamp ~format:"YYYY-MM-DD HH:mm:ss" ();
      Winston.Format.json ();
    ]
    let level = `Debug
end);;

let log_normal ?meta () = Log.log `Info "ok" ?meta ()
let log_fast : unit -> unit [@bs]
= fun [@bs] () -> (Obj.magic Log.log) `Info "ok" () [@bs]

