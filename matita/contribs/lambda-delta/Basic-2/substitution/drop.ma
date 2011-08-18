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

include "Basic-2/substitution/leq.ma".
include "Basic-2/substitution/lift.ma".

(* DROPPING *****************************************************************)

inductive drop: lenv → nat → nat → lenv → Prop ≝
| drop_sort: ∀d,e. drop (⋆) d e (⋆)
| drop_comp: ∀L1,L2,I,V. drop L1 0 0 L2 → drop (L1. 𝕓{I} V) 0 0 (L2. 𝕓{I} V)
| drop_drop: ∀L1,L2,I,V,e. drop L1 0 e L2 → drop (L1. 𝕓{I} V) 0 (e + 1) L2
| drop_skip: ∀L1,L2,I,V1,V2,d,e.
             drop L1 d e L2 → ↑[d,e] V2 ≡ V1 →
             drop (L1. 𝕓{I} V1) (d + 1) e (L2. 𝕓{I} V2)
.

interpretation "dropping" 'RDrop L1 d e L2 = (drop L1 d e L2).

(* Basic inversion lemmas ***************************************************)

lemma drop_inv_refl_aux: ∀d,e,L1,L2. ↓[d, e] L1 ≡ L2 → d = 0 → e = 0 → L1 = L2.
#d #e #L1 #L2 #H elim H -H d e L1 L2
[ //
| #L1 #L2 #I #V #_ #IHL12 #H1 #H2
  >(IHL12 H1 H2) -IHL12 H1 H2 L1 //
| #L1 #L2 #I #V #e #_ #_ #_ #H
  elim (plus_S_eq_O_false … H)
| #L1 #L2 #I #V1 #V2 #d #e #_ #_ #_ #H
  elim (plus_S_eq_O_false … H)
]
qed.

lemma drop_inv_refl: ∀L1,L2. ↓[0, 0] L1 ≡ L2 → L1 = L2.
/2 width=5/ qed.

lemma drop_inv_sort1_aux: ∀d,e,L1,L2. ↓[d, e] L1 ≡ L2 → L1 = ⋆ →
                          L2 = ⋆.
#d #e #L1 #L2 * -d e L1 L2
[ //
| #L1 #L2 #I #V #_ #H destruct
| #L1 #L2 #I #V #e #_ #H destruct
| #L1 #L2 #I #V1 #V2 #d #e #_ #_ #H destruct
]
qed.

lemma drop_inv_sort1: ∀d,e,L2. ↓[d, e] ⋆ ≡ L2 → L2 = ⋆.
/2 width=5/ qed.

lemma drop_inv_O1_aux: ∀d,e,L1,L2. ↓[d, e] L1 ≡ L2 → d = 0 →
                       ∀K,I,V. L1 = K. 𝕓{I} V → 
                       (e = 0 ∧ L2 = K. 𝕓{I} V) ∨
                       (0 < e ∧ ↓[d, e - 1] K ≡ L2).
#d #e #L1 #L2 * -d e L1 L2
[ #d #e #_ #K #I #V #H destruct
| #L1 #L2 #I #V #HL12 #H #K #J #W #HX destruct -L1 I V
  >(drop_inv_refl … HL12) -HL12 K /3/
| #L1 #L2 #I #V #e #HL12 #_ #K #J #W #H destruct -L1 I V /3/
| #L1 #L2 #I #V1 #V2 #d #e #_ #_ #H elim (plus_S_eq_O_false … H)
]
qed.

lemma drop_inv_O1: ∀e,K,I,V,L2. ↓[0, e] K. 𝕓{I} V ≡ L2 →
                   (e = 0 ∧ L2 = K. 𝕓{I} V) ∨
                   (0 < e ∧ ↓[0, e - 1] K ≡ L2).
/2/ qed.

lemma drop_inv_drop1: ∀e,K,I,V,L2.
                      ↓[0, e] K. 𝕓{I} V ≡ L2 → 0 < e → ↓[0, e - 1] K ≡ L2.
#e #K #I #V #L2 #H #He
elim (drop_inv_O1 … H) -H * // #H destruct -e;
elim (lt_refl_false … He)
qed.

lemma drop_inv_skip1_aux: ∀d,e,L1,L2. ↓[d, e] L1 ≡ L2 → 0 < d →
                          ∀I,K1,V1. L1 = K1. 𝕓{I} V1 →
                          ∃∃K2,V2. ↓[d - 1, e] K1 ≡ K2 &
                                   ↑[d - 1, e] V2 ≡ V1 & 
                                   L2 = K2. 𝕓{I} V2.
#d #e #L1 #L2 * -d e L1 L2
[ #d #e #_ #I #K #V #H destruct
| #L1 #L2 #I #V #_ #H elim (lt_refl_false … H)
| #L1 #L2 #I #V #e #_ #H elim (lt_refl_false … H)
| #X #L2 #Y #Z #V2 #d #e #HL12 #HV12 #_ #I #L1 #V1 #H destruct -X Y Z
  /2 width=5/
]
qed.

lemma drop_inv_skip1: ∀d,e,I,K1,V1,L2. ↓[d, e] K1. 𝕓{I} V1 ≡ L2 → 0 < d →
                      ∃∃K2,V2. ↓[d - 1, e] K1 ≡ K2 &
                               ↑[d - 1, e] V2 ≡ V1 & 
                               L2 = K2. 𝕓{I} V2.
/2/ qed.

