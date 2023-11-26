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

include "delayed_updating/syntax/path_structure_inner.ma".
include "delayed_updating/syntax/preterm_structure.ma".

(* PRETERM ******************************************************************)

(* Descrtructions with pic **************************************************)

lemma term_root_pic_sn (t) (p1) (p2):
      t ϵ 𝐓 → p1 ϵ 𝐈 → p1 ϵ ▵t → p2 ϵ ▵t → ⊗p1 = ⊗p2 →
      ∃∃q1. p2 = p1●q1 & 𝐞 = ⊗q1.
#t #p1 #p2 #Ht #H1p1 #H2p1 #Hp2 #Hp
elim (term_root_eq_des_structure_bi … Ht … Hp) -Hp // -t
* #q2 #H0 #H1q2 destruct
lapply (pic_des_append_sn … H1p1) -H1p1 #H2q2
lapply (eq_inv_empty_structure_inner … H1q2) -H1q2 // -H2q2 #H0 destruct
/2 width=3 by ex2_intro/
qed-.
