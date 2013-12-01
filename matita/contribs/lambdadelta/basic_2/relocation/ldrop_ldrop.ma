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

include "basic_2/relocation/lift_lift.ma".
include "basic_2/relocation/ldrop.ma".

(* BASIC SLICING FOR LOCAL ENVIRONMENTS *************************************)

(* Main properties **********************************************************)

(* Basic_1: was: drop_mono *)
theorem ldrop_mono: ∀d,e,L,L1. ⇩[d, e] L ≡ L1 →
                    ∀L2. ⇩[d, e] L ≡ L2 → L1 = L2.
#d #e #L #L1 #H elim H -d -e -L -L1
[ #d #L2 #H elim (ldrop_inv_atom1 … H) -H //
| #K #I #V #L2 #HL12 <(ldrop_inv_O2 … HL12) -L2 //
| #L #K #I #V #e #_ #IHLK #L2 #H
  lapply (ldrop_inv_ldrop1 … H) -H /2 width=1 by/
| #L #K1 #I #T #V1 #d #e #_ #HVT1 #IHLK1 #X #H
  elim (ldrop_inv_skip1 … H) -H // <minus_plus_m_m #K2 #V2 #HLK2 #HVT2 #H destruct
  >(lift_inj … HVT1 … HVT2) -HVT1 -HVT2
  >(IHLK1 … HLK2) -IHLK1 -HLK2 //
]
qed-.

(* Basic_1: was: drop_conf_ge *)
theorem ldrop_conf_ge: ∀d1,e1,L,L1. ⇩[d1, e1] L ≡ L1 →
                       ∀e2,L2. ⇩[0, e2] L ≡ L2 → d1 + e1 ≤ e2 →
                       ⇩[0, e2 - e1] L1 ≡ L2.
#d1 #e1 #L #L1 #H elim H -d1 -e1 -L -L1 //
[ #L #K #I #V #e #_ #IHLK #e2 #L2 #H #He2
  lapply (ldrop_inv_ldrop1_lt … H ?) -H /2 width=2 by ltn_to_ltO/ #HL2
  <minus_plus >minus_minus_comm /3 width=1 by monotonic_pred/
| #L #K #I #V1 #V2 #d #e #_ #_ #IHLK #e2 #L2 #H #Hdee2
  lapply (transitive_le 1 … Hdee2) // #He2
  lapply (ldrop_inv_ldrop1_lt … H ?) -H // -He2 #HL2
  lapply (transitive_le (1 + e) … Hdee2) // #Hee2
  @ldrop_ldrop_lt >minus_minus_comm /3 width=1 by O, lt_minus_to_plus_r, monotonic_le_minus_r, monotonic_pred/ (**) (* explicit constructor *)
]
qed.

(* Note: apparently this was missing in basic_1 *)
theorem ldrop_conf_be: ∀L0,L1,d1,e1. ⇩[d1, e1] L0 ≡ L1 →
                       ∀L2,e2. ⇩[0, e2] L0 ≡ L2 → d1 ≤ e2 → e2 ≤ d1 + e1 →
                       ∃∃L. ⇩[0, d1 + e1 - e2] L2 ≡ L & ⇩[0, d1] L1 ≡ L.
#L0 #L1 #d1 #e1 #H elim H -L0 -L1 -d1 -e1
[ #d1 #L2 #e2 #H #Hd1 #_ elim (ldrop_inv_atom1 … H) -H #H1 #H2 destruct
  <(le_n_O_to_eq … Hd1) -d1 /2 width=3 by ldrop_atom, ex2_intro/
| normalize #L #I #V #L2 #e2 #HL2 #_ #He2
  lapply (le_n_O_to_eq … He2) -He2 #H destruct
  lapply (ldrop_inv_O2 … HL2) -HL2 #H destruct /2 width=3 by ldrop_pair, ex2_intro/
| normalize #L0 #K0 #I #V1 #e1 #HLK0 #IHLK0 #L2 #e2 #H #_ #He21
  lapply (ldrop_inv_O1_pair1 … H) -H * * #He2 #HL20
  [ -IHLK0 -He21 destruct <minus_n_O /3 width=3 by ldrop_ldrop, ex2_intro/
  | -HLK0 <minus_le_minus_minus_comm //
    elim (IHLK0 … HL20) -L0 /2 width=3 by monotonic_pred, ex2_intro/
  ]
| #L0 #K0 #I #V0 #V1 #d1 #e1 >plus_plus_comm_23 #_ #_ #IHLK0 #L2 #e2 #H #Hd1e2 #He2de1
  elim (le_inv_plus_l … Hd1e2) #_ #He2
  <minus_le_minus_minus_comm //
  lapply (ldrop_inv_ldrop1_lt … H ?) -H // #HL02
  elim (IHLK0 … HL02) -L0 /3 width=3 by ldrop_ldrop, monotonic_pred, ex2_intro/
]
qed.

