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

include "basic_2/relocation/fsup.ma".
include "basic_2/relocation/ldrop_lpx_sn.ma".
include "basic_2/substitution/cpss_lift.ma".
include "basic_2/substitution/lpss.ma".

(* SN PARALLEL SUBSTITUTION FOR LOCAL ENVIRONMENTS **************************)

(* Properies on local environment slicing ***********************************)

lemma lpss_ldrop_conf: dropable_sn lpss.
/3 width=5 by lpx_sn_deliftable_dropable, cpss_inv_lift1/ qed-.

lemma ldrop_lpss_trans: dedropable_sn lpss.
/3 width=9 by lpx_sn_liftable_dedropable, cpss_lift/ qed-.

lemma lpss_ldrop_trans_O1: dropable_dx lpss.
/2 width=3 by lpx_sn_dropable/ qed-.

(* Properties on context-sensitive parallel substitution for terms **********)

lemma fsup_cpss_trans: ∀L1,L2,T1,T2. ⦃L1, T1⦄ ⊃ ⦃L2, T2⦄ → ∀U2. L2 ⊢ T2 ▶* U2 →
                       ∃∃L,U1. L1 ⊢ ▶* L & L ⊢ T1 ▶* U1 & ⦃L, U1⦄ ⊃ ⦃L2, U2⦄.
#L1 #L2 #T1 #T2 #H elim H -L1 -L2 -T1 -T2 [2: * ] [1,2,3,4,5: /3 width=5/ ]
[ #L #K #U #T #d #e #HLK #HUT #He #U2 #HU2
  elim (lift_total U2 d e) #T2 #HUT2
  lapply (cpss_lift … HU2 … HLK … HUT … HUT2) -HU2 -HUT /3 width=9/
| #L1 #K1 #K2 #T1 #T2 #U1 #d #e #HLK1 #HTU1 #_ #IHT12 #U2 #HTU2
  elim (IHT12 … HTU2) -IHT12 -HTU2 #K #T #HK1 #HT1 #HT2
  elim (lift_total T d e) #U #HTU
  elim (ldrop_lpss_trans … HLK1 … HK1) -HLK1 -HK1 #L2 #HL12 #HL2K
  lapply (cpss_lift … HT1 … HL2K … HTU1 … HTU) -HT1 -HTU1 /3 width=11/
]
qed-.
