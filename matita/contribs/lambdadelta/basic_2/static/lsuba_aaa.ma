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

include "basic_2/static/aaa_aaa.ma".
include "basic_2/static/lsuba_ldrop.ma".

(* LOCAL ENVIRONMENT REFINEMENT FOR ATOMIC ARITY ASSIGNMENT *****************)

(* Properties concerning atomic arity assignment ****************************)

lemma lsuba_aaa_conf: ∀L1,V,A. L1 ⊢ V ⁝ A → ∀L2. L1 ⁝⊑ L2 → L2 ⊢ V ⁝ A.
#L1 #V #A #H elim H -L1 -V -A
[ //
| #I #L1 #K1 #V #A #i #HLK1 #HV #IHV #L2 #HL12
  elim (lsuba_ldrop_O1_conf … HL12 … HLK1) -L1 #X #H #HLK2
  elim (lsuba_inv_pair1 … H) -H * #K2
  [ #HK12 #H destruct /3 width=5/
  | #W0 #V0 #A0 #HV0 #HW0 #_ #H1 #H2 #H3 destruct
    lapply (aaa_mono … HV0 … HV) #H destruct -V0 /2 width=5/
  ]
| /4 width=2/
| /4 width=1/
| /3 width=3/
| /3 width=1/
]
qed-.

lemma lsuba_aaa_trans: ∀L2,V,A. L2 ⊢ V ⁝ A → ∀L1. L1 ⁝⊑ L2 → L1 ⊢ V ⁝ A.
#L2 #V #A #H elim H -L2 -V -A
[ //
| #I #L2 #K2 #V #A #i #HLK2 #H1V #IHV #L1 #HL12
  elim (lsuba_ldrop_O1_trans … HL12 … HLK2) -L2 #X #H #HLK1
  elim (lsuba_inv_pair2 … H) -H * #K1
  [ #HK12 #H destruct /3 width=5/
  | #V0 #A0 #HV0 #H2V #_ #H1 #H2 destruct
    lapply (aaa_mono … H2V … H1V) #H destruct -K2 /2 width=5/
  ]
| /4 width=2/
| /4 width=1/
| /3 width=3/
| /3 width=1/
]
qed-.
