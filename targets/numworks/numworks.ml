(* Timing *)

external delay : int -> unit = "caml_delay" [@@noalloc]
external delay_usec : int -> unit = "caml_delay_usec" [@@noalloc]
external millis : unit -> int = "caml_millis" [@@noalloc]

(* Printing *)

external print_string : string -> unit = "caml_numworks_print_string" [@@noalloc]
external print_newline : unit -> unit = "caml_numworks_print_newline" [@@noalloc]
external print_endline : string -> unit = "caml_numworks_print_endline" [@@noalloc]
external print_int : int -> unit = "caml_numworks_print_int" [@@noalloc]
(* external print_char : char -> unit = "caml_numworks_print_char" [@@noalloc] *)
(* external print_float : float -> unit = "caml_numworks_print_float" [@@noalloc] *)

(* EADK library *)
external display_draw_string : string -> int -> int -> unit = "caml_display_draw_string" [@@noalloc]
