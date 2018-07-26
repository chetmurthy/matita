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

include "ground_2/notation/functions/uparrow_1.ma".
include "ground_2/notation/functions/downarrow_1.ma".
include "arithmetics/nat.ma".
include "ground_2/lib/relations.ma".

(* ARITHMETICAL PROPERTIES **************************************************)

interpretation "nat successor" 'UpArrow m = (S m).

interpretation "nat predecessor" 'DownArrow m = (pred m).

interpretation "nat min" 'and x y = (min x y).

interpretation "nat max" 'or x y = (max x y).

(* Iota equations ***********************************************************)

lemma pred_O: pred 0 = 0.
normalize // qed.

lemma pred_S: ∀m. pred (S m) = m.
// qed.

lemma plus_S1: ∀x,y. ↑(x+y) = (↑x) + y.
// qed.

lemma max_O1: ∀n. n = (0 ∨ n).
// qed.

lemma max_O2: ∀n. n = (n ∨ 0).
// qed.

lemma max_SS: ∀n1,n2. ↑(n1∨n2) = (↑n1 ∨ ↑n2).
#n1 #n2 elim (decidable_le n1 n2) #H normalize
[ >(le_to_leb_true … H) | >(not_le_to_leb_false … H) ] -H //
qed.

(* Equations ****************************************************************)

lemma plus_SO: ∀n. n + 1 = ↑n.
// qed.

lemma minus_plus_m_m_commutative: ∀n,m:nat. n = m + n - m.
// qed-.

lemma plus_n_2: ∀n. n + 2 = n + 1 + 1.
// qed.

lemma arith_l: ∀x. 1 = 1-x+(x-(x-1)).
* // #x >minus_S_S >minus_S_S <minus_O_n <minus_n_O //
qed.

(* Note: uses minus_minus_comm, minus_plus_m_m, commutative_plus, plus_minus *)
lemma plus_minus_minus_be: ∀x,y,z. y ≤ z → z ≤ x → (x - z) + (z - y) = x - y.
#x #z #y #Hzy #Hyx >plus_minus // >commutative_plus >plus_minus //
qed-.

lemma lt_succ_pred: ∀m,n. n < m → m = ↑↓m.
#m #n #Hm >S_pred /2 width=2 by ltn_to_ltO/
qed-.

fact plus_minus_minus_be_aux: ∀i,x,y,z. y ≤ z → z ≤ x → i = z - y → x - z + i = x - y.
/2 width=1 by plus_minus_minus_be/ qed-.

lemma le_plus_minus: ∀m,n,p. p ≤ n → m + n - p = m + (n - p).
/2 by plus_minus/ qed-.

lemma le_plus_minus_comm: ∀n,m,p. p ≤ m → m + n - p = m - p + n.
/2 by plus_minus/ qed-.

lemma minus_minus_comm3: ∀n,x,y,z. n-x-y-z = n-y-z-x.
// qed.

lemma arith_b1: ∀a,b,c1. c1 ≤ b → a - c1 - (b - c1) = a - b.
#a #b #c1 #H >minus_minus_comm >minus_le_minus_minus_comm //
qed-.

lemma arith_b2: ∀a,b,c1,c2. c1 + c2 ≤ b → a - c1 - c2 - (b - c1 - c2) = a - b.
#a #b #c1 #c2 #H >minus_plus >minus_plus >minus_plus /2 width=1 by arith_b1/
qed-.

lemma arith_c1x: ∀x,a,b,c1. x + c1 + a - (b + c1) = x + a - b.
/3 by monotonic_le_minus_l, le_to_le_to_eq, le_n/ qed.

lemma arith_h1: ∀a1,a2,b,c1. c1 ≤ a1 → c1 ≤ b →
                a1 - c1 + a2 - (b - c1) = a1 + a2 - b.
#a1 #a2 #b #c1 #H1 #H2 >plus_minus /2 width=1 by arith_b2/
qed-.

lemma arith_i: ∀x,y,z. y < x → x+z-y-1 = x-y-1+z.
/2 width=1 by plus_minus/ qed-.

lemma plus_to_minus_2: ∀m1,m2,n1,n2. n1 ≤ m1 → n2 ≤ m2 →
                       m1+n2 = m2+n1 → m1-n1 = m2-n2.
