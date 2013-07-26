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

include "basic_2/notation/relations/normal_4.ma".
include "basic_2/reduction/cnr.ma".
include "basic_2/reduction/cpx.ma".

(* CONTEXT-SENSITIVE EXTENDED NORMAL TERMS **********************************)

definition cnx: ∀h. sd h → lenv → predicate term ≝
                λh,g,L. NF … (cpx h g L) (eq …).

interpretation
   "context-sensitive extended normality (term)"
   'Normal h g L T = (cnx h g L T).

(* Basic inversion lemmas ***************************************************)

lemma cnx_inv_sort: ∀h,g,L,k. ⦃h, L⦄ ⊢ 𝐍[g]⦃⋆k⦄ → deg h g k 0.
#h #g #L #k #H elim (deg_total h g k)
#l @(nat_ind_plus … l) -l // #l #_ #Hkl
lapply (H (⋆(next h k)) ?) -H /2 width=2/ -L -l #H destruct -H -e0 (**) (* destruct does not remove some premises *)
lapply (next_lt h k) >e1 -e1 #H elim (lt_refl_false … H)
qed-.

lemma cnx_inv_delta: ∀h,g,I,L,K,V,i. ⇩[0, i] L ≡ K.ⓑ{I}V → ⦃h, L⦄ ⊢ 𝐍[g]⦃#i⦄ → ⊥.
#h #g #I #L #K #V #i #HLK #H
elim (lift_total V 0 (i+1)) #W #HVW
lapply (H W ?) -H [ /3 width=7/ ] -HLK #H destruct
elim (lift_inv_lref2_be … HVW) -HVW //
qed-.

lemma cnx_inv_abst: ∀h,g,a,L,V,T. ⦃h, L⦄ ⊢ 𝐍[g]⦃ⓛ{a}V.T⦄ →
                    ⦃h, L⦄ ⊢ 𝐍[g]⦃V⦄ ∧ ⦃h, L.ⓛV⦄ ⊢ 𝐍[g]⦃T⦄.
#h #g #a #L #V1 #T1 #HVT1 @conj
[ #V2 #HV2 lapply (HVT1 (ⓛ{a}V2.T1) ?) -HVT1 /2 width=2/ -HV2 #H destruct //
| #T2 #HT2 lapply (HVT1 (ⓛ{a}V1.T2) ?) -HVT1 /2 width=2/ -HT2 #H destruct //
]
qed-.

lemma cnx_inv_abbr: ∀h,g,L,V,T. ⦃h, L⦄ ⊢ 𝐍[g]⦃-ⓓV.T⦄ →
                    ⦃h, L⦄ ⊢ 𝐍[g]⦃V⦄ ∧ ⦃h, L.ⓓV⦄ ⊢ 𝐍[g]⦃T⦄.
#h #g #L #V1 #T1 #HVT1 @conj
[ #V2 #HV2 lapply (HVT1 (-ⓓV2.T1) ?) -HVT1 /2 width=2/ -HV2 #H destruct //
| #T2 #HT2 lapply (HVT1 (-ⓓV1.T2) ?) -HVT1 /2 width=2/ -HT2 #H destruct //
]
qed-.

lemma cnx_inv_zeta: ∀h,g,L,V,T. ⦃h, L⦄ ⊢ 𝐍[g]⦃+ⓓV.T⦄ → ⊥.
#h #g #L #V #T #H elim (is_lift_dec T 0 1)
[ * #U #HTU
  lapply (H U ?) -H /2 width=3/ #H destruct
  elim (lift_inv_pair_xy_y … HTU)
| #HT
  elim (cpr_delift (⋆) V T (⋆.ⓓV) 0) // #T2 #T1 #HT2 #HT12
  lapply (H (+ⓓV.T2) ?) -H /5 width=1/ -HT2 #H destruct /3 width=2/
]
qed-.

