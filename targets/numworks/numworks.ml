(**********************************)
(** Code of the Numworks library **)
(**********************************)

(**********)
(* Timing *)
(**********)

(** delay ms : sleeps for this amount of milliseconds. *)
external delay : int -> unit = "caml_delay" [@@noalloc]

(** delay us : sleeps for this amount of microseconds. *)
external delay_usec : int -> unit = "caml_delay_usec" [@@noalloc]

(** millis () : gives the amount of milliseconds since launching the program/machine
    (detail is not important, only difference between two millis() is useful). *)
external millis : unit -> int = "caml_millis" [@@noalloc]

(************)
(* Printing *)
(************)

external print_string : string -> unit = "caml_numworks_print_string" [@@noalloc]
external print_newline : unit -> unit = "caml_numworks_print_newline" [@@noalloc]
external print_endline : string -> unit = "caml_numworks_print_endline" [@@noalloc]
external print_int : int -> unit = "caml_numworks_print_int" [@@noalloc]

let print_bool b =
  if b = true then print_string "true"
  else print_string "false"
;;

let print_char c = print_string (String.make 1 c);;
let print_float f = print_string (string_of_float f);;


(***********************************)
(* Functions from the EADK library *)
(***********************************)

let color_black : int = 0x0
let color_white : int = 0xFFFF
let color_red : int = 0xF800
let color_green : int = 0x07E0
let color_blue : int = 0x001F

let screen_width = 320
let screen_height = 240

external display_draw_string : string -> int -> int -> unit = "caml_display_draw_string" [@@noalloc]
external display_draw_string_small : string -> int -> int -> unit = "caml_display_draw_string_small" [@@noalloc]
let display_draw_string_large = display_draw_string  (* an alias only *)

(* FIXME: it RESETs the calculator! *)
external display_draw_string_full : string -> int -> int -> bool -> int -> int -> unit = "caml_display_draw_string_full" [@@noalloc]

external display_push_allscreen_uniform : int -> unit = "caml_display_push_allscreen_uniform" [@@noalloc]

let clear_screen () = display_push_allscreen_uniform color_black;;


(*******************)
(* Storage library *)
(*******************)

external cat_any_file : string -> int = "caml_cat_any_file" [@@noalloc]
let cat_ocamlpy_file () =
  cat_any_file "ocaml.py"
;;

(* FIXME: this doesn't work YET. *)
external read_any_file : string -> string = "caml_read_any_file" [@@noalloc]
let read_ocamlpy_file () =
  read_any_file "ocaml.py"
;;
