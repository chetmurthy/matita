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

include "basic_2/substitution/csup.ma".
include "basic_2/computation/yprs.ma".

(* ITERATED STEP OF HYPER PARALLEL COMPUTATION ON CLOSURES ******************)

inductive ysteps (h) (g) (L1) (T1) (L2) (T2): Prop ≝
| ysteps_intro: h ⊢ ⦃L1, T1⦄ •⥸*[g] ⦃L2, T2⦄ → (L1 = L2 → T1 = T2 → ⊥) →
                ysteps h g L1 T1 L2 T2
.

interpretation "iterated step of hyper parallel computation (closure)"
   'YPRedStepStar h g L1 T1 L2 T2 = (ysteps h g L1 T1 L2 T2).

(* Basic properties *********************************************************)

lemma ssta_ysteps: ∀h,g,L,T,U,l. ⦃h, L⦄ ⊢ T •[g, l + 1] U →
                   h ⊢ ⦃L, T⦄ •⭃*[g] ⦃L, U⦄.
#h #g #L #T #U #l #HTU
@ysteps_intro /3 width=2/ #_ #H destruct
elim (ssta_inv_refl … HTU)
qed.

lemma csup_ysteps: ∀h,g,L1,L2,T1,T2. ⦃L1, T1⦄ > ⦃L2, T2⦄ →
                   h ⊢ ⦃L1, T1⦄ •⭃*[g] ⦃L2, T2⦄.
#h #g #L1 #L2 #T1 #T2 #H
lapply (csup_fwd_cw … H) #H1
@ysteps_intro /3 width=1/ -H #H2 #H3 destruct
elim (lt_refl_false … H1)
qed.
