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

include "basic_2/rt_transition/cpr_tdeq.ma".
include "basic_2/rt_computation/cnuw_simple.ma".
include "basic_2/rt_computation/cnuw_drops.ma".
include "basic_2/rt_computation/cnuw_cnuw.ma".

(* NORMAL TERMS FOR T-UNUNBOUND WHD RT-TRANSITION ***************************)

(* Properties with context-free sort-irrelevant equivalence for terms *******)

lemma cnuw_dec_tdeq (h) (G) (L):
      ∀T1. ∨∨ ⦃G,L⦄ ⊢ ➡𝐍𝐖*[h] T1
            | ∃∃n,T2. ⦃G,L⦄ ⊢ T1 ➡[n,h] T2 & (T1 ≛ T2 → ⊥).
#h #G #L #T1 elim T1 -T1 *
[ #s /3 width=5 by cnuw_sort, or_introl/
| #i elim (drops_F_uni L i)
  [ /3 width=7 by cnuw_atom_drops, or_introl/
  | * * [ #I | * #V ] #K #HLK
    [ /3 width=8 by cnuw_unit_drops, or_introl/
    | elim (lifts_total V 𝐔❴↑i❵) #W #HVW
      @or_intror @(ex2_2_intro … W) [1,2: /2 width=7 by cpm_delta_drops/ ] #H
      lapply (tdeq_inv_lref1 … H) -H #H destruct
      /2 width=5 by lifts_inv_lref2_uni_lt/
    | elim (lifts_total V 𝐔❴↑i❵) #W #HVW
      @or_intror @(ex2_2_intro … W) [1,2: /2 width=7 by cpm_ell_drops/ ] #H
      lapply (tdeq_inv_lref1 … H) -H #H destruct
      /2 width=5 by lifts_inv_lref2_uni_lt/
    ]
  ]
| #l /3 width=5 by cnuw_gref, or_introl/
| #p * [ cases p ] #V1 #T1 #_ #_
  [ elim (cpr_subst h G (L.ⓓV1) T1 0 L V1) [| /2 width=1 by drops_refl/ ] #T2 #X2 #HT12 #HXT2
    elim (tdeq_dec T1 T2) [ -HT12 #HT12 | #HnT12 ]
    [ elim (tdeq_inv_lifts_dx … HT12 … HXT2) -T2 #X1 #HXT1 #_ -X2
      @or_intror @(ex2_2_intro … X1) [1,2: /2 width=4 by cpm_zeta/ ] #H
      /2 width=7 by tdeq_lifts_inv_pair_sn/
    | @or_intror @(ex2_2_intro … (+ⓓV1.T2)) [1,2: /2 width=2 by cpm_bind/ ] #H
      elim (tdeq_inv_pair … H) -H /2 width=1 by/
    ]
  | /3 width=5 by cnuw_abbr_neg, or_introl/
  | /3 width=5 by cnuw_abst, or_introl/
  ]
| * #V1 #T1 #_ #IH
  [ elim (simple_dec_ex T1) [ #HT1 | * #p * #W1 #U1 #H destruct ]
    [ elim IH -IH
      [ /3 width=6 by cnuw_appl_simple, or_introl/
      | * #n #T2 #HT12 #HnT12
        @or_intror @(ex2_2_intro … n (ⓐV1.T2)) [ /2 width=1 by cpm_appl/ ] #H
        elim (tdeq_inv_pair … H) -H #_ #_ /2 width=1 by/
      ]
    | elim (lifts_total V1 𝐔❴1❵) #X1 #HVX1
      @or_intror @(ex2_2_intro … (ⓓ{p}W1.ⓐX1.U1)) [1,2: /2 width=3 by cpm_theta/ ] #H
      elim (tdeq_inv_pair … H) -H #H destruct
    | @or_intror @(ex2_2_intro … (ⓓ{p}ⓝW1.V1.U1)) [1,2: /2 width=2 by cpm_beta/ ] #H
      elim (tdeq_inv_pair … H) -H #H destruct
    ]
  | @or_intror @(ex2_2_intro … T1) [1,2: /2 width=2 by cpm_eps/ ] #H
    /2 width=4 by tdeq_inv_pair_xy_y/
  ]
]
qed-.
