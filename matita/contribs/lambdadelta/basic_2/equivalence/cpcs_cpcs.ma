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

include "basic_2/computation/lprs_cprs.ma".
include "basic_2/conversion/cpc_cpc.ma".
include "basic_2/equivalence/cpcs_cprs.ma".

(* CONTEXT-SENSITIVE PARALLEL EQUIVALENCE ON TERMS **************************)

(* Advanced inversion lemmas ************************************************)

lemma cpcs_inv_cprs: ∀L,T1,T2. L ⊢ T1 ⬌* T2 →
                     ∃∃T. L ⊢ T1 ➡* T & L ⊢ T2 ➡* T.
#L #T1 #T2 #H @(cpcs_ind … H) -T2
[ /3 width=3/
| #T #T2 #_ #HT2 * #T0 #HT10 elim HT2 -HT2 #HT2 #HT0
  [ elim (cprs_strip … HT0 … HT2) -T #T #HT0 #HT2
    lapply (cprs_strap1 … HT10 … HT0) -T0 /2 width=3/
  | lapply (cprs_strap2 … HT2 … HT0) -T /2 width=3/
  ]
]
qed-.

(* Basic_1: was: pc3_gen_sort *)
lemma cpcs_inv_sort: ∀L,k1,k2. L ⊢ ⋆k1 ⬌* ⋆k2 → k1 = k2.
#L #k1 #k2 #H
elim (cpcs_inv_cprs … H) -H #T #H1
>(cprs_inv_sort1 … H1) -T #H2
lapply (cprs_inv_sort1 … H2) -L #H destruct //
qed-.

lemma cpcs_inv_abst1: ∀a,L,W1,T1,T. L ⊢ ⓛ{a}W1.T1 ⬌* T →
                      ∃∃W2,T2. L ⊢ T ➡* ⓛ{a}W2.T2 & L ⊢ ⓛ{a}W1.T1 ➡* ⓛ{a}W2.T2.
#a #L #W1 #T1 #T #H
elim (cpcs_inv_cprs … H) -H #X #H1 #H2
elim (cprs_inv_abst1 … H1) -H1 #W2 #T2 #HW12 #HT12 #H destruct
@(ex2_2_intro … H2) -H2 /2 width=2/ (**) (* explicit constructor, /3 width=6/ is slow *)
qed-.

lemma cpcs_inv_abst2: ∀a,L,W1,T1,T. L ⊢ T ⬌* ⓛ{a}W1.T1 →
                      ∃∃W2,T2. L ⊢ T ➡* ⓛ{a}W2.T2 & L ⊢ ⓛ{a}W1.T1 ➡* ⓛ{a}W2.T2.
/3 width=1 by cpcs_inv_abst1, cpcs_sym/ qed-.

(* Basic_1: was: pc3_gen_sort_abst *)
lemma cpcs_inv_sort_abst: ∀a,L,W,T,k. L ⊢ ⋆k ⬌* ⓛ{a}W.T → ⊥.
#a #L #W #T #k #H
elim (cpcs_inv_cprs … H) -H #X #H1
>(cprs_inv_sort1 … H1) -X #H2
elim (cprs_inv_abst1 … H2) -H2 #W0 #T0 #_ #_ #H destruct
qed-.

(* Basic_1: was: pc3_gen_lift *)
lemma cpcs_inv_lift: ∀L,K,d,e. ⇩[d, e] L ≡ K →
                     ∀T1,U1. ⇧[d, e] T1 ≡ U1 → ∀T2,U2. ⇧[d, e] T2 ≡ U2 →
                     L ⊢ U1 ⬌* U2 → K ⊢ T1 ⬌* T2.
#L #K #d #e #HLK #T1 #U1 #HTU1 #T2 #U2 #HTU2 #HU12
elim (cpcs_inv_cprs … HU12) -HU12 #U #HU1 #HU2
elim (cprs_inv_lift1 … HU1 … HLK … HTU1) -U1 #T #HTU #HT1
elim (cprs_inv_lift1 … HU2 … HLK … HTU2) -L -U2 #X #HXU
>(lift_inj … HXU … HTU) -X -U -d -e /2 width=3/
qed-.

(* Advanced properties ******************************************************)

