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
include "basic_2/reducibility/xpr.ma".

(* HYPER PARALLEL REDUCTION ON CLOSURES *************************************)

inductive ypr (h) (g) (L1) (T1): relation2 lenv term ≝
| ypr_cpr : ∀T2. L1 ⊢ T1 ➡ T2 → ypr h g L1 T1 L1 T2
| ypr_ssta: ∀T2,l. ⦃h, L1⦄ ⊢ T1 •[g, l + 1] T2 → ypr h g L1 T1 L1 T2
| ypr_csup: ∀L2,T2. ⦃L1, T1⦄ > ⦃L2, T2⦄ → ypr h g L1 T1 L2 T2
. 

interpretation
   "hyper parallel reduction (closure)"
   'YPRed h g L1 T1 L2 T2 = (ypr h g L1 T1 L2 T2).

(* Basic properties *********************************************************)

lemma ypr_refl: ∀h,g. bi_reflexive … (ypr h g).
/2 width=1/ qed.

lemma xpr_ypr: ∀h,g,L,T1,T2. ⦃h, L⦄ ⊢ T1 •➡[g] T2 → h ⊢ ⦃L, T1⦄ •⥸[g] ⦃L, T2⦄.
#h #g #L #T1 #T2 * /2 width=1/ /2 width=2/
qed.
