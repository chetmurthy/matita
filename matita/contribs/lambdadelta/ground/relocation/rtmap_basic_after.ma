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

include "ground/arith/nat_le_pred.ma".
include "ground/relocation/rtmap_after_uni.ma".
include "ground/relocation/rtmap_basic.ma".

(* RELOCATION MAP ***********************************************************)

(* Properties with composition **********************************************)

lemma after_basic_rc (m2,m1):
      m1 ≤ m2 → ∀n2,n1.m2 ≤ n1+m1 → 𝐁❨m2,n2❩ ⊚ 𝐁❨m1,n1❩ ≘ 𝐁❨m1,n1+n2❩.
#m2 #m1 @(nat_ind_2_succ … m2 m1) -m2 -m1
[ #m1 #H #n2 #n1 #_
  <(nle_inv_zero_dx … H) -m1 //
| #m2 #IH #_ #n2 #n1 <nplus_zero_dx #H
  elim (nle_inv_succ_sn … H) -H #Hm2 #Hn1
  >Hn1 -Hn1 <nplus_succ_sn
  /3 width=7 by after_push/
| #m2 #m1 #IH #H1 #n2 #n1 <nplus_succ_dx #H2
  lapply (nle_inv_succ_bi … H1) -H1 #H1
  lapply (nle_inv_succ_bi … H2) -H2 #H2
  /3 width=7 by after_refl/
]
qed.