lemma lpr_cpcs_trans: ∀L1,L2. L1 ⊢ ➡ L2 → ∀T1,T2. L2 ⊢ T1 ⬌* T2 → L1 ⊢ T1 ⬌* T2.
#L1 #L2 #HL12 #T1 #T2 #H
elim (cpcs_inv_cprs … H) -H #T #HT1 #HT2
lapply (lpr_cprs_trans … HT1 … HL12) -HT1
lapply (lpr_cprs_trans … HT2 … HL12) -L2 /2 width=3/
qed-.

lemma lprs_cpcs_trans: ∀L1,L2. L1 ⊢ ➡* L2 → ∀T1,T2. L2 ⊢ T1 ⬌* T2 → L1 ⊢ T1 ⬌* T2.
#L1 #L2 #HL12 #T1 #T2 #H
elim (cpcs_inv_cprs … H) -H #T #HT1 #HT2
lapply (lprs_cprs_trans … HT1 … HL12) -HT1
lapply (lprs_cprs_trans … HT2 … HL12) -L2 /2 width=3/
qed-.

lemma cpr_cprs_conf_cpcs: ∀L,T,T1,T2. L ⊢ T ➡* T1 → L ⊢ T ➡ T2 → L ⊢ T1 ⬌* T2.
#L #T #T1 #T2 #HT1 #HT2
elim (cprs_strip … HT1 … HT2) /2 width=3 by cpr_cprs_div/
qed-.

lemma cprs_cpr_conf_cpcs: ∀L,T,T1,T2. L ⊢ T ➡* T1 → L ⊢ T ➡ T2 → L ⊢ T2 ⬌* T1.
#L #T #T1 #T2 #HT1 #HT2
elim (cprs_strip … HT1 … HT2) /2 width=3 by cprs_cpr_div/
qed-.

lemma cprs_conf_cpcs: ∀L,T,T1,T2. L ⊢ T ➡* T1 → L ⊢ T ➡* T2 → L ⊢ T1 ⬌* T2.
#L #T #T1 #T2 #HT1 #HT2
elim (cprs_conf … HT1 … HT2) /2 width=3/
qed-.

lemma lprs_cprs_conf: ∀L1,L2. L1 ⊢ ➡* L2 → ∀T1,T2. L1 ⊢ T1 ➡* T2 → L2 ⊢ T1 ⬌* T2.
#L1 #L2 #HL12 #T1 #T2 #HT12
elim (lprs_cprs_conf_dx … HT12 … HL12) -L1 /2 width=3/
qed-.

(* Basic_1: was: pc3_wcpr0_t *)
(* Basic_1: note: pc3_wcpr0_t should be renamed *)
lemma lpr_cprs_conf: ∀L1,L2. L1 ⊢ ➡ L2 → ∀T1,T2. L1 ⊢ T1 ➡* T2 → L2 ⊢ T1 ⬌* T2.
/3 width=5 by lprs_cprs_conf, lpr_lprs/ qed-.

(* Basic_1: was only: pc3_pr0_pr2_t *)
(* Basic_1: note: pc3_pr0_pr2_t should be renamed *)
lemma lpr_cpr_conf: ∀L1,L2. L1 ⊢ ➡ L2 → ∀T1,T2. L1 ⊢ T1 ➡ T2 → L2 ⊢ T1 ⬌* T2.
/3 width=5 by lpr_cprs_conf, cpr_cprs/ qed-.

(* Basic_1: was only: pc3_thin_dx *)
lemma cpcs_flat: ∀L,V1,V2. L ⊢ V1 ⬌* V2 → ∀T1,T2. L ⊢ T1 ⬌* T2 →
                 ∀I. L ⊢ ⓕ{I}V1. T1 ⬌* ⓕ{I}V2. T2.
#L #V1 #V2 #HV12 #T1 #T2 #HT12 #I
elim (cpcs_inv_cprs … HV12) -HV12 #V #HV1 #HV2
elim (cpcs_inv_cprs … HT12) -HT12 /3 width=5 by cprs_flat, cprs_div/ (**) (* /3 width=5/ is too slow *)
qed.

lemma cpcs_flat_dx_cpr_rev: ∀L,V1,V2. L ⊢ V2 ➡ V1 → ∀T1,T2. L ⊢ T1 ⬌* T2 →
                            ∀I. L ⊢ ⓕ{I}V1. T1 ⬌* ⓕ{I}V2. T2.
