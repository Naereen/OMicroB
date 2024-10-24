(* Interprète MML *)

open Mylexing

let usage = "usage: ./mmli file.mml"

let spec = []

(* FIXME: use EADK Numworks to read the content of a file on the Numworks. *)
let file =
    let file = ref None in
    let set_file s =
      if not (Filename.check_suffix s ".mml") then
        raise (Arg.Bad "no .mml extension");
      file := Some s
    in
    Arg.parse spec set_file usage;
    match !file with Some f -> f | None -> Arg.usage spec usage; exit 1

let report (b,e) =
  let lnum = b.pos_lnum in
  let fc = b.pos_cnum - b.pos_bol + 1 in
  let lc = e.pos_cnum - b.pos_bol + 1 in
  print_endline ("File \"" ^ file ^ "\", line " ^ (string_of_int lnum) ^ ", characters " ^ (string_of_int fc) ^ "-" ^ (string_of_int lc) ^ ":")

let () =
  (* FIXME: use EADK Numworks to read the content of a file on the Numworks. *)
  let c  = open_in file in
  let lb = Mylexing.from_channel c in
  try
    let prog = Mmlparser.program Mmllexer.token lb
    in
    close_in c;
    ignore (Typechecker.type_prog prog);
    let v = Interpreter.eval_prog prog in
    Interpreter.print_value v;
    exit 0
  with
  | Mmllexer.Lexing_error s ->
     report (lexeme_start_p lb, lexeme_end_p lb);
     print_endline ("lexical error: " ^ s);
     exit 1
  | Mmlparser.Error ->
     report (lexeme_start_p lb, lexeme_end_p lb);
     print_endline "syntax error";
     exit 1
  | Typechecker.Type_error s ->
     print_endline ("type error: " ^ s);
     exit 1
  | e ->
  (* FIXME: remove this dependency on Printexc. module *)
     print_endline ("Anomaly: " ^ (Printexc.to_string e));
     exit 2
