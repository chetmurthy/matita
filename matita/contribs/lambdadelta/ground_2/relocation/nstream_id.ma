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

include "ground_2/notation/functions/identity_0.ma".
include "ground_2/notation/relations/isidentity_1.ma".
include "ground_2/relocation/nstream_lift.ma".
include "ground_2/relocation/nstream_after.ma".

(* RELOCATION N-STREAM ******************************************************)

let corec id: nstream ≝ ↑id.

interpretation "identity (nstream)"
   'Identity = (id).

definition isid: predicate nstream ≝ λt. t ≐ 𝐈𝐝.

interpretation "test for identity (trace)"
   'IsIdentity t = (isid t).

(* Basic properties on id ***************************************************)

lemma id_unfold: 𝐈𝐝 = ↑𝐈𝐝.
>(stream_expand … (𝐈𝐝)) in ⊢ (??%?); normalize //
qed.

(* Basic properties on isid *************************************************)

lemma isid_id: 𝐈⦃𝐈𝐝⦄.
// qed.

lemma isid_push: ∀t. 𝐈⦃t⦄ → 𝐈⦃↑t⦄.
#t #H normalize >id_unfold /2 width=1 by eq_seq/
qed.

(* Basic inversion lemmas on isid *******************************************)

lemma isid_inv_seq: ∀t,a.  𝐈⦃a@t⦄ → 𝐈⦃t⦄ ∧ a = 0.
#t #a normalize >id_unfold in ⊢ (???%→?);
#H elim (eq_stream_inv_seq ????? H) -H /2 width=1 by conj/
qed-.

lemma isid_inv_push: ∀t. 𝐈⦃↑t⦄ → 𝐈⦃t⦄.
* #a #t #H elim (isid_inv_seq … H) -H //
qed-.

lemma isid_inv_next: ∀t. 𝐈⦃⫯t⦄ → ⊥.
* #a #t #H elim (isid_inv_seq … H) -H
#_ #H destruct
qed-.

(* inversion lemmas on at ***************************************************)

let corec id_inv_at: ∀t. (∀i. @⦃i, t⦄ ≡ i) → t ≐ 𝐈𝐝 ≝ ?.
* #a #t #Ht lapply (Ht 0)
#H lapply (at_inv_O1 … H) -H
#H0 >id_unfold @eq_seq
[ cases H0 -a //
| @id_inv_at -id_inv_at
  #i lapply (Ht (⫯i)) -Ht cases H0 -a
  #H elim (at_inv_SOx … H) -H //
]
qed-.

lemma isid_inv_at: ∀i,t. 𝐈⦃t⦄ → @⦃i, t⦄ ≡ i.
#i elim i -i
[ * #a #t #H elim (isid_inv_seq … H) -H //
| #i #IH * #a #t #H elim (isid_inv_seq … H) -H
  /3 width=1 by at_S1/
]
qed-.

lemma isid_inv_at_mono: ∀t,i1,i2. 𝐈⦃t⦄ → @⦃i1, t⦄ ≡ i2 → i1 = i2.
/3 width=6 by isid_inv_at, at_mono/ qed-.

(* Properties on at *********************************************************)

lemma id_at: ∀i. @⦃i, 𝐈𝐝⦄ ≡ i.
/2 width=1 by isid_inv_at/ qed.

lemma isid_at: ∀t. (∀i. @⦃i, t⦄ ≡ i) → 𝐈⦃t⦄.
/2 width=1 by id_inv_at/ qed.

lemma isid_at_total: ∀t. (∀i1,i2. @⦃i1, t⦄ ≡ i2 → i1 = i2) → 𝐈⦃t⦄.
#t #Ht @isid_at
#i lapply (at_total i t)
#H >(Ht … H) in ⊢ (???%); -Ht //
qed.

(* Properties on after ******************************************************)

lemma after_isid_dx: ∀t2,t1,t. t2 ⊚ t1 ≡ t → t2 ≐ t → 𝐈⦃t1⦄.
#t2 #t1 #t #Ht #H2 @isid_at_total
#i1 #i2 #Hi12 elim (after_at1_fwd … Hi12 … Ht) -t1
/3 width=6 by at_inj, eq_stream_sym/
qed.

lemma after_isid_sn: ∀t2,t1,t. t2 ⊚ t1 ≡ t → t1 ≐ t → 𝐈⦃t2⦄.
#t2 #t1 #t #Ht #H1 @isid_at_total
#i2 #i #Hi2 lapply (at_total i2 t1)
#H0 lapply (at_increasing … H0)
#Ht1 lapply (after_fwd_at2 … (t1@❴i2❵) … H0 … Ht)
/3 width=7 by at_repl_back, at_mono, at_id_le/
qed.

(* Inversion lemmas on after ************************************************)

let corec isid_after_sn: ∀t1,t2. 𝐈⦃t1⦄ → t1 ⊚ t2 ≡ t2 ≝ ?.
* #a1 #t1 * * [ | #a2 ] #t2 #H cases (isid_inv_seq … H) -H
#Ht1 #H1
[ @(after_zero … H1) -H1 /2 width=1 by/
| @(after_skip … H1) -H1 /2 width=5 by/
]
qed-.

let corec isid_after_dx: ∀t2,t1. 𝐈⦃t2⦄ → t1 ⊚ t2 ≡ t1 ≝ ?.
* #a2 #t2 * *
[ #t1 #H cases (isid_inv_seq … H) -H
  #Ht2 #H2 @(after_zero … H2) -H2 /2 width=1 by/
| #a1 #t1 #H @(after_drop … a1 a1) /2 width=5 by/
]
qed-.

lemma after_isid_inv_sn: ∀t1,t2,t. t1 ⊚ t2 ≡ t →  𝐈⦃t1⦄ → t2 ≐ t.
/3 width=4 by isid_after_sn, after_mono/
qed-.

lemma after_isid_inv_dx: ∀t1,t2,t. t1 ⊚ t2 ≡ t →  𝐈⦃t2⦄ → t1 ≐ t.
/3 width=4 by isid_after_dx, after_mono/
qed-.
(*
lemma after_inv_isid3: ∀t1,t2,t. t1 ⊚ t2 ≡ t → 𝐈⦃t⦄ → 𝐈⦃t1⦄ ∧ 𝐈⦃t2⦄.
qed-.
*)