lemma cnx_inv_appl: ∀h,g,L,V,T. ⦃h, L⦄ ⊢ 𝐍[g]⦃ⓐV.T⦄ →
                    ∧∧ ⦃h, L⦄ ⊢ 𝐍[g]⦃V⦄ & ⦃h, L⦄ ⊢ 𝐍[g]⦃T⦄ & 𝐒⦃T⦄.
#h #g #L #V1 #T1 #HVT1 @and3_intro
[ #V2 #HV2 lapply (HVT1 (ⓐV2.T1) ?) -HVT1 /2 width=1/ -HV2 #H destruct //
| #T2 #HT2 lapply (HVT1 (ⓐV1.T2) ?) -HVT1 /2 width=1/ -HT2 #H destruct //
| generalize in match HVT1; -HVT1 elim T1 -T1 * // #a * #W1 #U1 #_ #_ #H
  [ elim (lift_total V1 0 1) #V2 #HV12
    lapply (H (ⓓ{a}W1.ⓐV2.U1) ?) -H /3 width=3/ -HV12 #H destruct
  | lapply (H (ⓓ{a}ⓝW1.V1.U1) ?) -H /3 width=1/ #H destruct
]
qed-.

lemma cnx_inv_tau: ∀h,g,L,V,T. ⦃h, L⦄ ⊢ 𝐍[g]⦃ⓝV.T⦄ → ⊥.
#h #g #L #V #T #H lapply (H T ?) -H /2 width=1/ #H
@discr_tpair_xy_y //
qed-.

(* Basic forward lemmas *****************************************************)

lemma cnx_fwd_cnr: ∀h,g,L,T. ⦃h, L⦄ ⊢ 𝐍[g]⦃T⦄ → L ⊢ 𝐍⦃T⦄.
#h #g #L #T #H #U #HTU
@H /2 width=1/ (**) (* auto fails because a δ-expansion gets in the way *)
qed-.

(* Basic properties *********************************************************)

lemma cnx_sort: ∀h,g,L,k. deg h g k 0 → ⦃h, L⦄ ⊢ 𝐍[g]⦃⋆k⦄.
#h #g #L #k #Hk #X #H elim (cpx_inv_sort1 … H) -H // * #l #Hkl #_
lapply (deg_mono … Hkl Hk) -h -L <plus_n_Sm #H destruct 
qed.

lemma cnx_sort_iter: ∀h,g,L,k,l. deg h g k l → ⦃h, L⦄ ⊢ 𝐍[g]⦃⋆((next h)^l k)⦄.
#h #g #L #k #l #Hkl
lapply (deg_iter … l Hkl) -Hkl <minus_n_n /2 width=1/
qed.

lemma cnx_abst: ∀h,g,a,L,W,T. ⦃h, L⦄ ⊢ 𝐍[g]⦃W⦄ → ⦃h, L.ⓛW⦄ ⊢ 𝐍[g]⦃T⦄ →
                ⦃h, L⦄ ⊢ 𝐍[g]⦃ⓛ{a}W.T⦄.
#h #g #a #L #W #T #HW #HT #X #H
elim (cpx_inv_abst1 … H) -H #W0 #T0 #HW0 #HT0 #H destruct
>(HW … HW0) -W0 >(HT … HT0) -T0 //
qed.

lemma cnx_appl_simple: ∀h,g,L,V,T. ⦃h, L⦄ ⊢ 𝐍[g]⦃V⦄ → ⦃h, L⦄ ⊢ 𝐍[g]⦃T⦄ → 𝐒⦃T⦄ →
                       ⦃h, L⦄ ⊢ 𝐍[g]⦃ⓐV.T⦄.
#h #g #L #V #T #HV #HT #HS #X #H
elim (cpx_inv_appl1_simple … H) -H // #V0 #T0 #HV0 #HT0 #H destruct
>(HV … HV0) -V0 >(HT … HT0) -T0 //
qed.

axiom cnx_dec: ∀h,g,L,T1. ⦃h, L⦄ ⊢ 𝐍[g]⦃T1⦄ ∨
               ∃∃T2. ⦃h, L⦄ ⊢ T1 ➡[g] T2 & (T1 = T2 → ⊥).
