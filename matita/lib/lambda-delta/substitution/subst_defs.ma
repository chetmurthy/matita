(*
    ||M||  This file is part of HELM, an Hypertextual, Electronic
    ||A||  Library of Mathematics, developed at the Computer Science
    ||T||  Department of the University of Bologna, Italy.
    ||I||
    ||T||
    ||A||  This file is distributed under the terms of the
    \   /  GNU General Public License Version 2
     \ /
      V_______________________________________________________________ *)

include "lambda-delta/substitution/drop_defs.ma".

(* TELESCOPIC SUBSTITUTION **************************************************)

inductive subst: lenv → term → nat → nat → term → Prop ≝
| subst_sort   : ∀L,k,d,e. subst L (⋆k) d e (⋆k)
| subst_lref_lt: ∀L,i,d,e. i < d → subst L (#i) d e (#i)
| subst_lref_be: ∀L,K,V,U1,U2,i,d,e.
                 d ≤ i → i < d + e →
                 ↑[0, i] K. 𝕓{Abbr} V ≡ L → subst K V 0 (d + e - i - 1) U1 →
                 ↑[0, d] U1 ≡ U2 → subst L (#i) d e U2
| subst_lref_ge: ∀L,i,d,e. d + e ≤ i → subst L (#i) d e (#(i - e))
| subst_bind   : ∀L,I,V1,V2,T1,T2,d,e.
                 subst L V1 d e V2 → subst (L. 𝕓{I} V1) T1 (d + 1) e T2 →
                 subst L (𝕓{I} V1. T1) d e (𝕓{I} V2. T2)
| subst_flat   : ∀L,I,V1,V2,T1,T2,d,e.
                 subst L V1 d e V2 → subst L T1 d e T2 →
                 subst L (𝕗{I} V1. T1) d e (𝕗{I} V2. T2)
.

interpretation "telescopic substritution" 'RSubst L T1 d e T2 = (subst L T1 d e T2).

(* The basic properties *****************************************************)

lemma subst_lift_inv: ∀d,e,T1,T2. ↑[d,e] T1 ≡ T2 → ∀L. L ⊢ ↓[d,e] T2 ≡ T1.
#d #e #T1 #T2 #H elim H -H d e T1 T2 /2/
#i #d #e #Hdi #L >(minus_plus_m_m i e) in ⊢ (? ? ? ? ? %) /3/
qed.
(*
| subst_lref_O : ∀L,V1,V2,e. subst L V1 0 e V2 →
                 subst (L. 𝕓{Abbr} V1) #0 0 (e + 1) V2
| subst_lref_S : ∀L,I,V,i,T1,T2,d,e.
                 d ≤ i → i < d + e → subst L #i d e T1 → ↑[d,1] T2 ≡ T1 →
                 subst (L. 𝕓{I} V) #(i + 1) (d + 1) e T2
*)
(* The basic inversion lemmas ***********************************************)

lemma subst_inv_bind1_aux: ∀d,e,L,U1,U2. L ⊢ ↓[d, e] U1 ≡ U2 →
                           ∀I,V1,T1. U1 = 𝕓{I} V1. T1 →
                           ∃∃V2,T2. subst L V1 d e V2 & 
                                    subst (L. 𝕓{I} V1) T1 (d + 1) e T2 &
                                    U2 =  𝕓{I} V2. T2.
#d #e #L #U1 #U2 #H elim H -H d e L U1 U2
[ #L #k #d #e #I #V1 #T1 #H destruct
| #L #i #d #e #_ #I #V1 #T1 #H destruct
| #L #K #V #U1 #U2 #i #d #e #_ #_ #_ #_ #_ #_ #I #V1 #T1 #H destruct
| #L #i #d #e #_ #I #V1 #T1 #H destruct
| #L #J #V1 #V2 #T1 #T2 #d #e #HV12 #HT12 #_ #_ #I #V #T #H destruct /2 width=5/
| #L #J #V1 #V2 #T1 #T2 #d #e #_ #_ #_ #_ #I #V #T #H destruct
]
qed.

lemma subst_inv_bind1: ∀d,e,L,I,V1,T1,U2. L ⊢ ↓[d, e] 𝕓{I} V1. T1 ≡ U2 →
                       ∃∃V2,T2. subst L V1 d e V2 & 
                                subst (L. 𝕓{I} V1) T1 (d + 1) e T2 &
                                U2 =  𝕓{I} V2. T2.
/2/ qed.

lemma subst_inv_flat1_aux: ∀d,e,L,U1,U2. L ⊢ ↓[d, e] U1 ≡ U2 →
                           ∀I,V1,T1. U1 = 𝕗{I} V1. T1 →
                           ∃∃V2,T2. subst L V1 d e V2 & subst L T1 d e T2 &
                                    U2 =  𝕗{I} V2. T2.
#d #e #L #U1 #U2 #H elim H -H d e L U1 U2
[ #L #k #d #e #I #V1 #T1 #H destruct
| #L #i #d #e #_ #I #V1 #T1 #H destruct
| #L #K #V #U1 #U2 #i #d #e #_ #_ #_ #_ #_ #_ #I #V1 #T1 #H destruct
| #L #i #d #e #_ #I #V1 #T1 #H destruct
| #L #J #V1 #V2 #T1 #T2 #d #e #_ #_ #_ #_ #I #V #T #H destruct
| #L #J #V1 #V2 #T1 #T2 #d #e #HV12 #HT12 #_ #_ #I #V #T #H destruct /2 width=5/
]
qed.

lemma subst_inv_flat1: ∀d,e,L,I,V1,T1,U2. L ⊢ ↓[d, e] 𝕗{I} V1. T1 ≡ U2 →
                       ∃∃V2,T2. subst L V1 d e V2 & subst L T1 d e T2 &
                                U2 =  𝕗{I} V2. T2.
/2/ qed.
(*
lemma subst_inv_lref1_be_aux: ∀d,e,L,T,U. L ⊢ ↓[d, e] T ≡ U →
                              ∀i. d ≤ i → i < d + e → T = #i →
                              ∃∃K,V. ↑[0, i] K. 𝕓{Abbr} V ≡ L &
                                     K ⊢ ↓[d, d + e - i - 1] V ≡ U.
#d #e #L #T #U #H elim H -H d e L T U
[ #L #k #d #e #i #_ #_ #H destruct
| #L #j #d #e #Hid #i #Hdi #_ #H destruct -j;
  lapply (le_to_lt_to_lt … Hdi … Hid) -Hdi Hid #Hdd
  elim (lt_false … Hdd)
| #L #K #V #U #j #d #e #_ #_ #HLK #HVU #_ #i #Hdi #Hide #H destruct -j /2/
| #L #j #d #e #Hdei #i #_ #Hide #H destruct -j;
  lapply (le_to_lt_to_lt … Hdei … Hide) -Hdei Hide #Hdede
  elim (lt_false … Hdede)
| #L #I #V1 #V2 #T1 #T2 #d #e #_ #_ #_ #_ #i #_ #_ #H destruct
| #L #I #V1 #V2 #T1 #T2 #d #e #_ #_ #_ #_ #i #_ #_ #H destruct
]
qed.

lemma subst_inv_lref1_be: ∀d,e,i,L,U. L ⊢ ↓[d, e] #i ≡ U →
                          d ≤ i → i < d + e →
                          ∃∃K,V. ↑[0, i] K. 𝕓{Abbr} V ≡ L &
                                 K ⊢ ↓[d, d + e - i - 1] V ≡ U.
/2/ qed.
*)
