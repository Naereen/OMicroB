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

val color_black : int
val color_white : int
val color_red : int
val color_green : int
val color_blue : int

val screen_width : int
val screen_height : int

val display_draw_string : string -> int -> int -> unit
val display_draw_string_small : string -> int -> int -> unit
val display_draw_string_large : string -> int -> int -> unit
val display_draw_string_full : string -> int -> int -> bool -> int -> int -> unit (* FIXME: it RESETs the calculator! *)

val display_push_allscreen_uniform : int -> unit

(*******************)
(* Storage library *)
(*******************)

val cat_any_file : string -> int
val cat_ocamlpy_file : unit -> int
val read_any_file : string -> string
val read_ocamlpy_file : unit -> string
