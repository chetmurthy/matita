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

include "Basic-2/grammar/lenv_length.ma".

(* LOCAL ENVIRONMENT EQUALITY ***********************************************)

inductive leq: lenv → nat → nat → lenv → Prop ≝
| leq_sort: ∀d,e. leq (⋆) d e (⋆)
| leq_OO:   ∀L1,L2. leq L1 0 0 L2
| leq_eq:   ∀L1,L2,I,V,e. leq L1 0 e L2 → leq (L1. 𝕓{I} V) 0 (e + 1) (L2.𝕓{I} V)
| leq_skip: ∀L1,L2,I1,I2,V1,V2,d,e.
            leq L1 d e L2 → leq (L1. 𝕓{I1} V1) (d + 1) e (L2. 𝕓{I2} V2)
.

interpretation "local environment equality" 'Eq L1 d e L2 = (leq L1 d e L2).

(* Basic properties *********************************************************)

lemma leq_refl: ∀d,e,L. L [d, e] ≈ L.
#d elim d -d
[ #e elim e -e // #e #IHe #L elim L -L /2/
| #d #IHd #e #L elim L -L /2/
]
qed.

lemma leq_sym: ∀L1,L2,d,e. L1 [d, e] ≈ L2 → L2 [d, e] ≈ L1.
#L1 #L2 #d #e #H elim H -H L1 L2 d e /2/
qed.

lemma leq_skip_lt: ∀L1,L2,d,e. L1 [d - 1, e] ≈ L2 → 0 < d →
                   ∀I1,I2,V1,V2. L1. 𝕓{I1} V1 [d, e] ≈ L2. 𝕓{I2} V2.

#L1 #L2 #d #e #HL12 #Hd >(plus_minus_m_m d 1) /2/
qed.

(* Basic inversion lemmas ***************************************************)
