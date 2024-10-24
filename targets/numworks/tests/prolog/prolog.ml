(** OCaml source code of https://github.com/Naereen/Tiny-Prolog-in-OCaml-OneFile
    Modified in 2024, in order to:
    - not use camlp4,
    - not depend on CLI Arguments, files and interactivity,
    - remove/inline dependencies on Genlex

    (C) 2020-2024 Lilian Besson
    MIT License, https://lbesson.mit-license.org/
*)

(* lib.ml *)
let do_list f = List.fold_left (fun a b -> f b) ()

(* List.iter *)
let rec in_list x =
  function | (* List.mem *) [] -> false | a :: q -> (a = x) || (in_list x q)

let rec filter l =
  function
  | (* List.filter *) [] -> []
  | (x, t) :: q -> if in_list x l then filter l q else (x, t) :: (filter l q)

let map = List.map

type term = | Var of string | Term of string * term list

type clause = { pos : term; neg : term list }

let rec print_terme =
  function
  | Var id -> id
  | Term (f, l) ->
      (match l with
       | [] -> f
       | t :: q ->
          f ^ "(" ^ (print_terme t) ^ (string_of_terme_list q) ^ ")"
      )
and string_of_terme_list l =
  match l with
  | [] -> ""
  | t :: q ->
    ", " ^ (print_terme t) ^ (string_of_terme_list q)

let print_clause cl =
  match cl.neg with
  | [] -> print_terme cl.pos
  | t :: q ->
      (* (print_terme cl.pos) ^ " <-- " ^ (print_terme t) ^ (string_of_terme_list q) *)
      (print_terme cl.pos) ^ " :- " ^ (print_terme t) ^ (string_of_terme_list q)

let lex = Mygenlex.make_lexer [ "<--"; ":-"; "("; ")"; ","; "." ]

let rec parse_term1 (__strm : _ Mystream.t) =
  match Mystream.peek __strm with
  | Some (Mygenlex.Ident f) ->
      (Mystream.junk __strm;
       (try parse_term2 f __strm
        with | Mystream.Failure -> raise (Mystream.Error "")))
  | _ -> raise Mystream.Failure
and parse_term2 f (__strm : _ Mystream.t) =
  match Mystream.peek __strm with
  | Some (Mygenlex.Kwd "(") ->
      (Mystream.junk __strm;
       let t1 =
         (try parse_term1 __strm
          with | Mystream.Failure -> raise (Mystream.Error "")) in
       let l =
         (try parse_term_list __strm
          with | Mystream.Failure -> raise (Mystream.Error ""))
       in
         (match Mystream.peek __strm with
          | Some (Mygenlex.Kwd ")") -> (Mystream.junk __strm; Term (f, (t1 :: l)))
          | _ -> raise (Mystream.Error "")))
  | _ -> (match f.[0] with | 'A' .. 'Z' -> Var f | _ -> Term (f, []))
and parse_term_list (__strm : _ Mystream.t) =
  match Mystream.peek __strm with
  | Some (Mygenlex.Kwd ",") ->
      (Mystream.junk __strm;
       let t1 =
         (try parse_term1 __strm
          with | Mystream.Failure -> raise (Mystream.Error "")) in
       let l =
         (try parse_term_list __strm
          with | Mystream.Failure -> raise (Mystream.Error ""))
       in t1 :: l)
  | _ -> []

let parse_goal1 (__strm : _ Mystream.t) =
  let t1 = parse_term1 __strm in
  let l =
    try parse_term_list __strm
    with | Mystream.Failure -> raise (Mystream.Error "")
  in t1 :: l

let parse_term s = parse_term1 (lex (Mystream.of_string s))

let parse_goal s = parse_goal1 (lex (Mystream.of_string s))

let rec parse_clause1 (__strm : _ Mystream.t) =
  let t = parse_term1 __strm
  in
    try parse_clause2 t __strm
    with | Mystream.Failure -> raise (Mystream.Error "")
