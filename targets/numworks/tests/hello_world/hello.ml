(**
hello.ml: example of some tiny OCaml code to be compiled to an NWA app for the Numworks
Simply install OMicroB with this line from the main OMicroB directory:
$ make clean && ./configure -target numworks && make
Then run in this tests/hello_world/ directory
$ make
Then flash the hello.nwa app to your Numworks calculator, using <https://my.numworks.com/apps> !
*)

(* WOOW reading and displaying the content of a file (from C) worked! *)
print_endline "cat_ocamlpy_file...";;
cat_ocamlpy_file ();;
print_endline "cat_ocamlpy_file done";;
delay 3000;;

(* (* TODO: read from C and return a OCaml string *) *)
(* print_endline "read_ocamlpy_file...\r\n";; *)
(* let content_of_ocamlpy_file : string = read_ocamlpy_file () ;; *)
(* print_endline "read_ocamlpy_file done\r\n";; *)
(* delay 5000;; *)

(* display_push_allscreen_uniform color_black;; *)
(* display_draw_string_small content_of_ocamlpy_file 0 0;; *)
(* delay 10000;; *)

(* display_push_allscreen_uniform color_blue;; *)
(* display_draw_string_small (String.make 50 'X') 0 0;; *)
(* delay 10000;; *)

let clear_screen () = display_push_allscreen_uniform color_black;;
clear_screen ();;

print_endline "open Genlex...";;
open Genlex;;
delay 25000;;

print_endline "open Printf...";;
open Printf;;
delay 25000;;

(* Examples of OCaml basic code *)
let rec fact n =
  if n <= 1 then 1
  else n * fact(n-1)
;;

let rec fibonacci n =
  if n <= 1 then n
  else fibonacci (n-1) + fibonacci (n-2)
;;


(** TODO: finish this main() test function. *)
let main () =
  delay 1000; clear_screen ();
  print_endline "Starting main() tests...\r\nIn 1 secs\r\n";

  (* Dynamically generated strings works fine too *)
  delay 1000; clear_screen ();
  print_endline (String.make 100 'X');

  assert(true);
  (* this should fail ! what happens for an assert(false) on the Numworks ? *)
  (* assert(120 < 100); *)
  (* FIXME: this prints "Error!" continuously... not very useful... *)

  delay_usec 1_000_000; clear_screen ();
  print_endline "After a delay_usec 1_000_000";

  (* delay 1000; *)
  (* print_newline (); *)

  delay 1000; clear_screen ();
  print_endline "print_endline():";

  delay 1000; clear_screen ();
  print_endline "print_int 42:";
  print_int 42;

  delay 1000; clear_screen ();
  print_endline "print_float 3.1415:";
  print_float 3.1415;

  delay 1000; clear_screen ();
  print_endline "print_char '?':";
  print_char '?';

  delay 1000; clear_screen ();
  print_endline "millis():";
  print_int (millis ());
  delay 3000; clear_screen ();
  print_endline "After delay(3000)";
  print_int (millis ());

  delay 1000; clear_screen ();
  print_endline "Loop #1.";
  let nb_loop = 3 in
  for _ = 1 to nb_loop do
    print_endline "Hello from OCaml VM";
    delay 100;
    print_endline "Running on Numworks?";
    delay 100;
  print_endline "Compiled thanks to OMicroB !";
  done;
  print_endline "End loop #1.";

  delay 1000; clear_screen ();
  print_endline "Loop #2.";
  let max_n = 12 in
  for n = 0 to max_n do
    print_string "fact "; print_int n; print_string " = "; print_int (fact n);
    print_newline();
    delay 100;
  done;
  print_endline "End loop #2.";
  delay 1000;

  delay 1000; clear_screen ();
  print_endline "Loop #3.";
  (* FIXME: fibonacci fails VERY quickly, I guess the stack size for recursive function is VERY LIMITED? *)
  let max_n = 10 in
  for n = 0 to max_n do
    print_string "fibonacci "; print_int n; print_string " = "; print_int (fibonacci n);
    print_newline();
    delay 100;
  done;
  print_endline "End loop #3.";

  delay 1000; clear_screen ();
  print_endline "Loop #4.";
  let delta_y = 18 in
  for i = 1 to 12 do
    let x = i and y = delta_y * i in
    let text = "draw at {" ^ (string_of_int x) ^ ", " ^ (string_of_int y) ^ "}" in
    display_draw_string text x y ;
    delay 250;
  done;
  delay 250;
  print_endline "End loop #4.";

  delay 1000; clear_screen ();
  print_endline "Loop #5.";
  let small_delta_y = 10 in
  for i = 1 to 23 do
    let x = i and y = small_delta_y * i in
    let text = "draw small at {" ^ (string_of_int x) ^ ", " ^ (string_of_int y) ^ "}" in
    display_draw_string_small text x y ;
    delay 250;
  done;
  delay 250;
  print_endline "End loop #5.";

  (* FIXME: this test breaks my calculator, it makes it RESET completely! *)
  (* let array_colors = [| color_black; color_white; color_red; color_green; color_blue |] in
  let array_name_colors = [| "black"; "white"; "red"; "green"; "blue" |] in
  let nb_colors = Array.length array_colors in

  for color1 = 0 to nb_colors-1 do
    for color2 = 0 to nb_colors-1 do
      for i = 1 to 12 do
        let x = 0 and y = delta_y * i in
        let text = "draw " ^ (array_name_colors.(color1)) ^"/" ^ (array_name_colors.(color2)) ^ " at {" ^ (string_of_int x) ^ "," ^ (string_of_int y) ^ "}" in
        print_endline text;
        delay 1000;
        (* FIXME: this test breaks my calculator, it makes it RESET completely! *)
        display_draw_string_full text x y true array_colors.(color1) array_colors.(color2) ;
        delay 1000;
      done;
      delay 2000;
    done;
    delay 200;
  done;
  delay 1000; *)


  delay 1000; clear_screen ();
  print_endline "Done for all the tests.";
  delay 1000;
;;

main ();;
