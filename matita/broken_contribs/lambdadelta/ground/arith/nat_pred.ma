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

include "ground/notation/functions/downspoon_1.ma".
include "ground/arith/nat_split.ma".
include "ground/arith/nat_ppred.ma".

(* PREDECESSOR FOR NON-NEGATIVE INTEGERS ************************************)

(*** pred *)
definition npred (m): ℕ ≝
           nsplit … (𝟎) pnpred m.

interpretation
  "predecessor (non-negative integers)"
  'DownSpoon m = (npred m).

(* Basic constructions ******************************************************)

(*** pred_O *)
lemma npred_zero: 𝟎 = ⫰𝟎.
// qed.

lemma npred_inj (p): ↓p = ⫰(npos p).
// qed.

(* Basic inversions *********************************************************)

(*** pred_inv_fix_sn *)
lemma npred_inv_refl (n): n = ⫰n → 𝟎 = n.
* // #p #H0 elim (pnpred_inv_refl … H0)
qed-.