and parse_clause2 t (__strm : _ Mystream.t) =
  match Mystream.peek __strm with
  | Some (Mygenlex.Kwd ".") -> (Mystream.junk __strm; { pos = t; neg = []; })
  | Some (Mygenlex.Kwd ":-") ->
      (Mystream.junk __strm;
       let t1 =
         (try parse_term1 __strm
          with | Mystream.Failure -> raise (Mystream.Error "")) in
       let l =
         (try parse_term_list __strm
          with | Mystream.Failure -> raise (Mystream.Error ""))
       in
         (match Mystream.peek __strm with
          | Some (Mygenlex.Kwd ".") ->
              (Mystream.junk __strm; { pos = t; neg = t1 :: l; })
          | _ -> raise (Mystream.Error "")))
  | Some (Mygenlex.Kwd "<--") ->
      (Mystream.junk __strm;
       let t1 =
         (try parse_term1 __strm
          with | Mystream.Failure -> raise (Mystream.Error "")) in
       let l =
         (try parse_term_list __strm
          with | Mystream.Failure -> raise (Mystream.Error ""))
       in
         (match Mystream.peek __strm with
          | Some (Mygenlex.Kwd ".") ->
              (Mystream.junk __strm; { pos = t; neg = t1 :: l; })
          | _ -> raise (Mystream.Error "")))
  | _ -> raise Mystream.Failure

let parse_clause s = parse_clause1 (lex (Mystream.of_string s))

let print_subst l =
  let rec aux =
    function
    | [] -> ""
    | (x, t) :: q ->
      ",  " ^ x ^ " = " ^ (print_terme t) ^ (aux q)
  in
    match l with
    | [] -> "{ }"
    | (x, t) :: q ->
      "{ " ^ x ^ " = " ^ (print_terme t) ^ (aux q) ^ " }"

let rec parse_prog_parser acc (__strm : _ Mystream.t) =
  match try Some (parse_clause1 __strm) with | Mystream.Failure -> None with
  | Some cl ->
      let res =
        (try parse_prog_parser acc __strm
         with | Mystream.Failure -> raise (Mystream.Error ""))
      in cl :: res
  | _ -> acc

(* let input_line _ = "FIXME: input_channel not implemented"

let rec read_all_lines_rec acc filter input_channel =
  try
    let line = input_line input_channel
    in
      if filter line
      then read_all_lines_rec (line :: acc) filter input_channel
      else read_all_lines_rec acc filter input_channel
  with | End_of_file -> acc

let read_all_lines filter input_channel =
  read_all_lines_rec [] filter input_channel *)

let is_not_comment s = not (String.contains s '#' || s = "")
let filter_out_comments list_of_strings =
  List.filter is_not_comment list_of_strings

