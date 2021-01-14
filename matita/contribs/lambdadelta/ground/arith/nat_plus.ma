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

include "ground/arith/nat_succ_iter.ma".

(* ADDITION FOR NON-NEGATIVE INTEGERS ***************************************)

(*** plus *)
definition nplus: nat → nat → nat ≝
           λm,n. nsucc^n m.

interpretation
  "plus (positive integers)"
  'plus m n = (nplus m n).

(* Basic constructions ******************************************************)

(*** plus_n_O *)
lemma nplus_zero_dx (m): m = m + 𝟎.
// qed.

(*** plus_SO_dx *)
lemma nplus_one_dx (n): ↑n = n + 𝟏.
// qed.

(*** plus_n_Sm *)
lemma nplus_succ_dx (m) (n): ↑(m+n) = m + ↑n.
#m #n @(niter_succ … nsucc)
qed.

(* Constructions with niter *************************************************)

(*** iter_plus *)
lemma niter_plus (A) (f) (a) (n1) (n2):
      f^n1 (f^n2 a) = f^{A}(n1+n2) a.
#A #f #a #n1 #n2 @(nat_ind_succ … n2) -n2 //
#n2 #IH <nplus_succ_dx <niter_succ <niter_succ <niter_appl //
qed.

(* Advanved constructions (semigroup properties) ****************************)

(*** plus_S1 *)
lemma nplus_succ_sn (m) (n): ↑(m+n) = ↑m + n.
#m #n @(niter_appl … nsucc)
qed.

(*** plus_O_n.con *)
lemma nplus_zero_sn (m): m = 𝟎 + m.
#m @(nat_ind_succ … m) -m //
qed.

(*** commutative_plus *)
lemma nplus_comm: commutative … nplus.
#m @(nat_ind_succ … m) -m //
qed-. (**) (* gets in the way with auto *)

(*** associative_plus *)
lemma nplus_assoc: associative … nplus.
#m #n #o @(nat_ind_succ … o) -o //
#o #IH <nplus_succ_dx <nplus_succ_dx <nplus_succ_dx <IH -IH //
qed.

(* Helper constructions *****************************************************)

(*** plus_SO_sn *)
lemma nplus_one_sn (n): ↑n = 𝟏 + n.
#n <nplus_comm // qed.

lemma nplus_succ_shift (m) (n): ↑m + n = m + ↑n.
// qed-.

(*** assoc_plus1 *)
lemma nplus_plus_comm_12 (o) (m) (n): m + n + o = n + (m + o).
#o #m #n <nplus_comm in ⊢ (??(?%?)?); // qed.

(*** plus_plus_comm_23 *)
lemma nplus_plus_comm_23 (o) (m) (n): o + m + n = o + n + m.
#o #m #n >nplus_assoc >nplus_assoc <nplus_comm in ⊢ (??(??%)?); //
qed-.

(* Basic inversions *********************************************************)

(*** plus_inv_O3 zero_eq_plus *) 
lemma eq_inv_zero_nplus (m) (n): 𝟎 = m + n → ∧∧ 𝟎 = m & 𝟎 = n.
#m #n @(nat_ind_succ … n) -n
[ /2 width=1 by conj/
| #n #_ <nplus_succ_dx #H
  elim (eq_inv_zero_nsucc … H)
]
qed-.

(*** injective_plus_l *)
lemma eq_inv_nplus_bi_dx (o) (m) (n): m + o = n + o → m = n.
#o @(nat_ind_succ … o) -o /3 width=1 by eq_inv_nsucc_bi/
qed-.

(*** injective_plus_r *)
lemma eq_inv_nplus_bi_sn (o) (m) (n): o + m = o + n → m = n.
#o #m #n <nplus_comm <nplus_comm in ⊢ (???%→?);
/2 width=2 by eq_inv_nplus_bi_dx/
qed-.

(*** plus_xSy_x_false *)
lemma succ_nplus_refl_sn (m) (n): m = ↑(m + n) → ⊥.
#m @(nat_ind_succ … m) -m
[ /2 width=2 by eq_inv_zero_nsucc/
| #m #IH #n #H
  @(IH n) /2 width=1 by eq_inv_nsucc_bi/
]
qed-.

(*** discr_plus_xy_y *)
lemma nplus_refl_dx (m) (n): n = m + n → 𝟎 = m.
#m #n @(nat_ind_succ … n) -n //
#n #IH /3 width=1 by eq_inv_nsucc_bi/
qed-.

(*** discr_plus_x_xy *)
lemma nplus_refl_sn (m) (n): m = m + n → 𝟎 = n.
#m #n <nplus_comm
/2 width=2 by nplus_refl_dx/
qed-.

(* Advanced eliminations ****************************************************)

(*** nat_ind_plus *)
lemma nat_ind_plus (Q:predicate …):
      Q (𝟎) → (∀n. Q n → Q (𝟏+n)) → ∀n. Q n.
#Q #IH1 #IH2 #n @(nat_ind_succ … n) -n /2 width=1 by/
qed-.
