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

include "basic_2/notation/relations/cofreestar_4.ma".
include "basic_2/relocation/lift_neg.ma".
include "basic_2/substitution/cpys.ma".

(* CONTEXT-SENSITIVE EXCLUSION FROM FREE VARIABLES **************************)

definition cofrees: relation4 ynat nat lenv term ≝
                    λd,i,L,U1. ∀U2. ⦃⋆, L⦄ ⊢ U1 ▶*[d, ∞] U2 → ∃T2. ⇧[i, 1] T2 ≡ U2.

interpretation
   "context-sensitive exclusion from free variables (term)"
   'CoFreeStar L i d T = (cofrees d i L T).

(* Basic inversion lemmas ***************************************************)

lemma cofrees_inv_gen: ∀L,U,U0,d,i. ⦃⋆, L⦄ ⊢ U ▶*[d, ∞] U0 → (∀T. ⇧[i, 1] T ≡ U0 → ⊥) →
                       L ⊢ i ~ϵ 𝐅*[d]⦃U⦄ → ⊥.
#L #U #U0 #d #i #HU0 #HnU0 #HU elim (HU … HU0) -L -U -d /2 width=2 by/
qed-.

lemma cofrees_inv_lref_eq: ∀L,d,i. L ⊢ i ~ϵ 𝐅*[d]⦃#i⦄ → ⊥.
#L #d #i #H elim (H (#i)) -H //
#X #H elim (lift_inv_lref2_be … H) -H //
qed-. 

(* Basic forward lemmas *****************************************************)

lemma cofrees_fwd_lift: ∀L,U,d,i. L ⊢ i ~ϵ 𝐅*[d]⦃U⦄ → ∃T. ⇧[i, 1] T ≡ U.
/2 width=1 by/ qed-.

lemma cofrees_fwd_nlift: ∀L,U,d,i. (∀T. ⇧[i, 1] T ≡ U → ⊥) → (L ⊢ i ~ϵ 𝐅*[d]⦃U⦄ → ⊥).
#L #U #d #i #HnTU #H elim (cofrees_fwd_lift … H) -H /2 width=2 by/
qed-.

(* Basic Properties *********************************************************)

lemma cofrees_sort: ∀L,d,i,k. L ⊢ i ~ϵ 𝐅*[d]⦃⋆k⦄.
#L #d #i #k #X #H >(cpys_inv_sort1 … H) -X /2 width=2 by ex_intro/
qed.

lemma cofrees_gref: ∀L,d,i,p. L ⊢ i ~ϵ 𝐅*[d]⦃§p⦄.
#L #d #i #p #X #H >(cpys_inv_gref1 … H) -X /2 width=2 by ex_intro/
qed.

lemma cofrees_bind: ∀L,V,d,i. L ⊢ i ~ϵ 𝐅*[d] ⦃V⦄ →
                    ∀I,T. L.ⓑ{I}V ⊢ i+1 ~ϵ 𝐅*[⫯d]⦃T⦄ →
                    ∀a. L ⊢ i ~ϵ 𝐅*[d]⦃ⓑ{a,I}V.T⦄.
#L #W1 #d #i #HW1 #I #U1 #HU1 #a #X #H elim (cpys_inv_bind1 … H) -H
#W2 #U2 #HW12 #HU12 #H destruct
elim (HW1 … HW12) elim (HU1 … HU12) -W1 -U1 /3 width=2 by lift_bind, ex_intro/
qed.

lemma cofrees_flat: ∀L,V,d,i. L ⊢ i ~ϵ 𝐅*[d]⦃V⦄ → ∀T. L ⊢ i ~ϵ 𝐅*[d]⦃T⦄ →
                    ∀I. L ⊢ i ~ϵ 𝐅*[d]⦃ⓕ{I}V.T⦄.
#L #W1 #d #i #HW1 #U1 #HU1 #I #X #H elim (cpys_inv_flat1 … H) -H
#W2 #U2 #HW12 #HU12 #H destruct
elim (HW1 … HW12) elim (HU1 … HU12) -W1 -U1 /3 width=2 by lift_flat, ex_intro/
qed.

axiom cofrees_dec: ∀L,T,d,i. Decidable (L ⊢ i ~ϵ 𝐅*[d]⦃T⦄).

(* Negated inversion lemmas *************************************************)

lemma frees_inv_bind: ∀a,I,L,V,T,d,i. (L ⊢ i ~ϵ 𝐅*[d]⦃ⓑ{a,I}V.T⦄ → ⊥) →
                      (L ⊢ i ~ϵ 𝐅*[d]⦃V⦄ → ⊥) ∨ (L.ⓑ{I}V ⊢ i+1 ~ϵ 𝐅*[⫯d]⦃T⦄ → ⊥).
#a #I #L #W #U #d #i #H elim (cofrees_dec L W d i)
/4 width=9 by cofrees_bind, or_intror, or_introl/
qed-.

lemma frees_inv_flat: ∀I,L,V,T,d,i. (L ⊢ i ~ϵ 𝐅*[d]⦃ⓕ{I}V.T⦄ → ⊥) →
                      (L ⊢ i ~ϵ 𝐅*[d]⦃V⦄ → ⊥) ∨ (L ⊢ i ~ϵ 𝐅*[d]⦃T⦄ → ⊥).
#I #L #W #U #d #H elim (cofrees_dec L W d)
/4 width=8 by cofrees_flat, or_intror, or_introl/
qed-.
