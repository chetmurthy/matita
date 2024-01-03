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

include "ground/arith/nat_le_pred.ma".
include "ground/arith/nat_lt.ma".

(* STRICT ORDER FOR NON-NEGATIVE INTEGERS ***********************************)

(* Destructions with npred **************************************************)

(*** S_pred lt_succ_pred lt_inv_O1 *)
lemma nlt_des_gen (m) (n): m < n → n ϵ 𝐏.
#m #n @(nat_ind_succ … n) -n //
#H elim (nlt_inv_zero_dx … H)
qed-.

(* Inversions with npred ****************************************************)

(*** lt_inv_gen *)
lemma nlt_inv_gen (m) (n): m < n → ∧∧ m ≤ ⫰n & n ϵ 𝐏.
/2 width=1 by nle_inv_succ_sn/ qed-.

(*** lt_inv_S1 *)
lemma nlt_inv_succ_sn (m) (n): (⁤↑m) < n → ∧∧ m < ⫰n & n ϵ 𝐏.
/2 width=1 by nle_inv_succ_sn/ qed-.

lemma nlt_inv_pred_dx (m) (n): m < ⫰n → (⁤↑m) < n.
#m #n #H >(nlt_des_gen (𝟎) n)
[ /2 width=1 by nlt_succ_bi/
| /3 width=3 by nle_nlt_trans, nlt_nle_trans/
]
qed-.

lemma nlt_inv_pred_bi (m) (n):
      (⫰m) < ⫰n → m < n.
/3 width=3 by nlt_inv_pred_dx, nle_nlt_trans/
qed-.

(* Constructions with npred *************************************************)

lemma nlt_zero_sn (n): n ϵ 𝐏 → 𝟎 < n.
// qed.

(*** monotonic_lt_pred *)
lemma nlt_pred_bi (m) (n): 𝟎 < m → m < n → ⫰m < ⫰n.
#m #n #Hm #Hmn
@nle_inv_succ_bi
<(nlt_des_gen … Hm) -Hm
<(nlt_des_gen … Hmn) //
qed.
