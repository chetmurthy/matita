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

include "static_2/notation/relations/topiso_2.ma".
include "static_2/syntax/term.ma".

(* HEAD EQUIVALENCE FOR TERMS ***********************************************)

(* Basic_2A1: includes: tsts_atom tsts_pair *)
inductive theq: relation term ≝
| theq_sort: ∀s1,s2. theq (⋆s1) (⋆s2)
| theq_lref: ∀i. theq (#i) (#i)
| theq_gref: ∀l. theq (§l) (§l)
| theq_pair: ∀I,V1,V2,T1,T2. theq (②{I}V1.T1) (②{I}V2.T2)
.

interpretation "head equivalence (term)" 'TopIso T1 T2 = (theq T1 T2).

(* Basic inversion lemmas ***************************************************)

fact theq_inv_sort1_aux: ∀X,Y. X ⩳ Y → ∀s1. X = ⋆s1 →
                         ∃s2. Y = ⋆s2.
#X #Y * -X -Y
[ #s1 #s2 #s #H destruct /2 width=2 by ex_intro/
| #i #s #H destruct
| #l #s #H destruct
| #I #V1 #V2 #T1 #T2 #s #H destruct
]
qed-.

(* Basic_1: was just: iso_gen_sort *)
lemma theq_inv_sort1: ∀Y,s1. ⋆s1 ⩳ Y →
                      ∃s2. Y = ⋆s2.
/2 width=4 by theq_inv_sort1_aux/ qed-.

fact theq_inv_lref1_aux: ∀X,Y. X ⩳ Y → ∀i. X = #i → Y = #i.
#X #Y * -X -Y //
[ #s1 #s2 #j #H destruct
| #I #V1 #V2 #T1 #T2 #j #H destruct
]
qed-.

(* Basic_1: was: iso_gen_lref *)
lemma theq_inv_lref1: ∀Y,i. #i ⩳ Y → Y = #i.
/2 width=5 by theq_inv_lref1_aux/ qed-.

fact theq_inv_gref1_aux: ∀X,Y. X ⩳ Y → ∀l. X = §l → Y = §l.
#X #Y * -X -Y //
[ #s1 #s2 #k #H destruct
| #I #V1 #V2 #T1 #T2 #k #H destruct
]
qed-.

lemma theq_inv_gref1: ∀Y,l. §l ⩳ Y → Y = §l.
/2 width=5 by theq_inv_gref1_aux/ qed-.

fact theq_inv_pair1_aux: ∀T1,T2. T1 ⩳ T2 →
                         ∀J,W1,U1. T1 = ②{J}W1.U1 →
                         ∃∃W2,U2. T2 = ②{J}W2.U2.
#T1 #T2 * -T1 -T2
[ #s1 #s2 #J #W1 #U1 #H destruct
| #i #J #W1 #U1 #H destruct
| #l #J #W1 #U1 #H destruct
| #I #V1 #V2 #T1 #T2 #J #W1 #U1 #H destruct /2 width=3 by ex1_2_intro/
]
qed-.

(* Basic_1: was: iso_gen_head *)
(* Basic_2A1: was: tsts_inv_pair1 *)
lemma theq_inv_pair1: ∀J,W1,U1,T2. ②{J}W1.U1 ⩳ T2 →
                      ∃∃W2,U2. T2 = ②{J}W2. U2.
/2 width=7 by theq_inv_pair1_aux/ qed-.

fact theq_inv_pair2_aux: ∀T1,T2. T1 ⩳ T2 →
                         ∀J,W2,U2. T2 = ②{J}W2.U2 →
                         ∃∃W1,U1. T1 = ②{J}W1.U1.
#T1 #T2 * -T1 -T2
[ #s1 #s2 #J #W2 #U2 #H destruct
| #i #J #W2 #U2 #H destruct
| #l #J #W2 #U2 #H destruct
| #I #V1 #V2 #T1 #T2 #J #W2 #U2 #H destruct /2 width=3 by ex1_2_intro/
]
qed-.

(* Basic_2A1: was: tsts_inv_pair2 *)
lemma theq_inv_pair2: ∀J,T1,W2,U2. T1 ⩳ ②{J}W2.U2 →
                      ∃∃W1,U1. T1 = ②{J}W1.U1.
/2 width=7 by theq_inv_pair2_aux/ qed-.

(* Advanced inversion lemmas ************************************************)

lemma theq_inv_pair: ∀I1,I2,V1,V2,T1,T2. ②{I1}V1.T1 ⩳ ②{I2}V2.T2 →
                     I1 = I2.
#I1 #I2 #V1 #V2 #T1 #T2 #H elim (theq_inv_pair1 … H) -H
#V0 #T0 #H destruct //
qed-.

(* Basic properties *********************************************************)

(* Basic_1: was: iso_refl *)
(* Basic_2A1: was: tsts_refl *)
lemma theq_refl: reflexive … theq.
* //
* /2 width=1 by theq_lref, theq_gref/
qed.

(* Basic_2A1: was: tsts_sym *)
lemma theq_sym: symmetric … theq.
#T1 #T2 * -T1 -T2 /2 width=3 by theq_sort/
qed-.

(* Basic_2A1: was: tsts_dec *)
lemma theq_dec: ∀T1,T2. Decidable (T1 ⩳ T2).
* [ * #s1 | #I1 #V1 #T1 ] * [1,3,5,7: * #s2 |*: #I2 #V2 #T2 ]
[ /3 width=1 by theq_sort, or_introl/
|2,3,13:
  @or_intror #H
  elim (theq_inv_sort1 … H) -H #x #H destruct
|4,6,14:
  @or_intror #H
  lapply (theq_inv_lref1 … H) -H #H destruct
|5:
  elim (eq_nat_dec s1 s2) #Hs12 destruct /2 width=1 by or_introl/
  @or_intror #H
  lapply (theq_inv_lref1 … H) -H #H destruct /2 width=1 by/
|7,8,15:
  @or_intror #H
  lapply (theq_inv_gref1 … H) -H #H destruct
|9:
  elim (eq_nat_dec s1 s2) #Hs12 destruct /2 width=1 by or_introl/
  @or_intror #H
  lapply (theq_inv_gref1 … H) -H #H destruct /2 width=1 by/
|10,11,12:
  @or_intror #H
  elim (theq_inv_pair1 … H) -H #X1 #X2 #H destruct
|16:
  elim (eq_item2_dec I1 I2) #HI12 destruct
  [ /3 width=1 by theq_pair, or_introl/ ]
  @or_intror #H
  lapply (theq_inv_pair … H) -H /2 width=1 by/
]
qed-.

(* Basic_2A1: removed theorems 2:
              tsts_inv_atom1 tsts_inv_atom2
*)