lemma drop_inv_skip2_aux: ∀d,e,L1,L2. ↓[d, e] L1 ≡ L2 → 0 < d →
                          ∀I,K2,V2. L2 = K2. 𝕓{I} V2 →
                          ∃∃K1,V1. ↓[d - 1, e] K1 ≡ K2 &
                                   ↑[d - 1, e] V2 ≡ V1 & 
                                   L1 = K1. 𝕓{I} V1.
#d #e #L1 #L2 * -d e L1 L2
[ #d #e #_ #I #K #V #H destruct
| #L1 #L2 #I #V #_ #H elim (lt_refl_false … H)
| #L1 #L2 #I #V #e #_ #H elim (lt_refl_false … H)
| #L1 #X #Y #V1 #Z #d #e #HL12 #HV12 #_ #I #L2 #V2 #H destruct -X Y Z
  /2 width=5/
]
qed.

lemma drop_inv_skip2: ∀d,e,I,L1,K2,V2. ↓[d, e] L1 ≡ K2. 𝕓{I} V2 → 0 < d →
                      ∃∃K1,V1. ↓[d - 1, e] K1 ≡ K2 & ↑[d - 1, e] V2 ≡ V1 &
                               L1 = K1. 𝕓{I} V1.
/2/ qed.

(* Basic properties *********************************************************)

lemma drop_refl: ∀L. ↓[0, 0] L ≡ L.
#L elim L -L /2/
qed.

lemma drop_drop_lt: ∀L1,L2,I,V,e.
                    ↓[0, e - 1] L1 ≡ L2 → 0 < e → ↓[0, e] L1. 𝕓{I} V ≡ L2.
#L1 #L2 #I #V #e #HL12 #He >(plus_minus_m_m e 1) /2/
qed.

lemma drop_leq_drop1: ∀L1,L2,d,e. L1 [d, e] ≈ L2 →
                      ∀I,K1,V,i. ↓[0, i] L1 ≡ K1. 𝕓{I} V →
                      d ≤ i → i < d + e →
                      ∃∃K2. K1 [0, d + e - i - 1] ≈ K2 &
                            ↓[0, i] L2 ≡ K2. 𝕓{I} V.
#L1 #L2 #d #e #H elim H -H L1 L2 d e
[ #d #e #I #K1 #V #i #H
  lapply (drop_inv_sort1 … H) -H #H destruct
| #L1 #L2 #I1 #I2 #V1 #V2 #_ #_ #I #K1 #V #i #_ #_ #H
  elim (lt_zero_false … H)
| #L1 #L2 #I #V #e #HL12 #IHL12 #J #K1 #W #i #H #_ #Hie
  elim (drop_inv_O1 … H) -H * #Hi #HLK1
  [ -IHL12 Hie; destruct -i K1 J W;
    <minus_n_O <minus_plus_m_m /2/
  | -HL12;
    elim (IHL12 … HLK1 ? ?) -IHL12 HLK1 // [2: /2/ ] -Hie >arith_g1 // /3/
  ]
| #L1 #L2 #I1 #I2 #V1 #V2 #d #e #_ #IHL12 #I #K1 #V #i #H #Hdi >plus_plus_comm_23 #Hide
  lapply (plus_S_le_to_pos … Hdi) #Hi
  lapply (drop_inv_drop1 … H ?) -H // #HLK1
  elim (IHL12 … HLK1 ? ?) -IHL12 HLK1 [2: /2/ |3: /2/ ] -Hdi Hide >arith_g1 // /3/
]
qed.

(* Basic forvard lemmas *****************************************************)

lemma drop_fwd_drop2: ∀L1,I2,K2,V2,e. ↓[O, e] L1 ≡ K2. 𝕓{I2} V2 →
                      ↓[O, e + 1] L1 ≡ K2.
#L1 elim L1 -L1
[ #I2 #K2 #V2 #e #H lapply (drop_inv_sort1 … H) -H #H destruct
| #K1 #I1 #V1 #IHL1 #I2 #K2 #V2 #e #H
  elim (drop_inv_O1 … H) -H * #He #H
  [ -IHL1; destruct -e K2 I2 V2 /2/
  | @drop_drop >(plus_minus_m_m e 1) /2/
  ]
]
qed.

lemma drop_fwd_drop2_length: ∀L1,I2,K2,V2,e. 
                             ↓[0, e] L1 ≡ K2. 𝕓{I2} V2 → e < |L1|.
#L1 elim L1 -L1
[ #I2 #K2 #V2 #e #H lapply (drop_inv_sort1 … H) -H #H destruct
| #K1 #I1 #V1 #IHL1 #I2 #K2 #V2 #e #H
  elim (drop_inv_O1 … H) -H * #He #H
  [ -IHL1; destruct -e K2 I2 V2 //
  | lapply (IHL1 … H) -IHL1 H #HeK1 whd in ⊢ (? ? %) /2/
  ]
]
qed.

lemma drop_fwd_O1_length: ∀L1,L2,e. ↓[0, e] L1 ≡ L2 → |L2| = |L1| - e.
#L1 elim L1 -L1
[ #L2 #e #H >(drop_inv_sort1 … H) -H //
| #K1 #I1 #V1 #IHL1 #L2 #e #H
  elim (drop_inv_O1 … H) -H * #He #H
  [ -IHL1; destruct -e L2 //
  | lapply (IHL1 … H) -IHL1 H #H >H -H; normalize
    >minus_le_minus_minus_comm //
  ]
]
qed.