(* let parse_prog acc f =
  let file = open_in f in
  (* let flx = Mystream.of_channel file in
  parse_prog_parser acc (lex flx) *)
  (* hack to open the file, read, remove lines starting with #? *)
  let lines = read_all_lines is_not_comment file in
  let one_huge_line = ref ""
  in
    (List.iter (fun line -> one_huge_line := !one_huge_line ^ line) lines;
     let flx3 = Mystream.of_string !one_huge_line
     in parse_prog_parser acc (lex flx3))

let parse_progs lis = List.fold_left parse_prog [] lis *)

let parse_string acc str =
  (* TODO: when there are comments, everything fails, so we remove them later in the main program *)
  let flx4 = Mystream.of_string str in
  parse_prog_parser acc (lex flx4)

let parse_strings strs = List.fold_left parse_string [] strs

let fresh num cl =
  let rec aux =
    function
    | Var x -> Var
      (x ^ "_" ^ (string_of_int num))
    | Term (f, l) -> Term (f, (map aux l))
  in { pos = aux cl.pos; neg = map aux cl.neg; }

(* FIXME: fake implementation of the read_line () utility. *)
let read_line () = "y"

let rec yes_or_no mess =
  (print_string mess;
   print_string " (y/n) [y] : ";
   match read_line () with
   | "y" -> true
   | "o" -> true
   | "" -> true
   | "n" -> false
   | _ -> (print_string "\n"; yes_or_no mess))

let display_subst s =
  print_string "  ";
  print_endline (print_subst s)

let eadk_display_subst ?(delta_y = 0) s =
  display_draw_string ("Answer:  " ^ (print_subst s)) 0 delta_y


(* resolution.ml *)
let rec subst x t trm =
  match trm with
  | Var p -> if p = x then t else trm
  | Term (f, l) -> Term (f, (map (subst x t) l))

let rec app_subst l trm =
  match l with | [] -> trm | (x, t) :: q -> app_subst q (subst x t trm)

let subst_on_couple x t (p, trm) = (p, (subst x t trm))

let rec apply_subst_on_subst s1 s2 =
  match s1 with
  | [] -> s2
  | (x, t) :: q -> apply_subst_on_subst q (map (subst_on_couple x t) s2)

let vars_subst = map fst

let rec compose l1 l2 =
  (filter (vars_subst l2) l1) @ (apply_subst_on_subst l1 l2)

let rec occurence x =
  function | Var y -> x = y | Term (f, l) -> occurence_list x l
and occurence_list x =
  function | [] -> false | t :: q -> (occurence x t) || (occurence_list x q)

let rec unification t1 t2 =
  match (t1, t2) with
  | (Var x, Var y) -> if x = y then (true, []) else (true, [ (x, (Var y)) ])
  | (Var x, t) -> if occurence x t then (false, []) else (true, [ (x, t) ])
  | (t, Var x) -> if occurence x t then (false, []) else (true, [ (x, t) ])
  | (Term (f1, l1), Term (f2, l2)) ->
      if f1 = f2 then unification_list l1 l2 else (false, [])
and unification_list l1 l2 =
  match (l1, l2) with
  | ([], []) -> (true, [])
  | ([], _) -> (false, [])
  | (_, []) -> (false, [])
  | (t1 :: q1, t2 :: q2) ->
      let (b1, s1) = unification t1 t2
      in
        if b1
        then
          (let (b2, s2) =
             unification_list (map (app_subst s1) q1) (map (app_subst s1) q2)
           in if b2 then (true, (compose s2 s1)) else (false, []))
        else (false, [])

let rec search_clauses num prog trm =
  match prog with
  | [] -> []
  | cl :: q ->
      let fresh_cl = fresh num cl in
      let (b, s) = unification trm fresh_cl.pos
      in
        if b
        then (s, fresh_cl) :: (search_clauses num q trm)
        else search_clauses num q trm

let rec
  prove_goals_rec ?(delta_y = 0) ?(maxoutput = 10) ?(interactive = false) but num prog s =
  function
  | [] ->
      (eadk_display_subst ~delta_y:delta_y (List.filter (fun (v, _) -> occurence_list v but) s);
       if interactive
       then if not (yes_or_no "continue ?") then failwith "end" else ()
       else ();
       if maxoutput = 0 then failwith "end" else ())
  | trm :: q ->
      let ssButs = search_clauses num prog trm
      in
        do_list
          (fun (s2, cl) ->
             prove_goals_rec ~delta_y:(delta_y + 10) ~maxoutput: (maxoutput - 1)
               ~interactive: interactive but (num + 1) prog (compose s2 s)
               (map (app_subst s2) (cl.neg @ q)))
          ssButs

let prove_goals ?(delta_y = 0) ?(maxoutput = 10) ?(interactive = false) prog trm_list =
  try
    prove_goals_rec ~delta_y:delta_y ~maxoutput: maxoutput ~interactive: interactive trm_list
      0 prog [] trm_list
  with | Failure "end" -> ()


(* prolog.ml *)

let rec string_join_on c strings =
  match strings with
  | [] -> ""
  | [s0] -> s0
  | s0 :: s1sn ->
      s0 ^ c ^ (string_join_on c s1sn)
;;


(* DONE: this is now read from a "prolog_theory.py" file, from the local storage *)
let prolog_theory_content = read_any_file "prolog_theory.py"
let default_programs = ref [];;
if prolog_theory_content <> "" then
  default_programs := [ prolog_theory_content ]
else
  default_programs := [
"# Fichier Prolog, pas Python
# Une theorie : des faits.
# Cf. OMicroB OCaml Prolog
# Par Lilian Besson (Naereen)
cat(tom).
mouse(jerry).

fast(X) <-- mouse(X).
stupid(X) <-- cat(X).

ishuntedby(X, Y) <-- mouse(X), cat(Y)." ]
let default_programs = !default_programs

(* DONE: this is now read from a "prolog_questions.py" file, from the local storage *)
let prolog_questions_content = read_any_file "prolog_questions.py"
let default_questions = ref "";;
if prolog_questions_content <> "" then
  default_questions := prolog_questions_content
else
  default_questions :=
"# Fichier Prolog, pas Python
# Une liste de questions.
# Cf. OMicroB OCaml Prolog
# Par Lilian Besson (Naereen)
stupid(A).
fast(B).
ishuntedby(C, D)."
let default_questions = filter_out_comments (String.split_on_char '\n' !default_questions)

let numworks_main () =
  let long_delay = 1000 in
  let short_delay = 0 in
  let delta_y = 18 in
  delay short_delay;
  clear_screen ();
  delay short_delay;
  display_draw_string ("Loading " ^ (string_of_int (List.length default_programs)) ^ " theory content(s)...") 0 0;
  delay long_delay;
  List.iter (fun program_content ->
    clear_screen();
    delay short_delay;
    display_draw_string "1. Loading this theory:" 0 0;
    display_draw_string_small program_content 0 delta_y
    ) default_programs;
  delay long_delay;
  let default_programs = List.map (fun program_content -> string_join_on "\n" (filter_out_comments (String.split_on_char '\n' program_content))) default_programs in
  let prog = parse_strings default_programs in
  clear_screen ();
  delay short_delay;
  display_draw_string ("2. Loaded " ^ (string_of_int (List.length default_programs)) ^ " theory content(s) !") 0 0;
  display_draw_string ("Giving "^ (string_of_int (List.length prog)) ^ " fact(s) !") 0 delta_y;
  delay long_delay;

  List.iter (fun question ->
    clear_screen();
    delay short_delay;
    display_draw_string "3. Parsing this question..." 0 0;
    display_draw_string ("?- " ^ question) 0 delta_y;
    delay long_delay;
    let trm_list = parse_goal question in
    display_draw_string ("4. Parsed! " ^ (string_of_int (List.length trm_list)) ^ " term(s).") 0 (2*delta_y);
    display_draw_string "5. Now answering it:" 0 (3*delta_y);
    delay long_delay;
    prove_goals ~delta_y:(4*delta_y) ~interactive:false prog trm_list;
    delay long_delay;
    clear_screen ()
  ) default_questions

(* let interactive_main () =
  let nbarg = Array.length Sys.argv in
  let listargv = List.tl (Array.to_list Sys.argv)
  in
    if nbarg >= 2
    then
      if nbarg >= 3
      then
        (let rev_listargv = List.rev listargv in
         let progs = List.rev (List.tl rev_listargv)
         and fake_read_line = List.hd rev_listargv
         in
           (print_string ("?- " ^ fake_read_line ^ "\n");
            let prog = parse_progs progs in
            let trm_list = parse_goal fake_read_line
            in prove_goals ~interactive:false prog trm_list))
      else
        (let prog = parse_progs listargv
         in
           (print_string "?- ";
            let trm_list = parse_goal (read_line ())
            in prove_goals ~interactive:true prog trm_list))
    else () *)

(* TODO: add interactivity with keyboard input? I don't plan on doing it, it seems hard. *)
(* TODO: At least read the content of the "prolog.py" file, on the Numworks *)
let interactive_main = numworks_main ;;

let interactive = false ;;

let main () =
  if interactive then
    interactive_main ()
  else
    numworks_main ()
;;

main ();;
