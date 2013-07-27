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

include "basic_2/reduction/lpr_lpr.ma".
include "basic_2/computation/cprs_lift.ma".

(* CONTEXT-SENSITIVE PARALLEL COMPUTATION ON TERMS **************************)

(* Main properties **********************************************************)

(* Basic_1: was: pr3_t *)
(* Basic_1: includes: pr1_t *)
theorem cprs_trans: ∀L. Transitive … (cprs L).
#L #T1 #T #HT1 #T2 @trans_TC @HT1 qed-. (**) (* auto /3 width=3/ does not work because a δ-expansion gets in the way *)

(* Basic_1: was: pr3_confluence *)
(* Basic_1: includes: pr1_confluence *)
theorem cprs_conf: ∀L. confluent2 … (cprs L) (cprs L).
#L @TC_confluent2 /2 width=3 by cpr_conf/ qed-. (**) (* auto /3 width=3/ does not work because a δ-expansion gets in the way *)

theorem cprs_bind: ∀a,I,L,V1,V2,T1,T2. L. ⓑ{I}V1 ⊢ T1 ➡* T2 → L ⊢ V1 ➡* V2 →
                   L ⊢ ⓑ{a,I}V1. T1 ➡* ⓑ{a,I}V2. T2.
#a #I #L #V1 #V2 #T1 #T2 #HT12 #H @(cprs_ind … H) -V2 /2 width=1/
#V #V2 #_ #HV2 #IHV1
@(cprs_trans … IHV1) -V1 /2 width=1/
qed.

(* Basic_1: was: pr3_flat *)
theorem cprs_flat: ∀I,L,V1,V2,T1,T2. L ⊢ T1 ➡* T2 → L ⊢ V1 ➡* V2 →
                   L ⊢ ⓕ{I} V1. T1 ➡* ⓕ{I} V2. T2.
#I #L #V1 #V2 #T1 #T2 #HT12 #H @(cprs_ind … H) -V2 /2 width=1/
#V #V2 #_ #HV2 #IHV1
@(cprs_trans … IHV1) -IHV1 /2 width=1/
qed.

theorem cprs_beta_rc: ∀a,L,V1,V2,W1,W2,T1,T2.
                      L ⊢ V1 ➡ V2 → L.ⓛW1 ⊢ T1 ➡* T2 → L ⊢ W1 ➡* W2 →
                      L ⊢ ⓐV1.ⓛ{a}W1.T1 ➡* ⓓ{a}ⓝW2.V2.T2.
#a #L #V1 #V2 #W1 #W2 #T1 #T2 #HV12 #HT12 #H @(cprs_ind … H) -W2 /2 width=1/
#W #W2 #_ #HW2 #IHW1
@(cprs_trans … IHW1) -IHW1 /3 width=1/
qed.

theorem cprs_beta: ∀a,L,V1,V2,W1,W2,T1,T2.
                   L.ⓛW1 ⊢ T1 ➡* T2 → L ⊢ W1 ➡* W2 → L ⊢ V1 ➡* V2 →
                   L ⊢ ⓐV1.ⓛ{a}W1.T1 ➡* ⓓ{a}ⓝW2.V2.T2.
#a #L #V1 #V2 #W1 #W2 #T1 #T2 #HT12 #HW12 #H @(cprs_ind … H) -V2 /2 width=1/
#V #V2 #_ #HV2 #IHV1
@(cprs_trans … IHV1) -IHV1 /3 width=1/
qed.

theorem cprs_theta_rc: ∀a,L,V1,V,V2,W1,W2,T1,T2.
                       L ⊢ V1 ➡ V → ⇧[0, 1] V ≡ V2 → L.ⓓW1 ⊢ T1 ➡* T2 →
                       L ⊢ W1 ➡* W2 → L ⊢ ⓐV1.ⓓ{a}W1.T1 ➡* ⓓ{a}W2.ⓐV2.T2.
#a #L #V1 #V #V2 #W1 #W2 #T1 #T2 #HV1 #HV2 #HT12 #H elim H -W2 /2 width=3/
#W #W2 #_ #HW2 #IHW1
@(cprs_trans … IHW1) /2 width=1/
qed.

