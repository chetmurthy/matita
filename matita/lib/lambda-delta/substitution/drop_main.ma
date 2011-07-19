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

include "lambda-delta/substitution/drop_defs.ma".

(* DROPPING *****************************************************************)

(* the main properties ******************************************************)

lemma drop_conf_ge: ∀d1,e1,L,L1. ↑[d1, e1] L1 ≡ L →
                    ∀e2,L2. ↑[0, e2] L2 ≡ L → d1 + e1 ≤ e2 →
                    ↑[0, e2 - e1] L2 ≡ L1.
#d1 #e1 #L #L1 #H elim H -H d1 e1 L L1
[ //
| #L #K #I #V #e #_ #IHLK #e2 #L2 #H #He2
  lapply (drop_inv_drop1 … H ?) -H /2/ #HL2
  <minus_plus_comm /3/
| #L #K #I #V1 #V2 #d #e #_ #_ #IHLK #e2 #L2 #H #Hdee2
  lapply (transitive_le 1 … Hdee2) // #He2
  lapply (drop_inv_drop1 … H ?) -H // -He2 #HL2
  lapply (transitive_le (1+e) … Hdee2) // #Hee2
  >(plus_minus_m_m (e2-e) 1 ?) [ @drop_drop >minus_minus_comm /3/ | /2/ ]
]
qed.

axiom drop_conf_lt: ∀d1,e1,L,L1. ↑[d1, e1] L1 ≡ L →
                    ∀e2,K2,I,V2. ↑[0, e2] K2. 𝕓{I} V2 ≡ L →
                    e2 < d1 → let d ≝ d1 - e2 - 1 in
                    ∃∃K1,V1. ↑[0, e2] K1. 𝕓{I} V1 ≡ L1 & 
                             ↑[d, e1] K1 ≡ K2 & ↑[d,e1] V1 ≡ V2.

axiom drop_trans_le: ∀d1,e1,L1. ∀L:lenv. ↑[d1, e1] L ≡ L1 →
                     ∀e2,L2. ↑[0, e2] L2 ≡ L → e2 ≤ d1 →
                     ∃∃L0. ↑[0, e2] L0 ≡ L1 & ↑[d1 - e2, e1] L2 ≡ L0.

axiom drop_trans_ge: ∀d1,e1,L1,L. ↑[d1, e1] L ≡ L1 →
                     ∀e2,L2. ↑[0, e2] L2 ≡ L → d1 ≤ e2 → ↑[0, e1 + e2] L2 ≡ L1.
