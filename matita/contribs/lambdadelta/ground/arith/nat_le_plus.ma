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

include "ground/arith/nat_plus.ma".
include "ground/arith/nat_le.ma".

(* ORDER FOR NON-NEGATIVE INTEGERS ****************************************************)

(* Constructions with nplus ***********************************************************)

(*** monotonic_le_plus_l *)
lemma nle_plus_bi_dx (m) (n1) (n2): n1 ≤ n2 → n1 + m ≤ n2 + m.
#m #n1 #n2 #H elim H -n2 /2 width=3 by nle_trans/
qed.

(*** monotonic_le_plus_r *)
lemma nle_plus_bi_sn (m) (n1) (n2): n1 ≤ n2 → m + n1 ≤ m + n2.
#m #n1 #n2 #H <nplus_comm <nplus_comm in ⊢ (??%);
/2 width=1 by nle_plus_bi_dx/
qed.

(*** le_plus_n_r *)
lemma nle_plus_dx_dx_refl (m) (n): m ≤ m + n.
/2 width=1 by nle_plus_bi_sn/ qed.

(*** le_plus_n *)
lemma nle_plus_dx_sn_refl (m) (n): m ≤ n + m.
/2 width=1 by nle_plus_bi_sn/ qed.

(*** le_plus_b *)
lemma nle_plus_dx_dx (m) (n) (o): n + o ≤ m → n ≤ m.
/2 width=3 by nle_trans/ qed.

(*** le_plus_a *)
lemma nle_plus_dx_sn (m) (n) (o): n ≤ m → n ≤ o + m.
/2 width=3 by nle_trans/ qed.

(* Main constructions with nplus ********************************************)

(*** le_plus *)
theorem nle_plus_bi (m1) (m2) (n1) (n2):
        m1 ≤ m2 → n1 ≤ n2 → m1 + n1 ≤ m2 + n2.
/3 width=3 by nle_plus_bi_dx, nle_plus_bi_sn, nle_trans/ qed.

(* Inversions with nplus ****************************************************)

(*** plus_le_0 *)
lemma nle_inv_plus_zero (m) (n): m + n ≤ 𝟎 → ∧∧ 𝟎 = m & 𝟎 = n.
/3 width=1 by nle_inv_zero_dx, eq_inv_nzero_plus/ qed-.

(*** le_plus_to_le_r *)
lemma nle_inv_plus_bi_dx (o) (m) (n): n + o ≤ m + o → n ≤ m.
#o @(nat_ind_succ … o) -o /3 width=1 by nle_inv_succ_bi/
qed-.

(*** le_plus_to_le *)
lemma nle_inv_plus_bi_sn (o) (m) (n): o + n ≤ o + m → n ≤ m.
/2 width=2 by nle_inv_plus_bi_dx/ qed-.