theorem cprs_theta: ∀a,L,V1,V,V2,W1,W2,T1,T2.
                    ⇧[0, 1] V ≡ V2 → L ⊢ W1 ➡* W2 → L.ⓓW1 ⊢ T1 ➡* T2 →
                    L ⊢ V1 ➡* V → L ⊢ ⓐV1.ⓓ{a}W1.T1 ➡* ⓓ{a}W2.ⓐV2.T2.
#a #L #V1 #V #V2 #W1 #W2 #T1 #T2 #HV2 #HW12 #HT12 #H @(TC_ind_dx … V1 H) -V1 /2 width=3/
#V1 #V0 #HV10 #_ #IHV0
@(cprs_trans … IHV0) /2 width=1/
qed.

(* Advanced inversion lemmas ************************************************)

(* Basic_1: was pr3_gen_appl *)
lemma cprs_inv_appl1: ∀L,V1,T1,U2. L ⊢ ⓐV1.T1 ➡* U2 →
                      ∨∨ ∃∃V2,T2.       L ⊢ V1 ➡* V2 & L ⊢ T1 ➡* T2 &
                                        U2 = ⓐV2. T2
                       | ∃∃a,W,T.       L ⊢ T1 ➡* ⓛ{a}W.T &
                                        L ⊢ ⓓ{a}ⓝW.V1.T ➡* U2
                       | ∃∃a,V0,V2,V,T. L ⊢ V1 ➡* V0 & ⇧[0,1] V0 ≡ V2 &
                                        L ⊢ T1 ➡* ⓓ{a}V.T &
                                        L ⊢ ⓓ{a}V.ⓐV2.T ➡* U2.
#L #V1 #T1 #U2 #H @(cprs_ind … H) -U2 [ /3 width=5/ ]
#U #U2 #_ #HU2 * *
[ #V0 #T0 #HV10 #HT10 #H destruct
  elim (cpr_inv_appl1 … HU2) -HU2 *
  [ #V2 #T2 #HV02 #HT02 #H destruct /4 width=5/
  | #a #V2 #W #W2 #T #T2 #HV02 #HW2 #HT2 #H1 #H2 destruct
    lapply (cprs_strap1 … HV10 … HV02) -V0 #HV12
    lapply (lsubr_cpr_trans … HT2 (L.ⓓⓝW.V1) ?) -HT2 /2 width=1/ #HT2
    @or3_intro1 @(ex2_3_intro … HT10) -HT10 /3 width=1/ (**) (* explicit constructor. /5 width=8/ is too slow because TC_transitive gets in the way *)
  | #a #V #V2 #W0 #W2 #T #T2 #HV0 #HV2 #HW02 #HT2 #H1 #H2 destruct
    @or3_intro2 @(ex4_5_intro … HV2 HT10) /2 width=3/ /3 width=1/ (**) (* explicit constructor. /5 width=8/ is too slow because TC_transitive gets in the way *)
  ]
| /4 width=9/
| /4 width=11/
]
qed-.

(* Properties concerning sn parallel reduction on local environments ********)

(* Basic_1: was just: pr3_pr2_pr2_t *)
(* Basic_1: includes: pr3_pr0_pr2_t *)
lemma lpr_cpr_trans: s_r_trans … cpr lpr.
#L2 #T1 #T2 #HT12 elim HT12 -L2 -T1 -T2
[ /2 width=3/
| #L2 #K2 #V0 #V2 #W2 #i #HLK2 #_ #HVW2 #IHV02 #L1 #HL12
  elim (lpr_ldrop_trans_O1 … HL12 … HLK2) -L2 #X #HLK1 #H
  elim (lpr_inv_pair2 … H) -H #K1 #V1 #HK12 #HV10 #H destruct
  lapply (IHV02 … HK12) -K2 #HV02
  lapply (cprs_strap2 … HV10 … HV02) -V0 /2 width=6/
| #a #I #L2 #V1 #V2 #T1 #T2 #_ #_ #IHV12 #IHT12 #L1 #HL12
  lapply (IHT12 (L1.ⓑ{I}V1) ?) -IHT12 /2 width=1/ /3 width=1/
|4,6: /3 width=1/
| #L2 #V2 #T1 #T #T2 #_ #HT2 #IHT1 #L1 #HL12
  lapply (IHT1 (L1.ⓓV2) ?) -IHT1 /2 width=1/ /2 width=3/
| #a #L2 #V1 #V2 #W1 #W2 #T1 #T2 #_ #_ #_ #IHV12 #IHW12 #IHT12 #L1 #HL12
  lapply (IHT12 (L1.ⓛW1) ?) -IHT12 /2 width=1/ /3 width=1/
| #a #L2 #V1 #V #V2 #W1 #W2 #T1 #T2 #_ #HV2 #_ #_ #IHV1 #IHW12 #IHT12 #L1 #HL12
  lapply (IHT12 (L1.ⓓW1) ?) -IHT12 /2 width=1/ /3 width=3/
]
qed-.

