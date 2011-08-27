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

include "Basic-2/grammar/term_simple.ma".

(* HOMOMORPHIC TERMS ********************************************************)

inductive thom: term → term → Prop ≝
   | thom_sort: ∀k. thom (⋆k) (⋆k)
   | thom_lref: ∀i. thom (#i) (#i)
   | thom_abst: ∀V1,V2,T1,T2. thom (𝕚{Abst} V1. T1) (𝕚{Abst} V2. T2)
   | thom_appl: ∀V1,V2,T1,T2. thom T1 T2 → 𝕊[T1] → 𝕊[T2] →
                thom (𝕚{Appl} V1. T1) (𝕚{Appl} V2. T2)
.

interpretation "homomorphic (term)" 'napart T1 T2 = (thom T1 T2).

(* Basic properties *********************************************************)

lemma thom_sym: ∀T1,T2. T1 ≈ T2 → T2 ≈ T1.
#T1 #T2 #H elim H -H T1 T2 /2/
qed.

lemma thom_refl2: ∀T1,T2. T1 ≈ T2 → T2 ≈ T2.
#T1 #T2 #H elim H -H T1 T2 /2/
qed.

lemma thom_refl1: ∀T1,T2. T1 ≈ T2 → T1 ≈ T1.
/3/ qed.

lemma simple_thom_repl_dx: ∀T1,T2. T1 ≈ T2 → 𝕊[T1] → 𝕊[T2].
#T1 #T2 #H elim H -H T1 T2 //
#V1 #V2 #T1 #T2 #H
elim (simple_inv_bind … H)
qed.

lemma simple_thom_repl_sn: ∀T1,T2. T1 ≈ T2 → 𝕊[T2] → 𝕊[T1].
/3/ qed.

(* Basic inversion lemmas ***************************************************)
