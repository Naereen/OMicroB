# 1 "lib/mmllexer.mll"
 

  open Lexing
  open Mmlparser

  exception Lexing_error of string   

  let keyword_or_ident =
    let h = Hashtbl.create 22 in
    List.iter (fun (s, k) -> Hashtbl.add h s k)
      [ "true" , TRUE ;
      "false" , FALSE ;
      "fun" , FUN ;
      "let" , LET ; 
      "rec" , REC ;
      "in" , IN;
      "if", IF;
      "then", THEN;
      "else", ELSE;
      "mod", MOD;
      "not", NOT;
      "type", TYPE;
      "int", INT;
      "bool", BOOL;
      "unit", UNIT;
      "mutable",MUTABLE ;
      "for", FOR ;
      "to", TO ;
      "do", DO ;
      "done", DONE ;
      "while", WHILE ;] ;
    fun s ->
      try  Hashtbl.find h s
      with Not_found -> IDENT(s)
        

# 39 "lib/mmllexer.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base =
   "\000\000\229\255\230\255\233\255\234\255\235\255\236\255\237\255\
    \238\255\002\000\001\000\017\000\002\000\246\255\002\000\004\000\
    \249\255\250\255\079\000\018\000\002\000\002\000\255\255\253\255\
    \245\255\231\255\244\255\232\255\242\255\241\255\240\255\037\000\
    \252\255\253\255\034\000\039\000\255\255\254\255";
  Lexing.lex_backtrk =
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\025\000\025\000\012\000\025\000\255\255\008\000\007\000\
    \255\255\255\255\004\000\003\000\016\000\001\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\002\000\002\000\255\255\255\255";
  Lexing.lex_default =
   "\002\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\255\255\255\255\255\255\255\255\000\000\255\255\255\255\
    \000\000\000\000\255\255\255\255\255\255\255\255\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\033\000\
    \000\000\000\000\255\255\255\255\000\000\000\000";
  Lexing.lex_trans =
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\021\000\022\000\021\000\000\000\021\000\000\000\021\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \021\000\012\000\021\000\000\000\000\000\000\000\010\000\029\000\
    \020\000\008\000\016\000\017\000\023\000\014\000\003\000\013\000\
    \019\000\019\000\019\000\019\000\019\000\019\000\019\000\019\000\
    \019\000\019\000\004\000\005\000\011\000\015\000\027\000\026\000\
    \025\000\024\000\019\000\019\000\019\000\019\000\019\000\019\000\
    \019\000\019\000\019\000\019\000\037\000\034\000\028\000\035\000\
    \036\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\018\000\
    \000\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\018\000\007\000\009\000\006\000\030\000\018\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\000\000\000\000\000\000\000\000\018\000\000\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\032\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    ";
  Lexing.lex_check =
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\021\000\255\255\000\000\255\255\021\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\000\000\021\000\255\255\255\255\255\255\000\000\010\000\
    \000\000\000\000\000\000\000\000\020\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\011\000\012\000\
    \014\000\015\000\019\000\019\000\019\000\019\000\019\000\019\000\
    \019\000\019\000\019\000\019\000\034\000\031\000\011\000\031\000\
    \035\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\000\000\
    \255\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\009\000\018\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\255\255\255\255\255\255\255\255\018\000\255\255\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\018\000\018\000\018\000\018\000\018\000\018\000\
    \018\000\018\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\031\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    ";
  Lexing.lex_base_code =
   "";
  Lexing.lex_backtrk_code =
   "";
  Lexing.lex_default_code =
   "";
  Lexing.lex_trans_code =
   "";
  Lexing.lex_check_code =
   "";
  Lexing.lex_code =
   "";
}

let rec token lexbuf =
   __ocaml_lex_token_rec lexbuf 0
and __ocaml_lex_token_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 44 "lib/mmllexer.mll"
             ( new_line lexbuf; token lexbuf )
# 168 "lib/mmllexer.ml"

  | 1 ->
# 45 "lib/mmllexer.mll"
                     ( token lexbuf )
# 173 "lib/mmllexer.ml"

  | 2 ->
# 46 "lib/mmllexer.mll"
           ( comment lexbuf; token lexbuf )
# 178 "lib/mmllexer.ml"

  | 3 ->