/3 width=1/ qed.

lemma cpcs_bind_dx: ∀a,I,L,V,T1,T2. L.ⓑ{I}V ⊢ T1 ⬌* T2 →
                    L ⊢ ⓑ{a,I}V. T1 ⬌* ⓑ{a,I}V. T2.
#a #I #L #V #T1 #T2 #HT12
elim (cpcs_inv_cprs … HT12) -HT12 /3 width=5 by cprs_div, cprs_bind/ (**) (* /3 width=5/ is a bit slow *)
qed.

lemma cpcs_bind_sn: ∀a,I,L,V1,V2,T. L ⊢ V1 ⬌* V2 → L ⊢ ⓑ{a,I}V1. T ⬌* ⓑ{a,I}V2. T.
#a #I #L #V1 #V2 #T #HV12
elim (cpcs_inv_cprs … HV12) -HV12 /3 width=5 by cprs_div, cprs_bind/ (**) (* /3 width=5/ is a bit slow *)
qed.

lemma lsubx_cpcs_trans: ∀L1,T1,T2. L1 ⊢ T1 ⬌* T2 →
                        ∀L2. L2 ⓝ⊑ L1 → L2 ⊢ T1 ⬌* T2.
#L1 #T1 #T2 #HT12
elim (cpcs_inv_cprs … HT12) -HT12
/3 width=5 by cprs_div, lsubx_cprs_trans/ (**) (* /3 width=5/ is a bit slow *)
qed-.

(* Basic_1: was: pc3_lift *)
lemma cpcs_lift: ∀L,K,d,e. ⇩[d, e] L ≡ K →
                 ∀T1,U1. ⇧[d, e] T1 ≡ U1 → ∀T2,U2. ⇧[d, e] T2 ≡ U2 →
                 K ⊢ T1 ⬌* T2 → L ⊢ U1 ⬌* U2.
#L #K #d #e #HLK #T1 #U1 #HTU1 #T2 #U2 #HTU2 #HT12
elim (cpcs_inv_cprs … HT12) -HT12 #T #HT1 #HT2
elim (lift_total T d e) #U #HTU
lapply (cprs_lift … HT1 … HLK … HTU1 … HTU) -T1 #HU1
lapply (cprs_lift … HT2 … HLK … HTU2 … HTU) -K -T2 -T -d -e /2 width=3/
qed.

lemma cpcs_strip: ∀L,T1,T. L ⊢ T ⬌* T1 → ∀T2. L ⊢ T ⬌ T2 →
                  ∃∃T0. L ⊢ T1 ⬌ T0 & L ⊢ T2 ⬌* T0.
#L #T1 #T @TC_strip1 /2 width=3/ qed-.

(* More inversion lemmas ****************************************************)

lemma cpcs_inv_abst_sn: ∀a1,a2,L,W1,W2,T1,T2. L ⊢ ⓛ{a1}W1.T1 ⬌* ⓛ{a2}W2.T2 →
                        ∧∧ L ⊢ W1 ⬌* W2 & L.ⓛW1 ⊢ T1 ⬌* T2 & a1 = a2.
#a1 #a2 #L #W1 #W2 #T1 #T2 #H
elim (cpcs_inv_cprs … H) -H #T #H1 #H2
elim (cprs_inv_abst1 … H1) -H1 #W0 #T0 #HW10 #HT10 #H destruct
elim (cprs_inv_abst1 … H2) -H2 #W #T #HW2 #HT2 #H destruct
lapply (lprs_cprs_conf … (L.ⓛW) … HT2) /2 width=1/ -HT2 #HT2
lapply (lprs_cpcs_trans … (L.ⓛW1) … HT2) /2 width=1/ -HT2 #HT2
/4 width=3 by and3_intro, cprs_div, cpcs_cprs_div, cpcs_sym/
qed-.

lemma cpcs_inv_abst_dx: ∀a1,a2,L,W1,W2,T1,T2. L ⊢ ⓛ{a1}W1.T1 ⬌* ⓛ{a2}W2.T2 →
                        ∧∧ L ⊢ W1 ⬌* W2 & L. ⓛW2 ⊢ T1 ⬌* T2 & a1 = a2.
