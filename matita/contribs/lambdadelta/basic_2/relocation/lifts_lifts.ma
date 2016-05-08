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

include "basic_2/relocation/lifts.ma".

(* GENERIC RELOCATION FOR TERMS *********************************************)

(* Main properties **********************************************************)

(* Basic_1: includes: lift_gen_lift *)
(* Basic_2A1: includes: lift_div_le lift_div_be *)
theorem lifts_div: ∀f2,T,T2. ⬆*[f2] T2 ≡ T → ∀T1,f. ⬆*[f] T1 ≡ T →
                   ∀f1. f2 ⊚ f1 ≡ f → ⬆*[f1] T1 ≡ T2.
#f2 #T #T2 #H elim H -f2 -T -T2
[ #f2 #s #T1 #f #H >(lifts_inv_sort2 … H) -T1 //
| #f2 #i2 #i #Hi2 #T1 #f #H #f1 #Ht21 elim (lifts_inv_lref2 … H) -H
  #i1 #Hi1 #H destruct /3 width=6 by lifts_lref, after_fwd_at1/
| #f2 #l #T1 #f #H >(lifts_inv_gref2 … H) -T1 //
| #f2 #p #I #W2 #W #U2 #U #_ #_ #IHW #IHU #T1 #f #H
  elim (lifts_inv_bind2 … H) -H #W1 #U1 #HW1 #HU1 #H destruct
  /4 width=3 by lifts_bind, after_O2/
| #f2 #I #W2 #W #U2 #U #_ #_ #IHW #IHU #T1 #f #H
  elim (lifts_inv_flat2 … H) -H #W1 #U1 #HW1 #HU1 #H destruct
  /3 width=3 by lifts_flat/
]
qed-.

(* Basic_1: was: lift1_lift1 (left to right) *)
(* Basic_1: includes: lift_free (left to right) lift_d lift1_xhg (right to left) lift1_free (right to left) *)
(* Basic_2A1: includes: lift_trans_be lift_trans_le lift_trans_ge lifts_lift_trans_le lifts_lift_trans *)
theorem lifts_trans: ∀f1,T1,T. ⬆*[f1] T1 ≡ T → ∀T2,f2. ⬆*[f2] T ≡ T2 →
                     ∀f. f2 ⊚ f1 ≡ f → ⬆*[f] T1 ≡ T2.
#f1 #T1 #T #H elim H -f1 -T1 -T
[ #f1 #s #T2 #f2 #H >(lifts_inv_sort1 … H) -T2 //
| #f1 #i1 #i #Hi1 #T2 #f2 #H #f #Ht21 elim (lifts_inv_lref1 … H) -H
  #i2 #Hi2 #H destruct /3 width=6 by lifts_lref, after_fwd_at/
| #f1 #l #T2 #f2 #H >(lifts_inv_gref1 … H) -T2 //
| #f1 #p #I #W1 #W #U1 #U #_ #_ #IHW #IHU #T2 #f2 #H
  elim (lifts_inv_bind1 … H) -H #W2 #U2 #HW2 #HU2 #H destruct
  /4 width=3 by lifts_bind, after_O2/
| #f1 #I #W1 #W #U1 #U #_ #_ #IHW #IHU #T2 #f2 #H
  elim (lifts_inv_flat1 … H) -H #W2 #U2 #HW2 #HU2 #H destruct
  /3 width=3 by lifts_flat/
]
qed-.

(* Basic_2A1: includes: lift_conf_O1 lift_conf_be *)
theorem lifts_conf: ∀f1,T,T1. ⬆*[f1] T ≡ T1 → ∀T2,f. ⬆*[f] T ≡ T2 →
                    ∀f2. f2 ⊚ f1 ≡ f → ⬆*[f2] T1 ≡ T2.
#f1 #T #T1 #H elim H -f1 -T -T1
[ #f1 #s #T2 #f #H >(lifts_inv_sort1 … H) -T2 //
| #f1 #i #i1 #Hi1 #T2 #f #H #f2 #Ht21 elim (lifts_inv_lref1 … H) -H
  #i2 #Hi2 #H destruct /3 width=6 by lifts_lref, after_fwd_at2/
| #f1 #l #T2 #f #H >(lifts_inv_gref1 … H) -T2 //
| #f1 #p #I #W #W1 #U #U1 #_ #_ #IHW #IHU #T2 #f #H
  elim (lifts_inv_bind1 … H) -H #W2 #U2 #HW2 #HU2 #H destruct
  /4 width=3 by lifts_bind, after_O2/
| #f1 #I #W #W1 #U #U1 #_ #_ #IHW #IHU #T2 #f #H
  elim (lifts_inv_flat1 … H) -H #W2 #U2 #HW2 #HU2 #H destruct
  /3 width=3 by lifts_flat/
]
qed-.

(* Advanced proprerties *****************************************************)

(* Basic_2A1: includes: lift_inj *)
lemma lifts_inj: ∀f,T1,U. ⬆*[f] T1 ≡ U → ∀T2. ⬆*[f] T2 ≡ U → T1 = T2.
#f #T1 #U #H1 #T2 #H2 lapply (isid_after_dx 𝐈𝐝  … f)
/3 width=6 by lifts_div, lifts_fwd_isid/
qed-.

(* Basic_2A1: includes: lift_mono *)
lemma lifts_mono: ∀f,T,U1. ⬆*[f] T ≡ U1 → ∀U2. ⬆*[f] T ≡ U2 → U1 = U2.
#f #T #U1 #H1 #U2 #H2 lapply (isid_after_sn 𝐈𝐝  … f)
/3 width=6 by lifts_conf, lifts_fwd_isid/
qed-.
