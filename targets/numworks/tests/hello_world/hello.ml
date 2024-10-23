(**
hello.ml: example of some tiny OCaml code to be compiled to an NWA app for the Numworks
Simply install OMicroB with this line from the main OMicroB directory:
$ make clean && ./configure -target numworks && make
Then run in this tests/hello_world/ directory
$ make
Then flash (using <https://my.numworks.com/apps>) the hello.nwa app to your Numworks calculator!
*)

let main () =
  delay 1000;
  print_endline "Starting tests";

  delay_usec 1_000_000;
  print_endline "After a delay_usec 1_000_000";

  delay 1000;
  print_newline ();

  delay 1000;
  print_endline "print_endline():";

  delay 1000;
  print_endline "Trying print_int 42:";
  print_int 42;

  (* delay 1000;
  print_endline "Trying print_float 3.1415:";
  print_float 3.1415; *)

  delay 1000;
  print_endline "Trying millis():";
  print_int (millis ());
  delay 1000;
  print_endline "Trying millis() after a delay 1000:";
  print_int (millis ());
  delay 1000;

  delay 1000;
  let nb_loop = 10 in
  for _ = 1 to nb_loop do
    print_endline "Hello from OCaml VM";
    print_endline "Running on Numworks?";
    print_endline "Compiled thanks to OMicroB !";
  done;
  delay 1000;

  print_string "Done for the long for loop.";
  delay 1000;

  let delta_y = 18 in
  for i = 1 to 12 do
    let x = delta_y * i and y = delta_y * i in
    let text =
      "display_draw_string(text) at {"
      ^ (string_of_int x)
      ^ ", "
      ^ (string_of_int y)
      ^ "}"
    in
    display_draw_string text x y ;
    delay 1000;
  done;
  delay 1000;

  print_string "Done for the long for loop.";
  delay 1000;
;;

main ();;
