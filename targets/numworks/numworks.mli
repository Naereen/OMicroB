(***************************************)
(** Signature of the Numworks library **)
(***************************************)

(**********)
(* Timing *)
(**********)

val delay : int -> unit
val delay_usec : int -> unit
val millis : unit -> int


(************)
(* Printing *)
(************)

val print_string : string -> unit
val print_newline : unit -> unit
val print_endline : string -> unit
val print_int : int -> unit
val print_bool : bool -> unit
val print_char : char -> unit
val print_float : float -> unit


(***********************************)
(* Functions from the EADK library *)
(***********************************)

val display_draw_string : string -> int -> int -> unit
val display_draw_string_small : string -> int -> int -> unit
val display_draw_string_large : string -> int -> int -> unit
val display_draw_string_full : string -> int -> int -> bool -> int -> int -> unit
val color_black : int
val color_white : int
val color_red : int
val color_green : int
val color_blue : int


(*******************)
(* Storage library *)
(*******************)

val read_ocaml_file : unit -> int
val read_any_file : string -> int
