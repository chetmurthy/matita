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

include "ground/notation/functions/zero_0.ma".
include "ground/arith/nat_succ_tri.ma".

(* MAXIMUM FOR NON-NEGATIVE INTEGERS ****************************************)

(*** max *)
definition nmax: nat → nat → nat ≝
           λm,n. ntri … m n n n m.

interpretation
  "maximum (non-negative integers)"
  'or m n = (nmax m n).

(* Basic constructions ******************************************************)

(*** max_O1 *)
lemma nmax_zero_sn (n2): n2 = (𝟎 ∨ n2).
* //
qed.

(*** max_O2 *)
lemma nmax_zero_dx (n1): n1 = (n1 ∨ 𝟎).
* //
qed.

(*** max_SS *)
lemma nmax_succ_bi (n1) (n2): ↑(n1 ∨ n2) = (↑n1 ∨ ↑n2).
#n1 #n2
@trans_eq [3: @ntri_succ_bi | skip ] (**) (* rewrite fails because δ-expansion  gets in the way *)
<ntri_f_tri //
qed.

(* Advanced constructions ***************************************************)

(*** idempotent_max *)
lemma nmax_idem (n): n = (n ∨ n).
/2 width=1 by ntri_eq/ qed.

(*** commutative_max *)
lemma nmax_comm: commutative … nmax.
#m #n @(nat_ind_succ_2 … m n) -m -n //
qed-.

(*** associative_max *)
lemma nmax_assoc: associative … nmax.
#n1 #n2 @(nat_ind_succ_2 … n1 n2) -n1 -n2 //
#n1 #n2 #IH #n3 @(nat_ind_succ … n3) -n3 //
qed.

(* Basic inversions *********************************************************)

(*** max_inv_O3 *)
lemma nmax_inv_zero (n1) (n2): 𝟎 = (n1 ∨ n2) → ∧∧ 𝟎 = n1 & 𝟎 = n2.
#n1 #n2 @(nat_ind_succ_2 … n1 n2) -n1 -n2 /2 width=1 by conj/
#n1 #n2 #_ <nmax_succ_bi #H
elim (eq_inv_nzero_succ … H)
qed-.