(* Note: apparently this was missing in basic_1 *)
theorem ldrop_conf_le: ∀L0,L1,d1,e1. ⇩[d1, e1] L0 ≡ L1 →
                       ∀L2,e2. ⇩[0, e2] L0 ≡ L2 → e2 ≤ d1 →
                       ∃∃L. ⇩[0, e2] L1 ≡ L & ⇩[d1 - e2, e1] L2 ≡ L.
#L0 #L1 #d1 #e1 #H elim H -L0 -L1 -d1 -e1
[ #d1 #L2 #e2 #H
  elim (ldrop_inv_atom1 … H) -H #H destruct /2 width=3 by ldrop_atom, ex2_intro/
| #K0 #I #V0 #L2 #e2 #H1 #H2
  lapply (le_n_O_to_eq … H2) -H2 #H destruct
  lapply (ldrop_inv_pair1 … H1) -H1 #H destruct /2 width=3 by ldrop_pair, ex2_intro/
| #K0 #K1 #I #V0 #e1 #HK01 #_ #L2 #e2 #H1 #H2
  lapply (le_n_O_to_eq … H2) -H2 #H destruct
  lapply (ldrop_inv_pair1 … H1) -H1 #H destruct /3 width=3 by ldrop_ldrop, ex2_intro/
| #K0 #K1 #I #V0 #V1 #d1 #e1 #HK01 #HV10 #IHK01 #L2 #e2 #H #He2d1
  elim (ldrop_inv_O1_pair1 … H) -H *
  [ -IHK01 -He2d1 #H1 #H2 destruct /3 width=5 by ldrop_pair, ldrop_skip, ex2_intro/
  | -HK01 -HV10 #He2 #HK0L2
    elim (IHK01 … HK0L2) -IHK01 -HK0L2 /2 width=1 by monotonic_pred/
    >minus_le_minus_minus_comm /3 width=3 by ldrop_ldrop_lt, ex2_intro/
  ]
]
qed.

(* Basic_1: was: drop_trans_ge *)
theorem ldrop_trans_ge: ∀d1,e1,L1,L. ⇩[d1, e1] L1 ≡ L →
                        ∀e2,L2. ⇩[0, e2] L ≡ L2 → d1 ≤ e2 → ⇩[0, e1 + e2] L1 ≡ L2.
#d1 #e1 #L1 #L #H elim H -d1 -e1 -L1 -L //
[ /3 width=1/
| #L1 #L2 #I #V1 #V2 #d #e #H_ #_ #IHL12 #e2 #L #H #Hde2
  lapply (lt_to_le_to_lt 0 … Hde2) // #He2
  lapply (lt_to_le_to_lt … (e + e2) He2 ?) // #Hee2
  lapply (ldrop_inv_ldrop1_lt … H ?) -H // #HL2
  @ldrop_ldrop_lt // >le_plus_minus /3 width=1 by monotonic_pred/
]
qed.

(* Basic_1: was: drop_trans_le *)
theorem ldrop_trans_le: ∀d1,e1,L1,L. ⇩[d1, e1] L1 ≡ L →
                        ∀e2,L2. ⇩[0, e2] L ≡ L2 → e2 ≤ d1 →
                        ∃∃L0. ⇩[0, e2] L1 ≡ L0 & ⇩[d1 - e2, e1] L0 ≡ L2.
