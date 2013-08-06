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

include "basic_2/notation/relations/predstar_4.ma".
include "basic_2/reduction/cnr.ma".

(* CONTEXT-SENSITIVE PARALLEL COMPUTATION ON TERMS **************************)

(* Basic_1: includes: pr1_pr0 *)
definition cprs: relation4 genv lenv term term ≝
                 λG. LTC … (cpr G).

interpretation "context-sensitive parallel computation (term)"
   'PRedStar G L T1 T2 = (cprs G L T1 T2).

(* Basic eliminators ********************************************************)

lemma cprs_ind: ∀G,L,T1. ∀R:predicate term. R T1 →
                (∀T,T2. ⦃G, L⦄ ⊢ T1 ➡* T → ⦃G, L⦄ ⊢ T ➡ T2 → R T → R T2) →
                ∀T2. ⦃G, L⦄ ⊢ T1 ➡* T2 → R T2.
#G #L #T1 #R #HT1 #IHT1 #T2 #HT12
@(TC_star_ind … HT1 IHT1 … HT12) //
qed-.

lemma cprs_ind_dx: ∀G,L,T2. ∀R:predicate term. R T2 →
                   (∀T1,T. ⦃G, L⦄ ⊢ T1 ➡ T → ⦃G, L⦄ ⊢ T ➡* T2 → R T → R T1) →
                   ∀T1. ⦃G, L⦄ ⊢ T1 ➡* T2 → R T1.
#G #L #T2 #R #HT2 #IHT2 #T1 #HT12
@(TC_star_ind_dx … HT2 IHT2 … HT12) //
qed-.

(* Basic properties *********************************************************)

(* Basic_1: was: pr3_pr2 *)
lemma cpr_cprs: ∀G,L,T1,T2. ⦃G, L⦄ ⊢ T1 ➡ T2 → ⦃G, L⦄ ⊢ T1 ➡* T2.
/2 width=1/ qed.

(* Basic_1: was: pr3_refl *)
lemma cprs_refl: ∀G,L,T. ⦃G, L⦄ ⊢ T ➡* T.
/2 width=1/ qed.

lemma cprs_strap1: ∀G,L,T1,T,T2.
                   ⦃G, L⦄ ⊢ T1 ➡* T → ⦃G, L⦄ ⊢ T ➡ T2 → ⦃G, L⦄ ⊢ T1 ➡* T2.
normalize /2 width=3/ qed.

(* Basic_1: was: pr3_step *)
lemma cprs_strap2: ∀G,L,T1,T,T2.
                   ⦃G, L⦄ ⊢ T1 ➡ T → ⦃G, L⦄ ⊢ T ➡* T2 → ⦃G, L⦄ ⊢ T1 ➡* T2.
normalize /2 width=3/ qed.

lemma lsubr_cprs_trans: ∀G. lsub_trans … (cprs G) lsubr.
/3 width=5 by lsubr_cpr_trans, TC_lsub_trans/
qed-.

(* Basic_1: was: pr3_pr1 *)
lemma tprs_cprs: ∀G,L,T1,T2. ⦃G, ⋆⦄ ⊢ T1 ➡* T2 → ⦃G, L⦄ ⊢ T1 ➡* T2.
#G #L #T1 #T2 #H @(lsubr_cprs_trans … H) -H //
qed.

lemma cprs_bind_dx: ∀G,L,V1,V2. ⦃G, L⦄ ⊢ V1 ➡ V2 → ∀I,T1,T2. ⦃G, L.ⓑ{I}V1⦄ ⊢ T1 ➡* T2 →
                    ∀a. ⦃G, L⦄ ⊢ ⓑ{a,I}V1. T1 ➡* ⓑ{a,I}V2. T2.
#G #L #V1 #V2 #HV12 #I #T1 #T2 #HT12 #a @(cprs_ind_dx … HT12) -T1
/3 width=1/ /3 width=3/
qed.

(* Basic_1: was only: pr3_thin_dx *)
lemma cprs_flat_dx: ∀I,G,L,V1,V2. ⦃G, L⦄ ⊢ V1 ➡ V2 → ∀T1,T2. ⦃G, L⦄ ⊢ T1 ➡* T2 →
                    ⦃G, L⦄ ⊢ ⓕ{I} V1. T1 ➡* ⓕ{I} V2. T2.
#I #G #L #V1 #V2 #HV12 #T1 #T2 #HT12 @(cprs_ind … HT12) -T2 /3 width=1/
#T #T2 #_ #HT2 #IHT1
@(cprs_strap1 … IHT1) -V1 -T1 /2 width=1/
qed.

lemma cprs_flat_sn: ∀I,G,L,T1,T2. ⦃G, L⦄ ⊢ T1 ➡ T2 → ∀V1,V2. ⦃G, L⦄ ⊢ V1 ➡* V2 →
                    ⦃G, L⦄ ⊢ ⓕ{I} V1. T1 ➡* ⓕ{I} V2. T2.
