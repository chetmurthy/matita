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

include "delayed_updating/substitution/fsubst.ma".
include "delayed_updating/syntax/prototerm_ol.ma".
include "ground/lib/subset_or_le.ma".
include "ground/lib/subset_or_ol.ma".

(* FOCALIZED SUBSTITUTION ***************************************************)

(* Constructions with subset_eq *********************************************)
(*
lemma fsubst_pt_append_refl_sn (t) (p) (u):
      u ⇔ (p●t)[p⋔←u].
#t #p #u @conj #r [| * // * ]
[ /2 width=1 by fsubst_in_comp_true/
| * #s #_ #H1 #H0 destruct
  elim H0 -H0 //
]
qed.

lemma fsubst_empty_rc (t) (u):
      u ⇔ t[𝐞⋔←u].
#t #u @conj #p [| * // * ]
[ /2 width=1 by fsubst_in_comp_true/
| #H1p #H2p elim H2p -H2p //
]
qed.
*)
lemma fsubst_le_repl (t1) (t2) (u1) (u2) (v1) (v2):
      t1 ⊆ t2 → u1 ⇔ u2 → v1 ⊆ v2 → ⬕[u1←v1]t1 ⊆ ⬕[u2←v2]t2.
#t1 #t2 #u1 #u2 #v1 #v2 #Ht * #H1u #H2u #Hv #r * * #H1 #H2
/4 width=5 by subset_ol_le_repl, fsubst_in_comp_false, fsubst_in_comp_true/
qed.

lemma fsubst_eq_repl (t1) (t2) (u1) (u2) (v1) (v2):
      t1 ⇔ t2 → u1 ⇔ u2 → v1 ⇔ v2 → ⬕[u1←v1]t1 ⇔ ⬕[u2←v2]t2.
#t1 #t2 #u1 #u2 #v1 #v2 * #H1t #H2t #Hu * #H1v #H2v
/4 width=7 by conj, fsubst_le_repl, subset_eq_sym/
qed.

lemma fsubst_or (t1) (t2) (u) (v):
      (⬕[u←v]t1) ∪ (⬕[u←v]t2) ⇔ ⬕[u←v](t1 ∪ t2).
#t1 #t2 #u #v @conj
[ @subset_le_or_sn @fsubst_le_repl // (**) (* auto fails *)
| #r * * [ #H0 | * ]
  [ elim (subset_ol_or_inv_sn … H0) -H0 #H0 #Hu
    /3 width=1 by fsubst_in_comp_true, subset_or_in_dx, subset_or_in_sn/
  | /3 width=1 by fsubst_in_comp_false, subset_or_in_sn/
  | /3 width=1 by fsubst_in_comp_false, subset_or_in_dx/
  ]
]
qed.

lemma fsubst_append (t) (u) (v) (p):
      p●(⬕[u←v]t) ⇔ ⬕[p●u←p●v](p●t).
#t #u #v #p @conj #r * [| * | * ]
[ #s * * #H1 #H2 #H3 destruct
  [ /3 width=1 by fsubst_in_comp_true, term_ol_append_bi, pt_append_in/
  | /4 width=2 by fsubst_in_comp_false, append_in_comp_inv_bi, pt_append_in/
  ]
| #H0 #Hr
  /4 width=3 by fsubst_in_comp_true, term_ol_inv_append_bi, pt_append_le_repl/
| * #s #Hs #H1 #H0 destruct
  /5 width=1 by fsubst_in_comp_false, append_in_comp_inv_bi, pt_append_in/
]
qed.

lemma fsubst_lcons_neq (t) (u) (v) (l1) (l2):
      l1 ⧸= l2 → l1◗t ⇔ ⬕[l2◗u←v](l1◗t).
#t #u #v #l1 #l2 #Hl @conj #r *
[ #s #Hs #H1 destruct
  @fsubst_in_comp_false
  [ /2 width=1 by pt_append_in/
  | * #r #_ #H0
    elim (eq_inv_list_rcons_bi ????? H0) -H0 #_
    /2 width=1 by/
  ]
| * #H0 #_ elim Hl -Hl -v -r
  /2 width=3 by term_ol_des_lcons_bi/
| * #Hr #_ -u -v -l2 //
]
qed.