#a1 #a2 #L #W1 #W2 #T1 #T2 #HT12
lapply (cpcs_sym … HT12) -HT12 #HT12
elim (cpcs_inv_abst_sn … HT12) -HT12 /3 width=1/
qed-.

(* Main properties **********************************************************)

(* Basic_1: was pc3_t *)
theorem cpcs_trans: ∀L,T1,T. L ⊢ T1 ⬌* T → ∀T2. L ⊢ T ⬌* T2 → L ⊢ T1 ⬌* T2.
#L #T1 #T #HT1 #T2 @(trans_TC … HT1) qed-.

theorem cpcs_canc_sn: ∀L,T,T1,T2. L ⊢ T ⬌* T1 → L ⊢ T ⬌* T2 → L ⊢ T1 ⬌* T2.
/3 width=3 by cpcs_trans, cpcs_sym/ qed-. (**) (* /3 width=3/ is too slow *)

theorem cpcs_canc_dx: ∀L,T,T1,T2. L ⊢ T1 ⬌* T → L ⊢ T2 ⬌* T → L ⊢ T1 ⬌* T2.
/3 width=3 by cpcs_trans, cpcs_sym/ qed-. (**) (* /3 width=3/ is too slow *)

lemma cpcs_bind1: ∀a,I,L,V1,V2. L ⊢ V1 ⬌* V2 → ∀T1,T2. L.ⓑ{I}V1 ⊢ T1 ⬌* T2 →
                  L ⊢ ⓑ{a,I}V1. T1 ⬌* ⓑ{a,I}V2. T2.
#a #I #L #V1 #V2 #HV12 #T1 #T2 #HT12
@(cpcs_trans … (ⓑ{a,I}V1.T2)) /2 width=1/
qed.

lemma cpcs_bind2: ∀a,I,L,V1,V2. L ⊢ V1 ⬌* V2 → ∀T1,T2. L.ⓑ{I}V2 ⊢ T1 ⬌* T2 →
                  L ⊢ ⓑ{a,I}V1. T1 ⬌* ⓑ{a,I}V2. T2.
#a #I #L #V1 #V2 #HV12 #T1 #T2 #HT12
@(cpcs_trans … (ⓑ{a,I}V2.T1)) /2 width=1/
qed.

lemma cpcs_beta_dx: ∀a,L,V1,V2,W1,W2,T1,T2.
                    L ⊢ V1 ⬌* V2 → L ⊢ W1 ⬌* W2 → L.ⓛW2 ⊢ T1 ⬌* T2 →
                    L ⊢ ⓐV1.ⓛ{a}W1.T1 ⬌* ⓓ{a}ⓝW2.V2.T2.
#a #L #V1 #V2 #W1 #W2 #T1 #T2 #HV12 #HW12 #HT12
@(cpcs_cpr_strap1 … (ⓐV2.ⓛ{a}W2.T2)) /2 width=1/ /3 width=1/
qed.

lemma cpcs_beta_sn: ∀a,L,V1,V2,W1,W2,T1,T2.
                    L ⊢ V1 ⬌* V2 → L ⊢ W1 ⬌* W2 → L.ⓛW1 ⊢ T1 ⬌* T2 →
                    L ⊢ ⓐV1.ⓛ{a}W1.T1 ⬌* ⓓ{a}ⓝW2.V2.T2.
#a #L #V1 #V2 #W1 #W2 #T1 #T2 #HV12 #HW12 #HT12
lapply (lsubx_cpcs_trans … HT12 (L.ⓓⓝW1.V1) ?) /2 width=1/ #H2T12
@(cpcs_cpr_strap2 … (ⓓ{a}ⓝW1.V1.T1)) /2 width=1/ -HT12 /3 width=1/
qed.

(* Basic_1: was: pc3_wcpr0 *)
lemma lpr_cpcs_conf: ∀L1,L2. L1 ⊢ ➡ L2 → ∀T1,T2. L1 ⊢ T1 ⬌* T2 → L2 ⊢ T1 ⬌* T2.
#L1 #L2 #HL12 #T1 #T2 #H
elim (cpcs_inv_cprs … H) -H /3 width=5 by cpcs_canc_dx, lpr_cprs_conf/
qed-.