#d1 #e1 #L1 #L #H elim H -d1 -e1 -L1 -L
[ #d #e2 #L2 #H
  elim (ldrop_inv_atom1 … H) -H /2 width=3 by ldrop_atom, ex2_intro/
| #K #I #V #e2 #L2 #HL2 #H
  lapply (le_n_O_to_eq … H) -H #H destruct /2 width=3 by ldrop_pair, ex2_intro/
| #L1 #L2 #I #V #e #_ #IHL12 #e2 #L #HL2 #H
  lapply (le_n_O_to_eq … H) -H #H destruct
  elim (IHL12 … HL2) -IHL12 -HL2 // #L0 #H #HL0
  lapply (ldrop_inv_O2 … H) -H #H destruct /3 width=5 by ldrop_pair, ldrop_ldrop, ex2_intro/
| #L1 #L2 #I #V1 #V2 #d #e #HL12 #HV12 #IHL12 #e2 #L #H #He2d
  elim (ldrop_inv_O1_pair1 … H) -H *
  [ -He2d -IHL12 #H1 #H2 destruct /3 width=5 by ldrop_pair, ldrop_skip, ex2_intro/
  | -HL12 -HV12 #He2 #HL2
    elim (IHL12 … HL2) -L2 [ >minus_le_minus_minus_comm // /3 width=3 by ldrop_ldrop_lt, ex2_intro/ | /2 width=1 by monotonic_pred/ ]
  ]
]
qed.

(* Basic_1: was: drop_conf_rev *)
axiom ldrop_div: ∀e1,L1,L. ⇩[0, e1] L1 ≡ L → ∀e2,L2. ⇩[0, e2] L2 ≡ L →
                 ∃∃L0. ⇩[0, e1] L0 ≡ L2 & ⇩[e1, e2] L0 ≡ L1.

(* Advanced properties ******************************************************)

lemma l_liftable_llstar: ∀R. l_liftable R → ∀l. l_liftable (llstar … R l).
#R #HR #l #K #T1 #T2 #H @(lstar_ind_r … l T2 H) -l -T2
[ #L #d #e #_ #U1 #HTU1 #U2 #HTU2 -HR -K
  >(lift_mono … HTU2 … HTU1) -T1 -U2 -d -e //
| #l #T #T2 #_ #HT2 #IHT1 #L #d #e #HLK #U1 #HTU1 #U2 #HTU2
  elim (lift_total T d e) /3 width=11 by lstar_dx/
]
qed.

(* Basic_1: was: drop_conf_lt *)
lemma ldrop_conf_lt: ∀d1,e1,L,L1. ⇩[d1, e1] L ≡ L1 →
                     ∀e2,K2,I,V2. ⇩[0, e2] L ≡ K2. ⓑ{I} V2 →
                     e2 < d1 → let d ≝ d1 - e2 - 1 in
                     ∃∃K1,V1. ⇩[0, e2] L1 ≡ K1. ⓑ{I} V1 &
                              ⇩[d, e1] K2 ≡ K1 & ⇧[d, e1] V1 ≡ V2.
#d1 #e1 #L #L1 #H1 #e2 #K2 #I #V2 #H2 #He2d1
elim (ldrop_conf_le … H1 … H2) -L /2 width=2 by lt_to_le/ #K #HL1K #HK2
elim (ldrop_inv_skip1 … HK2) -HK2 /2 width=1 by lt_plus_to_minus_r/ #K1 #V1 #HK21 #HV12 #H destruct /2 width=5 by ex3_2_intro/
qed.

(* Note: apparently this was missing in basic_1 *)
lemma ldrop_trans_lt: ∀d1,e1,L1,L. ⇩[d1, e1] L1 ≡ L →
                      ∀e2,L2,I,V2. ⇩[0, e2] L ≡ L2.ⓑ{I}V2 →
                      e2 < d1 → let d ≝ d1 - e2 - 1 in
                      ∃∃L0,V0. ⇩[0, e2] L1 ≡ L0.ⓑ{I}V0 &
                               ⇩[d, e1] L0 ≡ L2 & ⇧[d, e1] V2 ≡ V0.
#d1 #e1 #L1 #L #HL1 #e2 #L2 #I #V2 #HL2 #Hd21
elim (ldrop_trans_le … HL1 … HL2) -L /2 width=1 by lt_to_le/ #L0 #HL10 #HL02
elim (ldrop_inv_skip2 … HL02) -HL02 /2 width=1 by lt_plus_to_minus_r/ #L #V1 #HL2 #HV21 #H destruct /2 width=5 by ex3_2_intro/
qed-.

lemma ldrop_trans_ge_comm: ∀d1,e1,e2,L1,L2,L.
                           ⇩[d1, e1] L1 ≡ L → ⇩[0, e2] L ≡ L2 → d1 ≤ e2 →
                           ⇩[0, e2 + e1] L1 ≡ L2.
#e1 #e1 #e2 >commutative_plus /2 width=5 by ldrop_trans_ge/
qed.

lemma ldrop_conf_div: ∀I1,L,K,V1,e1. ⇩[0, e1] L ≡ K. ⓑ{I1} V1 →
                      ∀I2,V2,e2. ⇩[0, e2] L ≡ K. ⓑ{I2} V2 →
                      ∧∧ e1 = e2 & I1 = I2 & V1 = V2.
#I1 #L #K #V1 #e1 #HLK1 #I2 #V2 #e2 #HLK2
elim (le_or_ge e1 e2) #He
[ lapply (ldrop_conf_ge … HLK1 … HLK2 ?)
| lapply (ldrop_conf_ge … HLK2 … HLK1 ?)
] -HLK1 -HLK2 // #HK
lapply (ldrop_fwd_length_minus2 … HK) #H
elim (discr_minus_x_xy … H) -H
[1,3: normalize <plus_n_Sm #H destruct ]
#H >H in HK; #HK
lapply (ldrop_inv_O2 … HK) -HK #H destruct
lapply (inv_eq_minus_O … H) -H /3 width=1 by le_to_le_to_eq, and3_intro/
qed-.

(* Advanced forward lemmas **************************************************)

lemma ldrop_fwd_be: ∀L,K,d,e,i. ⇩[d, e] L ≡ K → |K| ≤ i → i < d → |L| ≤ i.
#L #K #d #e #i #HLK #HK #Hd elim (lt_or_ge i (|L|)) //
#HL elim (ldrop_O1_lt … HL) #I #K0 #V #HLK0 -HL
elim (ldrop_conf_lt … HLK … HLK0) // -HLK -HLK0 -Hd
#K1 #V1 #HK1 #_ #_ lapply (ldrop_fwd_length_lt2 … HK1) -I -K1 -V1
#H elim (lt_refl_false i) /2 width=3 by lt_to_le_to_lt/
qed-.