let
# 47 "lib/mmllexer.mll"
              n
# 184 "lib/mmllexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 47 "lib/mmllexer.mll"
                  ( CST(int_of_string n) )
# 188 "lib/mmllexer.ml"

  | 4 ->
let
# 48 "lib/mmllexer.mll"
             id
# 194 "lib/mmllexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 48 "lib/mmllexer.mll"
                (keyword_or_ident id)
# 198 "lib/mmllexer.ml"

  | 5 ->
# 49 "lib/mmllexer.mll"
        ( PLUS )
# 203 "lib/mmllexer.ml"

  | 6 ->
# 50 "lib/mmllexer.mll"
        ( STAR )
# 208 "lib/mmllexer.ml"

  | 7 ->
# 51 "lib/mmllexer.mll"
        (EQUAL)
# 213 "lib/mmllexer.ml"

  | 8 ->
# 52 "lib/mmllexer.mll"
        (MINUS)
# 218 "lib/mmllexer.ml"

  | 9 ->
# 53 "lib/mmllexer.mll"
        (DIV)
# 223 "lib/mmllexer.ml"

  | 10 ->
# 54 "lib/mmllexer.mll"
         (BOOL_EQUAL)
# 228 "lib/mmllexer.ml"

  | 11 ->
# 55 "lib/mmllexer.mll"
         (DIFF)
# 233 "lib/mmllexer.ml"

  | 12 ->
# 56 "lib/mmllexer.mll"
        (INF)
# 238 "lib/mmllexer.ml"

  | 13 ->
# 57 "lib/mmllexer.mll"
         (INF_OR_EQ)
# 243 "lib/mmllexer.ml"

  | 14 ->
# 58 "lib/mmllexer.mll"
         (AND)
# 248 "lib/mmllexer.ml"

  | 15 ->
# 59 "lib/mmllexer.mll"
         (OR)
# 253 "lib/mmllexer.ml"

  | 16 ->
# 60 "lib/mmllexer.mll"
        (LPAR)
# 258 "lib/mmllexer.ml"

  | 17 ->
# 61 "lib/mmllexer.mll"
        (RPAR)
# 263 "lib/mmllexer.ml"

  | 18 ->
# 62 "lib/mmllexer.mll"
        (LBRACKET)
# 268 "lib/mmllexer.ml"

  | 19 ->
# 63 "lib/mmllexer.mll"
        (RBRACKET)
# 273 "lib/mmllexer.ml"

  | 20 ->
# 64 "lib/mmllexer.mll"
        (SEMICOLON)
# 278 "lib/mmllexer.ml"

  | 21 ->
# 65 "lib/mmllexer.mll"
        (COLON)
# 283 "lib/mmllexer.ml"

  | 22 ->
# 66 "lib/mmllexer.mll"
        (POINT)
# 288 "lib/mmllexer.ml"

  | 23 ->
# 67 "lib/mmllexer.mll"
         (LARROW)
# 293 "lib/mmllexer.ml"

  | 24 ->
# 68 "lib/mmllexer.mll"
         (RARROW)
# 298 "lib/mmllexer.ml"

  | 25 ->
# 69 "lib/mmllexer.mll"
      ( raise (Lexing_error ("unknown character : " ^ (lexeme lexbuf))) )
# 303 "lib/mmllexer.ml"

  | 26 ->
# 70 "lib/mmllexer.mll"
        ( EOF )
# 308 "lib/mmllexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_token_rec lexbuf __ocaml_lex_state

and comment lexbuf =
   __ocaml_lex_comment_rec lexbuf 31
and __ocaml_lex_comment_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 74 "lib/mmllexer.mll"
      ( () )
# 320 "lib/mmllexer.ml"

  | 1 ->
# 76 "lib/mmllexer.mll"
      ( comment lexbuf; comment lexbuf )
# 325 "lib/mmllexer.ml"

  | 2 ->
# 78 "lib/mmllexer.mll"
      ( comment lexbuf )
# 330 "lib/mmllexer.ml"

  | 3 ->
# 80 "lib/mmllexer.mll"
      ( raise (Lexing_error "unterminated comment") )
# 335 "lib/mmllexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf;
      __ocaml_lex_comment_rec lexbuf __ocaml_lex_state

;;

