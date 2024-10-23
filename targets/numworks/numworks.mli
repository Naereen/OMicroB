(* Timing *)

val delay : int -> unit
val delay_usec : int -> unit
val millis : unit -> int

(* Printing *)

val print_string : string -> unit
val print_newline : unit -> unit
val print_endline : string -> unit
val print_int : int -> unit
(* val print_char : char -> unit *)
(* val print_float : float -> unit *)

(* EADK library *)
val display_draw_string : string -> int -> int -> unit

