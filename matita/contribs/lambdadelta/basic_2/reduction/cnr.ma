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

include "basic_2/notation/relations/normal_3.ma".
include "basic_2/reduction/cpr.ma".

(* CONTEXT-SENSITIVE NORMAL TERMS *******************************************)

definition cnr: relation3 genv lenv term ≝ λG,L. NF … (cpr G L) (eq …).

interpretation
   "context-sensitive normality (term)"
   'Normal G L T = (cnr G L T).

(* Basic inversion lemmas ***************************************************)

lemma cnr_inv_delta: ∀G,L,K,V,i. ⇩[0, i] L ≡ K.ⓓV → ⦃G, L⦄ ⊢ 𝐍⦃#i⦄ → ⊥.
#G #L #K #V #i #HLK #H
elim (lift_total V 0 (i+1)) #W #HVW
lapply (H W ?) -H [ /3 width=6/ ] -HLK #H destruct
elim (lift_inv_lref2_be … HVW) -HVW //
qed-.

lemma cnr_inv_abst: ∀a,G,L,V,T. ⦃G, L⦄ ⊢ 𝐍⦃ⓛ{a}V.T⦄ → ⦃G, L⦄ ⊢ 𝐍⦃V⦄ ∧ ⦃G, L.ⓛV⦄ ⊢ 𝐍⦃T⦄.
#a #G #L #V1 #T1 #HVT1 @conj
[ #V2 #HV2 lapply (HVT1 (ⓛ{a}V2.T1) ?) -HVT1 /2 width=2/ -HV2 #H destruct //
| #T2 #HT2 lapply (HVT1 (ⓛ{a}V1.T2) ?) -HVT1 /2 width=2/ -HT2 #H destruct //
]
qed-.

lemma cnr_inv_abbr: ∀G,L,V,T. ⦃G, L⦄ ⊢ 𝐍⦃-ⓓV.T⦄ → ⦃G, L⦄ ⊢ 𝐍⦃V⦄ ∧ ⦃G, L.ⓓV⦄ ⊢ 𝐍⦃T⦄.
#G #L #V1 #T1 #HVT1 @conj
[ #V2 #HV2 lapply (HVT1 (-ⓓV2.T1) ?) -HVT1 /2 width=2/ -HV2 #H destruct //
| #T2 #HT2 lapply (HVT1 (-ⓓV1.T2) ?) -HVT1 /2 width=2/ -HT2 #H destruct //
]
qed-.

lemma cnr_inv_zeta: ∀G,L,V,T. ⦃G, L⦄ ⊢ 𝐍⦃+ⓓV.T⦄ → ⊥.
#G #L #V #T #H elim (is_lift_dec T 0 1)
[ * #U #HTU
  lapply (H U ?) -H /2 width=3/ #H destruct
  elim (lift_inv_pair_xy_y … HTU)
| #HT
  elim (cpr_delift G (⋆) V T (⋆. ⓓV) 0) // #T2 #T1 #HT2 #HT12
  lapply (H (+ⓓV.T2) ?) -H /4 width=1/ -HT2 #H destruct /3 width=2/
]
qed-.

lemma cnr_inv_appl: ∀G,L,V,T. ⦃G, L⦄ ⊢ 𝐍⦃ⓐV.T⦄ → ∧∧ ⦃G, L⦄ ⊢ 𝐍⦃V⦄ & ⦃G, L⦄ ⊢ 𝐍⦃T⦄ & 𝐒⦃T⦄.
#G #L #V1 #T1 #HVT1 @and3_intro
[ #V2 #HV2 lapply (HVT1 (ⓐV2.T1) ?) -HVT1 /2 width=1/ -HV2 #H destruct //
| #T2 #HT2 lapply (HVT1 (ⓐV1.T2) ?) -HVT1 /2 width=1/ -HT2 #H destruct //
| generalize in match HVT1; -HVT1 elim T1 -T1 * // #a * #W1 #U1 #_ #_ #H
  [ elim (lift_total V1 0 1) #V2 #HV12
    lapply (H (ⓓ{a}W1.ⓐV2.U1) ?) -H /3 width=3/ -HV12 #H destruct
  | lapply (H (ⓓ{a}ⓝW1.V1.U1) ?) -H /3 width=1/ #H destruct
]
qed-.

lemma cnr_inv_tau: ∀G,L,V,T. ⦃G, L⦄ ⊢ 𝐍⦃ⓝV.T⦄ → ⊥.
#G #L #V #T #H lapply (H T ?) -H /2 width=1/ #H
@discr_tpair_xy_y //
qed-.

(* Basic properties *********************************************************)

(* Basic_1: was: nf2_sort *)
lemma cnr_sort: ∀G,L,k. ⦃G, L⦄ ⊢ 𝐍⦃⋆k⦄.
#G #L #k #X #H
>(cpr_inv_sort1 … H) //
qed.

(* Basic_1: was: nf2_abst *)
lemma cnr_abst: ∀a,G,L,W,T. ⦃G, L⦄ ⊢ 𝐍⦃W⦄ → ⦃G, L.ⓛW⦄ ⊢ 𝐍⦃T⦄ → ⦃G, L⦄ ⊢ 𝐍⦃ⓛ{a}W.T⦄.
#a #G #L #W #T #HW #HT #X #H
elim (cpr_inv_abst1 … H) -H #W0 #T0 #HW0 #HT0 #H destruct
>(HW … HW0) -W0 >(HT … HT0) -T0 //
qed.

(* Basic_1: was only: nf2_appl_lref *)
lemma cnr_appl_simple: ∀G,L,V,T. ⦃G, L⦄ ⊢ 𝐍⦃V⦄ → ⦃G, L⦄ ⊢ 𝐍⦃T⦄ → 𝐒⦃T⦄ → ⦃G, L⦄ ⊢ 𝐍⦃ⓐV.T⦄.
#G #L #V #T #HV #HT #HS #X #H
elim (cpr_inv_appl1_simple … H) -H // #V0 #T0 #HV0 #HT0 #H destruct
>(HV … HV0) -V0 >(HT … HT0) -T0 //
qed.

(* Basic_1: was: nf2_dec *)
axiom cnr_dec: ∀G,L,T1. ⦃G, L⦄ ⊢ 𝐍⦃T1⦄ ∨
               ∃∃T2. ⦃G, L⦄ ⊢ T1 ➡ T2 & (T1 = T2 → ⊥).

(* Basic_1: removed theorems 1: nf2_abst_shift *)
