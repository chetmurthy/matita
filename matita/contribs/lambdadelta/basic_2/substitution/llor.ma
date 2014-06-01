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

include "basic_2/notation/relations/lazyor_4.ma".
include "basic_2/substitution/frees.ma".

(* POINTWISE UNION FOR LOCAL ENVIRONMENTS ***********************************)

definition llor: relation4 term lenv lenv lenv ≝ λT,L2,L1,L.
                 ∧∧ |L1| ≤ |L2| & |L1| = |L|
                  & (∀I1,I2,I,K1,K2,K,V1,V2,V,i.
                       ⇩[i] L1 ≡ K1.ⓑ{I1}V1 → ⇩[i] L2 ≡ K2.ⓑ{I2}V2 → ⇩[i] L ≡ K.ⓑ{I}V →
                       (∧∧ (L1 ⊢ i ϵ 𝐅*[yinj 0]⦃T⦄ → ⊥) & I1 = I & V1 = V) ∨
                       (∧∧ L1 ⊢ i ϵ 𝐅*[yinj 0]⦃T⦄  & I1 = I & V2 = V)
                    ).

interpretation
   "lazy union (local environment)"
   'LazyOr L1 T L2 L = (llor T L2 L1 L).

(* Basic properties *********************************************************)

lemma llor_atom: ∀T,L2. ⋆ ⩖[T] L2 ≡ ⋆.
#T #L2 @and3_intro //
#I1 #I2 #I #K1 #K2 #K #V1 #V2 #V #i #HLK1
elim (ldrop_inv_atom1 … HLK1) -HLK1 #H destruct
qed.
