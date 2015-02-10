#use "topfind";;
#require "netamqp,nettls-gnutls";;

open Netamqp_types
open Printf

let () =
  Netamqp_endpoint.Debug.enable := true;
  Netamqp_transport.Debug.enable := true


let esys = Unixqueue.create_unix_event_system()
let tls_config =
  Netsys_tls.create_x509_config
    ~peer_auth:`None
    (Netsys_crypto.current_tls())
let p = `TLS(`Inet("localhost", 5671), tls_config)
let ep = Netamqp_endpoint.create p (`AMQP_0_9 `One) esys
let c = Netamqp_connection.create ep
let auth = Netamqp_connection.plain_auth "guest" "guest"

let test1() =
  Netamqp_connection.open_s c [ auth ] (`Pref "en") "/";
  eprintf "*** Connection could be opened, and the proto handshake is done!\n%!";
  let props = Netamqp_endpoint.tls_session_props ep in
  Netamqp_connection.close_s c;
  eprintf "*** Connection could be closed!\n%!";
  match props with
    | None -> failwith "No TLS props!"
    | Some p -> p

