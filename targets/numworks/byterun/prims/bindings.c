/******************************************************************************/
/******************************************************************************/
/******************************************************************************/

#ifdef __OCAML__
#include <caml/alloc.h>
// FIXME: other headers are supported?
// See https://ocaml.org/docs/compiler-backend#embedding-native-code-in-c
// #include <caml/mlvalues.h>
// #include <caml/memory.h>
// #include <caml/callback.h>
#endif

#if defined(__OCAML__) || defined(__PC__) || defined(__NUMWORKS__)

#include "prims.h"

value caml_numworks_print_string(value s) {
  #ifdef __OCAML__
  printf("%s", String_val(s));
  #else
  int n = caml_string_length(s); int i;
  char buf[n+1];
  for(i = 0; i < n; i++) buf[i] = String_field(s, i);
  buf[n] = '\0';
  printf("%s", buf);
  #endif
  return Val_unit;
}

value caml_numworks_print_newline(value s) {
  // TODO: find out how to print a real newline: \n didn't work, so maybe \r\n would work?
  printf("\r\n");
  return Val_unit;
}

value caml_numworks_print_endline(value s) {
  #ifdef __OCAML__
  printf("%s\r\n", String_val(s));
  #else
  int n = caml_string_length(s); int i;
  char buf[n+1];
  for(i = 0; i < n; i++) buf[i] = String_field(s, i);
  buf[n] = '\0';
  printf("%s\r\n", buf);
  #endif
  return Val_unit;
}

value caml_numworks_print_int(value i) {
  printf("%d", (int)Int_val(i));
  return Val_unit;
}

// FIXME: Char_val doesn't exist...
// value caml_numworks_print_char(value c) {
//   printf("%c", (char)Char_val(c));
//   return Val_unit;
// }

// FIXME: Double_val does exist but it doesn't compile correctly?
// value caml_numworks_print_float(value f) {
//   printf("%f", (double)Double_val(f));
//   return Val_unit;
// }

value caml_delay_usec(value us) {
  delay_usec(Val_int(us));
  return Val_unit;
}

/******************************************************************************/
/******************************* EADK library *********************************/
/******************************************************************************/

// TODO: write here some useful functions written as bindings for the eadh.k library

value caml_display_draw_string(value text, value x, value y) {
  #ifdef __OCAML__
  display_draw_string(String_val(text), Int_val(x), Int_val(y));
  #else
  int n = caml_string_length(text); int i;
  char buf[n+1];
  for(i = 0; i < n; i++) buf[i] = String_field(text, i);
  buf[n] = '\0';
  display_draw_string(buf, Int_val(x), Int_val(y));
  #endif
  return Val_unit;
}

#endif
