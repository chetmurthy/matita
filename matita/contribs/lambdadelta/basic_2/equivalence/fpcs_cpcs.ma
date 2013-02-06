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

include "basic_2/computation/fprs_cprs.ma".
include "basic_2/equivalence/cpcs_cpcs.ma".
include "basic_2/equivalence/fpcs_fpcs.ma".

(* CONTEXT-FREE PARALLEL EQUIVALENCE ON CLOSURES ****************************)

(* Advanced properties ******************************************************)

lemma fpcs_shift: ∀I,L1,L2,V1,V2,T1,T2. ⦃L1.ⓑ{I}V1, T1⦄ ⬌* ⦃L2.ⓑ{I}V2, T2⦄ →
                     ⦃L1, -ⓑ{I}V1.T1⦄ ⬌* ⦃L2, -ⓑ{I}V2.T2⦄.
#I #L1 #L2 #V1 #V2 #T1 #T2 #H12
elim (fpcs_inv_fprs … H12) -H12 #L #T #H1 #H2
elim (fprs_inv_pair1 … H1) -H1 #K1 #U1 #_ #HTU1 #H destruct
elim (fprs_inv_pair1 … H2) -H2 #K2 #U2 #_ #HTU2 #H destruct /2 width=4/
qed.

lemma fpcs_bind_minus: ∀I,L1,L2,V1,V2,T1,T2. ⦃L1, -ⓑ{I}V1.T1⦄ ⬌* ⦃L2, -ⓑ{I}V2.T2⦄ →
                       ∀b. ⦃L1, ⓑ{b,I}V1.T1⦄ ⬌* ⦃L2, ⓑ{b,I}V2.T2⦄.
#I #L1 #L2 #V1 #V2 #T1 #T2 #H12 #b
elim (fpcs_inv_fprs … H12) -H12 #L #T #H1 #H2
elim (fprs_fwd_bind2_minus … H1 b) -H1 #W1 #U1 #HTU1 #H destruct
elim (fprs_fwd_bind2_minus … H2 b) -H2 #W2 #U2 #HTU2 #H destruct /2 width=4/
qed.

lemma fpcs_shift_full: ∀I,L1,L2,V1,V2,T1,T2. ⦃L1.ⓑ{I}V1, T1⦄ ⬌* ⦃L2.ⓑ{I}V2, T2⦄ →
                       ∀b. ⦃L1, ⓑ{b,I}V1.T1⦄ ⬌* ⦃L2, ⓑ{b,I}V2.T2⦄.
/3 width=1/ qed.

(* Properties on context-sensitive parallel equivalence for terms ***********)

lemma cpcs_fpcs: ∀L,T1,T2. L ⊢ T1 ⬌* T2 → ⦃L, T1⦄ ⬌* ⦃L, T2⦄.
#L #T1 #T2 #H
elim (cpcs_inv_cprs … H) -H /3 width=4 by fprs_div, cprs_fprs/ (**) (* too slow without trace *)
qed.

(* Inversion lemmas on context-sensitive parallel equivalence for terms *****)

lemma fpcs_inv_cpcs: ∀L,T1,T2. ⦃L, T1⦄ ⬌* ⦃L, T2⦄ → L ⊢ T1 ⬌* T2.
#L #T1 #T2 #H
elim (fpcs_inv_fprs … H) -H /3 width=4 by cprs_div, fprs_fwd_cprs/
qed-.