#I #G #L #T1 #T2 #HT12 #V1 #V2 #H @(cprs_ind … H) -V2 /3 width=1/
#V #V2 #_ #HV2 #IHV1
@(cprs_strap1 … IHV1) -V1 -T1 /2 width=1/
qed.

lemma cprs_zeta: ∀G,L,V,T1,T,T2. ⇧[0, 1] T2 ≡ T →
                 ⦃G, L.ⓓV⦄ ⊢ T1 ➡* T → ⦃G, L⦄ ⊢ +ⓓV.T1 ➡* T2.
#G #L #V #T1 #T #T2 #HT2 #H @(TC_ind_dx … T1 H) -T1 /3 width=3/
qed.

lemma cprs_tau: ∀G,L,T1,T2. ⦃G, L⦄ ⊢ T1 ➡* T2 → ∀V. ⦃G, L⦄ ⊢ ⓝV.T1 ➡* T2.
#G #L #T1 #T2 #H elim H -T2 /2 width=3/ /3 width=1/
qed.

lemma cprs_beta_dx: ∀a,G,L,V1,V2,W1,W2,T1,T2.
                    ⦃G, L⦄ ⊢ V1 ➡ V2 → ⦃G, L⦄ ⊢ W1 ➡ W2 → ⦃G, L.ⓛW1⦄ ⊢ T1 ➡* T2 →
                    ⦃G, L⦄ ⊢ ⓐV1.ⓛ{a}W1.T1 ➡* ⓓ{a}ⓝW2.V2.T2.
#a #G #L #V1 #V2 #W1 #W2 #T1 #T2 #HV12 #HW12 * -T2 /3 width=1/
/4 width=7 by cprs_strap1, cprs_bind_dx, cprs_flat_dx, cpr_beta/ (**) (* auto too slow without trace *)
qed.

lemma cprs_theta_dx: ∀a,G,L,V1,V,V2,W1,W2,T1,T2.
                     ⦃G, L⦄ ⊢ V1 ➡ V → ⇧[0, 1] V ≡ V2 → ⦃G, L.ⓓW1⦄ ⊢ T1 ➡* T2 →
                     ⦃G, L⦄ ⊢ W1 ➡ W2 → ⦃G, L⦄ ⊢ ⓐV1.ⓓ{a}W1.T1 ➡* ⓓ{a}W2.ⓐV2.T2.
#a #G #L #V1 #V #V2 #W1 #W2 #T1 #T2 #HV1 #HV2 * -T2 [ /3 width=3/ ]
/4 width=9 by cprs_strap1, cprs_bind_dx, cprs_flat_dx, cpr_theta/ (**) (* auto too slow without trace *)
qed.

(* Basic inversion lemmas ***************************************************)

(* Basic_1: was: pr3_gen_sort *)
lemma cprs_inv_sort1: ∀G,L,U2,k. ⦃G, L⦄ ⊢ ⋆k ➡* U2 → U2 = ⋆k.
#G #L #U2 #k #H @(cprs_ind … H) -U2 //
#U2 #U #_ #HU2 #IHU2 destruct
>(cpr_inv_sort1 … HU2) -HU2 //
qed-.

(* Basic_1: was: pr3_gen_cast *)
lemma cprs_inv_cast1: ∀G,L,W1,T1,U2. ⦃G, L⦄ ⊢ ⓝW1.T1 ➡* U2 → ⦃G, L⦄ ⊢ T1 ➡* U2 ∨
                      ∃∃W2,T2. ⦃G, L⦄ ⊢ W1 ➡* W2 & ⦃G, L⦄ ⊢ T1 ➡* T2 & U2 = ⓝW2.T2.
#G #L #W1 #T1 #U2 #H @(cprs_ind … H) -U2 /3 width=5/
#U2 #U #_ #HU2 * /3 width=3/ *
#W #T #HW1 #HT1 #H destruct
elim (cpr_inv_cast1 … HU2) -HU2 /3 width=3/ *
#W2 #T2 #HW2 #HT2 #H destruct /4 width=5/
qed-.

(* Basic_1: was: nf2_pr3_unfold *)
lemma cprs_inv_cnr1: ∀G,L,T,U. ⦃G, L⦄ ⊢ T ➡* U → ⦃G, L⦄ ⊢ 𝐍⦃T⦄ → T = U.
#G #L #T #U #H @(cprs_ind_dx … H) -T //
#T0 #T #H1T0 #_ #IHT #H2T0
lapply (H2T0 … H1T0) -H1T0 #H destruct /2 width=1/
qed-.

(* Basic_1: removed theorems 13:
   pr1_head_1 pr1_head_2 pr1_comp
   clear_pr3_trans pr3_cflat pr3_gen_bind
   pr3_head_1 pr3_head_2 pr3_head_21 pr3_head_12
   pr3_iso_appl_bind pr3_iso_appls_appl_bind pr3_iso_appls_bind
*)
