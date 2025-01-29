(************************************************************************)
(*         *      The Rocq Prover / The Rocq Development Team           *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

(*s Production of Rust syntax. *)

open Names
open Miniml

(* https://doc.rust-lang.org/reference/keywords.html *)
let keywords = List.fold_right (fun s -> Id.Set.add (Id.of_string s)) [

  (* Strict keywords: *)
  "as";
  "async";
  "await";
  "break";
  "const";
  "continue";
  "crate";
  "dyn";
  "else";
  "enum";
  "extern";
  "false";
  "fn";
  "for";
  "if";
  "impl";
  "in";
  "let";
  "loop";
  "match";
  "mod";
  "move";
  "mut";
  "pub";
  "ref";
  "return";
  "self";
  "Self";
  "static";
  "struct";
  "super";
  "trait";
  "true";
  "type";
  "unsafe";
  "use";
  "where";
  "while";

  (* Reserved keywords: *)
  "abstract";
  "become";
  "box";
  "do";
  "final";
  "macro";
  "override";
  "priv";
  "try";
  "typeof";
  "unsized";
  "virtual";
  "yield";

  (* Weak keywords: *)
  (* "'static"; *)
  "macro_rules";
  "union"

] Id.Set.empty

let preamble mod_name comment used_modules usf = assert false

let pp_struct = assert false

let pp_decl = assert false

let rust_descr = {
  keywords = keywords;
  file_suffix = ".rs";
  file_naming = assert false;
  preamble = preamble;
  pp_struct = pp_struct;
  sig_suffix = None;
  sig_preamble = assert false;
  pp_sig = assert false;
  pp_decl = pp_decl;
}
