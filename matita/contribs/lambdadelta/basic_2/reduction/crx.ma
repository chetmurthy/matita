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

include "basic_2/static/sd.ma".
include "basic_2/reduction/crr.ma".

(* CONTEXT-SENSITIVE EXTENDED REDUCIBLE TERMS *******************************)

(* extended reducible terms *)
inductive crx (h) (g): lenv → predicate term ≝
| crx_sort   : ∀L,k,l. deg h g k (l+1) → crx h g L (⋆k)
| crx_delta  : ∀I,L,K,V,i. ⇩[0, i] L ≡ K.ⓑ{I}V → crx h g L (#i)
| crx_appl_sn: ∀L,V,T. crx h g L V → crx h g L (ⓐV.T)
| crx_appl_dx: ∀L,V,T. crx h g L T → crx h g L (ⓐV.T)
| crx_ri2    : ∀I,L,V,T. ri2 I → crx h g L (②{I}V.T)
| crx_ib2_sn : ∀a,I,L,V,T. ib2 a I → crx h g L V → crx h g L (ⓑ{a,I}V.T)
| crx_ib2_dx : ∀a,I,L,V,T. ib2 a I → crx h g (L.ⓑ{I}V) T → crx h g L (ⓑ{a,I}V.T)
| crx_beta   : ∀a,L,V,W,T. crx h g L (ⓐV. ⓛ{a}W.T)
| crx_theta  : ∀a,L,V,W,T. crx h g L (ⓐV. ⓓ{a}W.T)
.

interpretation
   "context-sensitive extended reducibility (term)"
   'Reducible h g L T = (crx h g L T).

(* Basic properties *********************************************************)

lemma crr_crx: ∀h,g,L,T. L ⊢ 𝐑⦃T⦄ → ⦃h, L⦄ ⊢ 𝐑[g]⦃T⦄.
#h #g #L #T #H elim H -L -T // /2 width=1/ /2 width=4/
qed.

(* Basic inversion lemmas ***************************************************)

fact crx_inv_sort_aux: ∀h,g,L,T,k. ⦃h, L⦄ ⊢ 𝐑[g]⦃T⦄ → T = ⋆k →
                       ∃l. deg h g k (l+1).
#h #g #L #T #k0 * -L -T
[ #L #k #l #Hkl #H destruct /2 width=2/
| #I #L #K #V #i #HLK #H destruct
| #L #V #T #_ #H destruct
| #L #V #T #_ #H destruct
| #I #L #V #T #_ #H destruct
| #a #I #L #V #T #_ #_ #H destruct
| #a #I #L #V #T #_ #_ #H destruct
| #a #L #V #W #T #H destruct
| #a #L #V #W #T #H destruct
]
qed-.

lemma crx_inv_sort: ∀h,g,L,k. ⦃h, L⦄ ⊢ 𝐑[g]⦃⋆k⦄ → ∃l. deg h g k (l+1).
/2 width=4 by crx_inv_sort_aux/ qed-.

fact crx_inv_lref_aux: ∀h,g,L,T,i. ⦃h, L⦄ ⊢ 𝐑[g]⦃T⦄ → T = #i →
                       ∃∃I,K,V. ⇩[0, i] L ≡ K.ⓑ{I}V.
#h #g #L #T #j * -L -T
[ #L #k #l #_ #H destruct
| #I #L #K #V #i #HLK #H destruct /2 width=4/
| #L #V #T #_ #H destruct
| #L #V #T #_ #H destruct
| #I #L #V #T #_ #H destruct
| #a #I #L #V #T #_ #_ #H destruct
| #a #I #L #V #T #_ #_ #H destruct
| #a #L #V #W #T #H destruct
| #a #L #V #W #T #H destruct
]
qed-.

lemma crx_inv_lref: ∀h,g,L,i. ⦃h, L⦄ ⊢ 𝐑[g]⦃#i⦄ → ∃∃I,K,V. ⇩[0, i] L ≡ K.ⓑ{I}V.
/2 width=5 by crx_inv_lref_aux/ qed-.

fact crx_inv_gref_aux: ∀h,g,L,T,p. ⦃h, L⦄ ⊢ 𝐑[g]⦃T⦄ → T = §p → ⊥.
#h #g #L #T #q * -L -T
[ #L #k #l #_ #H destruct
| #I #L #K #V #i #HLK #H destruct
| #L #V #T #_ #H destruct
| #L #V #T #_ #H destruct
| #I #L #V #T #_ #H destruct
| #a #I #L #V #T #_ #_ #H destruct
| #a #I #L #V #T #_ #_ #H destruct
| #a #L #V #W #T #H destruct
| #a #L #V #W #T #H destruct
]
qed-.

lemma crx_inv_gref: ∀h,g,L,p. ⦃h, L⦄ ⊢ 𝐑[g]⦃§p⦄ → ⊥.
/2 width=7 by crx_inv_gref_aux/ qed-.

lemma trx_inv_atom: ∀h,g,I. ⦃h, ⋆⦄ ⊢ 𝐑[g]⦃⓪{I}⦄ →
                    ∃∃k,l. deg h g k (l+1) & I = Sort k.
#h #g * #i #H
[ elim (crx_inv_sort … H) -H /2 width=4/
| elim (crx_inv_lref … H) -H #I #L #V #H
  elim (ldrop_inv_atom1 … H) -H #H destruct
| elim (crx_inv_gref … H)
]
qed-.

fact crx_inv_ib2_aux: ∀h,g,a,I,L,W,U,T. ib2 a I → ⦃h, L⦄ ⊢ 𝐑[g]⦃T⦄ →
                      T = ⓑ{a,I}W.U → ⦃h, L⦄ ⊢ 𝐑[g]⦃W⦄ ∨ ⦃h, L.ⓑ{I}W⦄ ⊢ 𝐑[g]⦃U⦄.
#h #g #b #J #L #W0 #U #T #HI * -L -T
[ #L #k #l #_ #H destruct
| #I #L #K #V #i #_ #H destruct
| #L #V #T #_ #H destruct
| #L #V #T #_ #H destruct
| #I #L #V #T #H1 #H2 destruct
  elim H1 -H1 #H destruct
  elim HI -HI #H destruct
| #a #I #L #V #T #_ #HV #H destruct /2 width=1/
| #a #I #L #V #T #_ #HT #H destruct /2 width=1/
| #a #L #V #W #T #H destruct
| #a #L #V #W #T #H destruct
]
qed-.

lemma crx_inv_ib2: ∀h,g,a,I,L,W,T. ib2 a I → ⦃h, L⦄ ⊢ 𝐑[g]⦃ⓑ{a,I}W.T⦄ →
                   ⦃h, L⦄ ⊢ 𝐑[g]⦃W⦄ ∨ ⦃h, L.ⓑ{I}W⦄ ⊢ 𝐑[g]⦃T⦄.
/2 width=5 by crx_inv_ib2_aux/ qed-.

fact crx_inv_appl_aux: ∀h,g,L,W,U,T. ⦃h, L⦄ ⊢ 𝐑[g]⦃T⦄ → T = ⓐW.U →
                       ∨∨ ⦃h, L⦄ ⊢ 𝐑[g]⦃W⦄ | ⦃h, L⦄ ⊢ 𝐑[g]⦃U⦄ | (𝐒⦃U⦄ → ⊥).
#h #g #L #W0 #U #T * -L -T
[ #L #k #l #_ #H destruct
| #I #L #K #V #i #_ #H destruct
| #L #V #T #HV #H destruct /2 width=1/
| #L #V #T #HT #H destruct /2 width=1/
| #I #L #V #T #H1 #H2 destruct
  elim H1 -H1 #H destruct
| #a #I #L #V #T #_ #_ #H destruct
| #a #I #L #V #T #_ #_ #H destruct
| #a #L #V #W #T #H destruct
  @or3_intro2 #H elim (simple_inv_bind … H)
| #a #L #V #W #T #H destruct
  @or3_intro2 #H elim (simple_inv_bind … H)
]
qed-.

lemma crx_inv_appl: ∀h,g,L,V,T. ⦃h, L⦄ ⊢ 𝐑[g]⦃ⓐV.T⦄ →
                    ∨∨ ⦃h, L⦄ ⊢ 𝐑[g]⦃V⦄ | ⦃h, L⦄ ⊢ 𝐑[g]⦃T⦄ | (𝐒⦃T⦄ → ⊥).
/2 width=3 by crx_inv_appl_aux/ qed-.
