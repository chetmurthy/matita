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

include "basics/logic.ma".
include "ground_2/xoa_notation.ma".
include "ground_2/xoa.ma".

interpretation "logical false" 'false = False.

interpretation "logical true" 'true = True.

lemma ex2_1_comm: ∀A0. ∀P0,P1:A0→Prop. (∃∃x0. P0 x0 & P1 x0) → ∃∃x0. P1 x0 & P0 x0.
#A0 #P0 #P1 * /2 width=3/
qed.
