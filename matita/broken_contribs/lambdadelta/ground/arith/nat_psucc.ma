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

include "ground/arith/nat_split.ma".

(* POSITIVE SUCCESSOR FOR NON-NEGATIVE INTEGERS *****************************)

definition npsucc (m): ℕ⁺ ≝
           nsplit … (𝟏) psucc m.

interpretation
  "positive successor (non-negative integers)"
  'UpArrow m = (npsucc m).

(* Basic constructions ******************************************************)

lemma npsucc_zero: (𝟏) = ↑𝟎.
// qed.

lemma npsucc_pos (p): (↑p) = ↑(⁤p).
// qed.

(* Basic inversions *********************************************************)

lemma eq_inv_npsucc_bi: injective … npsucc.
* [| #p1 ] * [2,4: #p2 ]
[ 1,4: <npsucc_zero <npsucc_pos #H destruct
| <npsucc_pos <npsucc_pos #H destruct //
| //
]
qed-.