/2 width=1 by arith_b1/ qed-.

lemma idempotent_max: ∀n:nat. n = (n ∨ n).
#n normalize >le_to_leb_true //
qed.

lemma associative_max: associative … max.
#x #y #z normalize
@(leb_elim x y) normalize #Hxy
@(leb_elim y z) normalize #Hyz //
[1,2: >le_to_leb_true /2 width=3 by transitive_le/
| >not_le_to_leb_false /4 width=3 by lt_to_not_le, not_le_to_lt, transitive_lt/
  >not_le_to_leb_false //
]
qed.

(* Properties ***************************************************************)

lemma eq_nat_dec: ∀n1,n2:nat. Decidable (n1 = n2).
#n1 elim n1 -n1 [| #n1 #IHn1 ] * [2,4: #n2 ]
[1,4: @or_intror #H destruct
| elim (IHn1 n2) -IHn1 /3 width=1 by or_intror, or_introl/
| /2 width=1 by or_introl/
]
qed-.

lemma lt_or_eq_or_gt: ∀m,n. ∨∨ m < n | n = m | n < m.
#m #n elim (lt_or_ge m n) /2 width=1 by or3_intro0/
#H elim H -m /2 width=1 by or3_intro1/
#m #Hm * /3 width=1 by not_le_to_lt, le_S_S, or3_intro2/
qed-.

fact le_repl_sn_conf_aux: ∀x,y,z:nat. x ≤ z → x = y → y ≤ z.
// qed-.

fact le_repl_sn_trans_aux: ∀x,y,z:nat. x ≤ z → y = x → y ≤ z.
// qed-.

lemma monotonic_le_minus_l2: ∀x1,x2,y,z. x1 ≤ x2 → x1 - y - z ≤ x2 - y - z.
/3 width=1 by monotonic_le_minus_l/ qed.

(* Note: this might interfere with nat.ma *)
lemma monotonic_lt_pred: ∀m,n. m < n → 0 < m → pred m < pred n.
#m #n #Hmn #Hm whd >(S_pred … Hm)
@le_S_S_to_le >S_pred /2 width=3 by transitive_lt/
qed.

lemma lt_S_S: ∀x,y. x < y → ↑x < ↑y.
/2 width=1 by le_S_S/ qed.

lemma lt_S: ∀n,m. n < m → n < ↑m.
/2 width=1 by le_S/ qed.

lemma max_S1_le_S: ∀n1,n2,n. (n1 ∨ n2) ≤ n → (↑n1 ∨ n2) ≤ ↑n.
/4 width=2 by to_max, le_maxr, le_S_S, le_S/ qed-.

lemma max_S2_le_S: ∀n1,n2,n. (n1 ∨ n2) ≤ n → (n1 ∨ ↑n2) ≤ ↑n.
/2 width=1 by max_S1_le_S/ qed-.

lemma arith_j: ∀x,y,z. x-y-1 ≤ x-(y-z)-1.
/3 width=1 by monotonic_le_minus_l, monotonic_le_minus_r/ qed.

lemma arith_k_sn: ∀z,x,y,n. z < x → x+n ≤ y → x-z-1+n ≤ y-z-1.
#z #x #y #n #Hzx #Hxny
>plus_minus [2: /2 width=1 by monotonic_le_minus_r/ ]
>plus_minus [2: /2 width=1 by lt_to_le/ ]
/2 width=1 by monotonic_le_minus_l2/
qed.

lemma arith_k_dx: ∀z,x,y,n. z < x → y ≤ x+n → y-z-1 ≤ x-z-1+n.
#z #x #y #n #Hzx #Hyxn
>plus_minus [2: /2 width=1 by monotonic_le_minus_r/ ]
>plus_minus [2: /2 width=1 by lt_to_le/ ]
/2 width=1 by monotonic_le_minus_l2/
qed.

(* Inversion & forward lemmas ***********************************************)

lemma lt_refl_false: ∀n. n < n → ⊥.
#n #H elim (lt_to_not_eq … H) -H /2 width=1 by/
qed-.

lemma lt_zero_false: ∀n. n < 0 → ⊥.
#n #H elim (lt_to_not_le … H) -H /2 width=1 by/
qed-.

