(* Interprète MML pour la Numworks *)

(* (* FIXME: remove this FAKE implementation when compiling for the Numworks *) *)
(* let read_any_file filename = "" *)
(* let delay _ = () *)
(* let clear_screen () = () *)
(* let display_draw_string s x y = print_endline s *)

open Mylexing

let long_delay = 5000
let short_delay = 500
let delta_y = 18
let exit (code:int) = ()

let usage = "usage: ./minicaml filename.mml"

let spec = []

(* FIXME: use EADK Numworks to read the content of a filename on the Numworks. *)
let filename = "minicaml.py";;

delay short_delay;;
clear_screen ();;
delay short_delay;;
display_draw_string ("Loading code from " ^ filename ^ " ...") 0 0;;
delay long_delay;;

(* DONE: this is now read from a 'filename' file, from the local storage *)
let minicaml_file_content = read_any_file filename
let default_filecontent = ref "";;
if minicaml_file_content <> "" then
  default_filecontent := minicaml_file_content
else
  default_filecontent := "let rec fibonacci (n: int) :int =
  if n < 3 then
    1
  else
    fibonacci (n-1) + fibonacci (n-2)
in
fibonacci 30"

let report (b,e) =
  let lnum = b.pos_lnum in
  let fc = b.pos_cnum - b.pos_bol + 1 in
  let lc = e.pos_cnum - b.pos_bol + 1 in
  print_endline ("File \"" ^ filename ^ "\", line " ^ (string_of_int lnum) ^ ", characters " ^ (string_of_int fc) ^ "-" ^ (string_of_int lc) ^ ":")

let () =
  (* FIXME: use EADK Numworks to read the content of a filename on the Numworks. *)
  let lb = Mylexing.from_string (!default_filecontent) in
  try
    display_draw_string "Reading the file..." 0 0;
    delay short_delay;

    let prog = Mmlparser.program Mmllexer.token lb in
    delay short_delay;

    let type_of_prog = Typechecker.type_prog prog in
    display_draw_string "Type of the program: " 0 delta_y;
    display_draw_string (Mml.typ_to_string type_of_prog) 0 (2*delta_y);
    delay short_delay;

    display_draw_string "Evaluation of the program: " 0 (3*delta_y);
    delay short_delay;
    let v = Interpreter.eval_prog prog in
    Interpreter.draw_string v 0 (4*delta_y);
    delay short_delay;
    clear_screen ();
    delay long_delay;
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
     (* print_endline ("Anomaly: " ^ (Printexc.to_string e)); *)
     print_endline ("Anomaly: (some exception)");
     exit 2
