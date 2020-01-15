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

include "static_2/syntax/tweq_teqx.ma".
include "basic_2/rt_computation/csx_cpxs.ma".
include "basic_2/rt_computation/cpms_cpxs.ma".
include "basic_2/rt_computation/cnuw_cnuw.ma".
include "basic_2/rt_computation/cpmuwe.ma".

(* T-UNBOUND WHD EVALUATION FOR T-BOUND RT-TRANSITION ON TERMS **************)

(* Properties with strong normalization for unbound rt-transition for terms *)

lemma cpmuwe_total_csx (h) (G) (L):
      ∀T1. ❪G,L❫ ⊢ ⬈*𝐒[h] T1 → ∃∃T2,n. ❪G,L❫ ⊢ T1 ➡*𝐍𝐖*[h,n] T2.
#h #G #L #T1 #H
@(csx_ind_cpxs … H) -T1 #T1 #_ #IHT1
elim (cnuw_dec_ex h G L T1)
[ -IHT1 #HT1 /3 width=4 by cpmuwe_intro, ex1_2_intro/
| * #n1 #T0 #HT10 #HnT10
  elim (IHT1 … T0) -IHT1
  [ #T2 #n2 * #HT02 #HT2 /4 width=5 by cpms_trans, cpmuwe_intro, ex1_2_intro/
  | /3 width=1 by teqx_tweq/
  | /2 width=2 by cpms_fwd_cpxs/
  ]
]
qed-.

lemma R_cpmuwe_total_csx (h) (G) (L):
      ∀T1. ❪G,L❫ ⊢ ⬈*𝐒[h] T1 → ∃n. R_cpmuwe h G L T1 n.
#h #G #L #T1 #H
elim (cpmuwe_total_csx … H) -H #T2 #n #HT12
/3 width=3 by ex_intro (* 2x *)/
qed-.