lemma lt_le_false: ∀x,y. x < y → y ≤ x → ⊥.
/3 width=4 by lt_refl_false, lt_to_le_to_lt/ qed-.

lemma succ_inv_refl_sn: ∀x. ↑x = x → ⊥.
#x #H @(lt_le_false x (↑x)) //
qed-.

lemma le_plus_xSy_O_false: ∀x,y. x + S y ≤ 0 → ⊥.
#x #y #H lapply (le_n_O_to_eq … H) -H <plus_n_Sm #H destruct
qed-.

lemma le_plus_xySz_x_false: ∀y,z,x. x + y + S z ≤ x → ⊥.
#y #z #x elim x -x /3 width=1 by le_S_S_to_le/
#H elim (le_plus_xSy_O_false … H)
qed-.

lemma plus_xySz_x_false: ∀z,x,y. x + y + S z = x → ⊥.
/2 width=4 by le_plus_xySz_x_false/ qed-.

lemma plus_xSy_x_false: ∀y,x. x + S y = x → ⊥.
/2 width=4 by plus_xySz_x_false/ qed-.

lemma pred_inv_refl: ∀m. pred m = m → m = 0.
* // normalize #m #H elim (lt_refl_false m) //
qed-.

lemma discr_plus_xy_y: ∀x,y. x + y = y → x = 0.
// qed-.

lemma discr_plus_x_xy: ∀x,y. x = x + y → y = 0.
/2 width=2 by le_plus_minus_comm/ qed-.

lemma lt_plus_SO_to_le: ∀x,y. x < y + 1 → x ≤ y.
/2 width=1 by monotonic_pred/ qed-.

lemma plus2_inv_le_sn: ∀m1,m2,n1,n2. m1 + n1 = m2 + n2 → m1 ≤ m2 → n2 ≤ n1.
#m1 #m2 #n1 #n2 #H #Hm
lapply (monotonic_le_plus_l n1 … Hm) -Hm >H -H
/2 width=2 by le_plus_to_le/
qed-.

lemma lt_S_S_to_lt: ∀x,y. ↑x < ↑y → x < y.
/2 width=1 by le_S_S_to_le/ qed-.

(* Note this should go in nat.ma *)
lemma discr_x_minus_xy: ∀x,y. x = x - y → x = 0 ∨ y = 0.
#x @(nat_ind_plus … x) -x /2 width=1 by or_introl/
#x #_ #y @(nat_ind_plus … y) -y /2 width=1 by or_intror/
#y #_ >minus_plus_plus_l
#H lapply (discr_plus_xy_minus_xz … H) -H
#H destruct
qed-.

lemma lt_inv_O1: ∀n. 0 < n → ∃m. ↑m = n.
* /2 width=2 by ex_intro/
#H cases (lt_le_false … H) -H //
qed-.

lemma lt_inv_S1: ∀m,n. ↑m < n → ∃∃p. m < p & ↑p = n.
#m * /3 width=3 by lt_S_S_to_lt, ex2_intro/
#H cases (lt_le_false … H) -H //
qed-.

lemma lt_inv_gen: ∀y,x. x < y → ∃∃z. x ≤ z & ↑z = y.
* /3 width=3 by le_S_S_to_le, ex2_intro/
#x #H elim (lt_le_false … H) -H //
qed-.

lemma plus_inv_O3: ∀x,y. x + y = 0 → x = 0 ∧ y = 0.
/2 width=1 by plus_le_0/ qed-.

lemma plus_inv_S3_sn: ∀x1,x2,x3. x1+x2 = ↑x3 →
                      ∨∨ ∧∧ x1 = 0 & x2 = ↑x3
                       | ∃∃y1. x1 = ↑y1 & y1 + x2 = x3.
* /3 width=1 by or_introl, conj/
#x1 #x2 #x3 <plus_S1 #H destruct
/3 width=3 by ex2_intro, or_intror/
qed-.

lemma plus_inv_S3_dx: ∀x2,x1,x3. x1+x2 = ↑x3 →
                      ∨∨ ∧∧ x2 = 0 & x1 = ↑x3
                       | ∃∃y2. x2 = ↑y2 & x1 + y2 = x3.
* /3 width=1 by or_introl, conj/
#x2 #x1 #x3 <plus_n_Sm #H destruct
/3 width=3 by ex2_intro, or_intror/
qed-.

