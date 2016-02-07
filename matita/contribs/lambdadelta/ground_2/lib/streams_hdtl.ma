(**************************************************************************)
(*       ___                                                              *)
(*      ||M||                                                             *)
(*      ||A||       A project by Andrea Asperti                           *)
(*      ||T||                                                             *)
(*      ||I||       Developers:                                           *)
(*      ||T||         The HELM team.                                      *)
(*      ||A||         http://helm.cs.unibo.it                             *)
(*      \   /                                                             *)
(*       \ /        This file is distributed under the terms of the       *)
(*        v         GNU General Public License Version 2                  *)
(*                                                                        *)
(**************************************************************************)

include "ground_2/lib/streams.ma".
include "ground_2/lib/arith.ma".

(* STREAMS ******************************************************************)

definition hd (A:Type[0]): stream A → A ≝
              λt. match t with [ seq a _ ⇒ a ].

definition tl (A:Type[0]): stream A → stream A ≝
              λt. match t with [ seq _ t ⇒ t ].

let rec tln (A:Type[0]) (i:nat) on i: stream A → stream A ≝ ?.
cases i -i [ #t @t | #i * #_ #t @(tln … i t) ]
qed.

(* basic properties *********************************************************)

lemma eq_stream_split (A) (t): (hd … t) @ (tl … t) ≐⦋A⦌ t.
#A * //
qed.

lemma tln_eq_repl (A) (i): eq_stream_repl A (λt1,t2. tln … i t1 ≐ tln … i t2).
#A #i elim i -i //
#i #IH * #n1 #t1 * #n2 #t2 #H elim (eq_stream_inv_seq ????? H) -H
/2 width=1 by/
qed.