lemma cpr_bind2: ∀L,V1,V2. L ⊢ V1 ➡ V2 → ∀I,T1,T2. L. ⓑ{I}V2 ⊢ T1 ➡ T2 →
                 ∀a. L ⊢ ⓑ{a,I}V1. T1 ➡* ⓑ{a,I}V2. T2.
#L #V1 #V2 #HV12 #I #T1 #T2 #HT12
lapply (lpr_cpr_trans … HT12 (L.ⓑ{I}V1) ?) /2 width=1/
qed.

(* Advanced properties ******************************************************)

(* Basic_1: was only: pr3_pr2_pr3_t pr3_wcpr0_t *)
lemma lpr_cprs_trans: s_rs_trans … cpr lpr.
/3 width=5 by s_r_trans_TC1, lpr_cpr_trans/ qed-.

(* Basic_1: was: pr3_strip *)
(* Basic_1: includes: pr1_strip *)
lemma cprs_strip: ∀L. confluent2 … (cprs L) (cpr L).
#L @TC_strip1 /2 width=3 by cpr_conf/ qed-. (**) (* auto /3 width=3/ does not work because a δ-expansion gets in the way *)

lemma cprs_lpr_conf_dx: ∀L0,T0,T1. L0 ⊢ T0 ➡* T1 → ∀L1. L0 ⊢ ➡ L1 →
                        ∃∃T. L1 ⊢ T1 ➡* T & L1 ⊢ T0 ➡* T.
#L0 #T0 #T1 #H elim H -T1
[ #T1 #HT01 #L1 #HL01
  elim (lpr_cpr_conf_dx … HT01 … HL01) -L0 /3 width=3/
| #T #T1 #_ #HT1 #IHT0 #L1 #HL01
  elim (IHT0 … HL01) #T2 #HT2 #HT02
  elim (lpr_cpr_conf_dx … HT1 … HL01) -L0 #T3 #HT3 #HT13
  elim (cprs_strip … HT2 … HT3) -T #T #HT2 #HT3
  lapply (cprs_strap2 … HT13 … HT3) -T3
  lapply (cprs_strap1 … HT02 … HT2) -T2 /2 width=3/
]
qed-.

lemma cprs_lpr_conf_sn: ∀L0,T0,T1. L0 ⊢ T0 ➡* T1 → ∀L1. L0 ⊢ ➡ L1 →
                        ∃∃T. L0 ⊢ T1 ➡* T & L1 ⊢ T0 ➡* T.
#L0 #T0 #T1 #HT01 #L1 #HL01
elim (cprs_lpr_conf_dx … HT01 … HL01) -HT01 #T #HT1
lapply (lpr_cprs_trans … HT1 … HL01) -HT1 /2 width=3/
qed-.

lemma cprs_bind2_dx: ∀L,V1,V2. L ⊢ V1 ➡ V2 → ∀I,T1,T2. L. ⓑ{I}V2 ⊢ T1 ➡* T2 →
                     ∀a. L ⊢ ⓑ{a,I}V1. T1 ➡* ⓑ{a,I}V2. T2.
#L #V1 #V2 #HV12 #I #T1 #T2 #HT12
lapply (lpr_cprs_trans … HT12 (L.ⓑ{I}V1) ?) /2 width=1/
qed.