lemma max_inv_O3: ∀x,y. (x ∨ y) = 0 → 0 = x ∧ 0 = y.
/4 width=2 by le_maxr, le_maxl, le_n_O_to_eq, conj/
qed-.

lemma zero_eq_plus: ∀x,y. 0 = x + y → 0 = x ∧ 0 = y.
* /2 width=1 by conj/ #x #y normalize #H destruct
qed-.

lemma nat_split: ∀x. x = 0 ∨ ∃y. ↑y = x.
* /3 width=2 by ex_intro, or_introl, or_intror/
qed-.

lemma lt_elim: ∀R:relation nat.
               (∀n2. R O (↑n2)) →
               (∀n1,n2. R n1 n2 → R (↑n1) (↑n2)) →
               ∀n2,n1. n1 < n2 → R n1 n2.
#R #IH1 #IH2 #n2 elim n2 -n2
[ #n1 #H elim (lt_le_false … H) -H //
| #n2 #IH * /4 width=1 by lt_S_S_to_lt/
]
qed-.

lemma le_elim: ∀R:relation nat.
               (∀n2. R O (n2)) →
               (∀n1,n2. R n1 n2 → R (↑n1) (↑n2)) →
               ∀n1,n2. n1 ≤ n2 → R n1 n2.
#R #IH1 #IH2 #n1 #n2 @(nat_elim2 … n1 n2) -n1 -n2
/4 width=1 by monotonic_pred/ -IH1 -IH2
#n1 #H elim (lt_le_false … H) -H //
qed-.

(* Iterators ****************************************************************)

(* Note: see also: lib/arithemetics/bigops.ma *)
rec definition iter (n:nat) (B:Type[0]) (op: B → B) (nil: B) ≝
  match n with
   [ O   ⇒ nil
   | S k ⇒ op (iter k B op nil)
   ].

interpretation "iterated function" 'exp op n = (iter n ? op).

lemma iter_O: ∀B:Type[0]. ∀f:B→B.∀b. f^0 b = b.
// qed.

lemma iter_S: ∀B:Type[0]. ∀f:B→B.∀b,l. f^(S l) b = f (f^l b).
// qed.

lemma iter_SO: ∀B:Type[0]. ∀f:B→B. ∀b,l. f^(l+1) b = f (f^l b).
#B #f #b #l >commutative_plus //
qed.

lemma iter_n_Sm: ∀B:Type[0]. ∀f:B→B. ∀b,l. f^l (f b) = f (f^l b).
#B #f #b #l elim l -l normalize //
qed.

lemma iter_plus: ∀B:Type[0]. ∀f:B→B. ∀b,l1,l2. f^(l1+l2) b = f^l1 (f^l2 b).
#B #f #b #l1 elim l1 -l1 normalize //
qed.

(* Trichotomy operator ******************************************************)

(* Note: this is "if eqb n1 n2 then a2 else if leb n1 n2 then a1 else a3" *)
rec definition tri (A:Type[0]) n1 n2 a1 a2 a3 on n1 : A ≝
  match n1 with
  [ O    ⇒ match n2 with [ O ⇒ a2 | S n2 ⇒ a1 ]
  | S n1 ⇒ match n2 with [ O ⇒ a3 | S n2 ⇒ tri A n1 n2 a1 a2 a3 ]
  ].

lemma tri_lt: ∀A,a1,a2,a3,n2,n1. n1 < n2 → tri A n1 n2 a1 a2 a3 = a1.
#A #a1 #a2 #a3 #n2 elim n2 -n2
[ #n1 #H elim (lt_zero_false … H)
| #n2 #IH #n1 elim n1 -n1 /3 width=1 by monotonic_lt_pred/
]
qed.

lemma tri_eq: ∀A,a1,a2,a3,n. tri A n n a1 a2 a3 = a2.
#A #a1 #a2 #a3 #n elim n -n normalize //
qed.

lemma tri_gt: ∀A,a1,a2,a3,n1,n2. n2 < n1 → tri A n1 n2 a1 a2 a3 = a3.
#A #a1 #a2 #a3 #n1 elim n1 -n1
[ #n2 #H elim (lt_zero_false … H)
| #n1 #IH #n2 elim n2 -n2 /3 width=1 by monotonic_lt_pred/
]
qed.
