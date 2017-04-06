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

include "basic_2/notation/constructors/star_0.ma".
include "basic_2/notation/constructors/dxbind2_3.ma".
include "basic_2/notation/constructors/dxabbr_2.ma".
include "basic_2/notation/constructors/dxabst_2.ma".
include "basic_2/syntax/term.ma".

(* LOCAL ENVIRONMENTS *******************************************************)

(* local environments *)
inductive lenv: Type[0] ≝
| LAtom: lenv                       (* empty *)
| LPair: lenv → bind2 → term → lenv (* binary binding construction *)
.

interpretation "sort (local environment)"
   'Star = LAtom.

interpretation "local environment binding construction (binary)"
   'DxBind2 L I T = (LPair L I T).

interpretation "abbreviation (local environment)"
   'DxAbbr L T = (LPair L Abbr T).

interpretation "abstraction (local environment)"
   'DxAbst L T = (LPair L Abst T).

definition ceq: relation3 lenv term term ≝ λL,T1,T2. T1 = T2.

definition cfull: relation3 lenv term term ≝ λL,T1,T2. ⊤.

(* Basic properties *********************************************************)

lemma eq_lenv_dec: ∀L1,L2:lenv. Decidable (L1 = L2).
#L1 elim L1 -L1 [| #L1 #I1 #V1 #IHL1 ] * [2,4: #L2 #I2 #V2 ]
[1,4: @or_intror #H destruct
| elim (eq_bind2_dec I1 I2) #HI
  [ elim (eq_term_dec V1 V2) #HV
    [ elim (IHL1 L2) -IHL1 /2 width=1 by or_introl/ #HL ]
  ]
  @or_intror #H destruct /2 width=1 by/
| /2 width=1 by or_introl/
]
qed-.

lemma cfull_dec: ∀L,T1,T2. Decidable (cfull L T1 T2).
/2 width=1 by or_introl/ qed-.

(* Basic inversion lemmas ***************************************************)

fact destruct_lpair_lpair_aux: ∀I1,I2,L1,L2,V1,V2. L1.ⓑ{I1}V1 = L2.ⓑ{I2}V2 →
                               ∧∧L1 = L2 & I1 = I2 & V1 = V2.
#I1 #I2 #L1 #L2 #V1 #V2 #H destruct /2 width=1 by and3_intro/
qed-.

lemma discr_lpair_x_xy: ∀I,V,L. L = L.ⓑ{I}V → ⊥.
#I #V #L elim L -L
[ #H destruct
| #L #J #W #IHL #H
  elim (destruct_lpair_lpair_aux … H) -H #H1 #H2 #H3 destruct /2 width=1 by/ (**) (* destruct lemma needed *)
]
qed-.

lemma discr_lpair_xy_x: ∀I,V,L. L.ⓑ{I}V = L → ⊥.
/2 width=4 by discr_lpair_x_xy/ qed-.
