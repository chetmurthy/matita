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

include "size.ma".
include "labelled_sequential_reduction.ma".

(* PARALLEL REDUCTION (SINGLE STEP) *****************************************)

(* Note: the application "(A B)" is represented by "@B.A"
         as for labelled sequential reduction
*)
inductive pred: relation term ≝
| pred_vref: ∀i. pred (#i) (#i)
| pred_abst: ∀A,C. pred A C → pred (𝛌.A) (𝛌.C) 
| pred_appl: ∀B,D,A,C. pred B D → pred A C → pred (@B.A) (@D.C)
| pred_beta: ∀B,D,A,C. pred B D → pred A C → pred (@B.𝛌.A) ([⬐D]C)
.

interpretation "parallel reduction"
    'ParRed M N = (pred M N).

notation "hvbox( M break ⥤ break term 46 N )"
   non associative with precedence 45
   for @{ 'ParRed $M $N }.

lemma pred_refl: reflexive … pred.
#M elim M -M // /2 width=1/
qed.

lemma pred_inv_vref: ∀M,N. M ⥤ N → ∀i. #i = M → #i = N.
#M #N * -M -N //
[ #A #C #_ #i #H destruct
| #B #D #A #C #_ #_ #i #H destruct
| #B #D #A #C #_ #_ #i #H destruct
]
qed-.

lemma pred_inv_abst: ∀M,N. M ⥤ N → ∀A. 𝛌.A = M →
                     ∃∃C. A ⥤ C & 𝛌.C = N.
#M #N * -M -N
[ #i #A0 #H destruct
| #A #C #HAC #A0 #H destruct /2 width=3/
| #B #D #A #C #_ #_ #A0 #H destruct
| #B #D #A #C #_ #_ #A0 #H destruct
]
qed-.

lemma pred_inv_appl: ∀M,N. M ⥤ N → ∀B,A. @B.A = M →
                     (∃∃D,C. B ⥤ D & A ⥤ C & @D.C = N) ∨
                     ∃∃A0,D,C0. B ⥤ D & A0 ⥤ C0 & 𝛌.A0 = A & [⬐D]C0 = N.
#M #N * -M -N
[ #i #B0 #A0 #H destruct
| #A #C #_ #B0 #A0 #H destruct
| #B #D #A #C #HBD #HAC #B0 #A0 #H destruct /3 width=5/
| #B #D #A #C #HBD #HAC #B0 #A0 #H destruct /3 width=7/
]
qed-.

lemma pred_lift: liftable pred.
#h #M1 #M2 #H elim H -M1 -M2 normalize // /2 width=1/
#D #D #A #C #_ #_ #IHBD #IHAC #d <dsubst_lift_le // /2 width=1/
qed.

lemma pred_inv_lift: deliftable pred.
#h #N1 #N2 #H elim H -N1 -N2 /2 width=3/
[ #C1 #C2 #_ #IHC12 #d #M1 #H
  elim (lift_inv_abst … H) -H #A1 #HAC1 #H
  elim (IHC12 … HAC1) -C1 #A2 #HA12 #HAC2 destruct
  @(ex2_1_intro … (𝛌.A2)) // /2 width=1/
| #D1 #D2 #C1 #C2 #_ #_ #IHD12 #IHC12 #d #M1 #H
  elim (lift_inv_appl … H) -H #B1 #A1 #HBD1 #HAC1 #H
  elim (IHD12 … HBD1) -D1 #B2 #HB12 #HBD2
  elim (IHC12 … HAC1) -C1 #A2 #HA12 #HAC2 destruct
  @(ex2_1_intro … (@B2.A2)) // /2 width=1/
| #D1 #D2 #C1 #C2 #_ #_ #IHD12 #IHC12 #d #M1 #H
  elim (lift_inv_appl … H) -H #B1 #M #HBD1 #HM #H1
  elim (lift_inv_abst … HM) -HM #A1 #HAC1 #H
  elim (IHD12 … HBD1) -D1 #B2 #HB12 #HBD2
  elim (IHC12 … HAC1) -C1 #A2 #HA12 #HAC2 destruct
  @(ex2_1_intro … ([⬐B2]A2)) /2 width=1/
]
qed-.

lemma pred_dsubst: dsubstable pred.
#N1 #N2 #HN12 #M1 #M2 #H elim H -M1 -M2
[ #i #d elim (lt_or_eq_or_gt i d) #Hid
  [ >(dsubst_vref_lt … Hid) >(dsubst_vref_lt … Hid) //
  | destruct >dsubst_vref_eq >dsubst_vref_eq /2 width=1/
  | >(dsubst_vref_gt … Hid) >(dsubst_vref_gt … Hid) //
  ]
| normalize /2 width=1/
| normalize /2 width=1/
| normalize #B #D #A #C #_ #_ #IHBD #IHAC #d
  >dsubst_dsubst_ge // /2 width=1/
]
qed.

lemma pred_conf1_vref: ∀i. confluent1 … pred (#i).
#i #M1 #H1 #M2 #H2
<(pred_inv_vref … H1) -H1 [3: // |2: skip ] (**) (* simplify line *)
<(pred_inv_vref … H2) -H2 [3: // |2: skip ] (**) (* simplify line *)
/2 width=3/
qed-.

lemma pred_conf1_abst: ∀A. confluent1 … pred A → confluent1 … pred (𝛌.A).
#A #IH #M1 #H1 #M2 #H2
elim (pred_inv_abst … H1 ??) -H1 [3: // |2: skip ] #A1 #HA1 #H destruct (**) (* simplify line *)
elim (pred_inv_abst … H2 ??) -H2 [3: // |2: skip ] #A2 #HA2 #H destruct (**) (* simplify line *)
elim (IH … HA1 … HA2) -A /3 width=3/
qed-.

lemma pred_conf1_appl_beta: ∀B,B1,B2,C,C2,M1.
                            (∀M0. |M0| < |B|+|𝛌.C|+1 → confluent1 ? pred M0) → (**) (* ? needed in place of … *)
                            B ⥤ B1 → B ⥤ B2 → 𝛌.C ⥤ M1 → C ⥤ C2 →
                            ∃∃M. @B1.M1 ⥤ M & [⬐B2]C2 ⥤ M.
#B #B1 #B2 #C #C2 #M1 #IH #HB1 #HB2 #H1 #HC2
elim (pred_inv_abst … H1 ??) -H1 [3: // |2: skip ] #C1 #HC1 #H destruct (**) (* simplify line *)
elim (IH B … HB1 … HB2) -HB1 -HB2 //
elim (IH C … HC1 … HC2) normalize // -B -C /3 width=5/
qed-.

theorem pred_conf: confluent … pred.
#M @(f_ind … size … M) -M #n #IH * normalize
[ /2 width=3 by pred_conf1_vref/
| /3 width=4 by pred_conf1_abst/
| #B #A #H #M1 #H1 #M2 #H2 destruct
  elim (pred_inv_appl … H1 ???) -H1 [5: // |2,3: skip ] * (**) (* simplify line *)
  elim (pred_inv_appl … H2 ???) -H2 [5,10: // |2,3,7,8: skip ] * (**) (* simplify line *) 
  [ #B2 #A2 #HB2 #HA2 #H2 #B1 #A1 #HB1 #HA1 #H1 destruct
    elim (IH A … HA1 … HA2) -HA1 -HA2 //
    elim (IH B … HB1 … HB2) // -A -B /3 width=5/
  | #C #B2 #C2 #HB2 #HC2 #H2 #HM2 #B1 #N #HB1 #H #HM1 destruct
    @(pred_conf1_appl_beta … IH) // (**) (* /2 width=7 by pred_conf1_appl_beta/ does not work *)
  | #B2 #N #B2 #H #HM2 #C #B1 #C1 #HB1 #HC1 #H1 #HM1 destruct
    @ex2_1_commute @(pred_conf1_appl_beta … IH) //
  | #C #B2 #C2 #HB2 #HC2 #H2 #HM2 #C0 #B1 #C1 #HB1 #HC1 #H1 #HM1 destruct
    elim (IH B … HB1 … HB2) -HB1 -HB2 //
    elim (IH C … HC1 … HC2) normalize // -B -C /3 width=5/
  ]
]
qed-.

lemma lsred_pred: ∀p,M,N. M ⇀[p] N → M ⥤ N.
#p #M #N #H elim H -p -M -N /2 width=1/
qed.
