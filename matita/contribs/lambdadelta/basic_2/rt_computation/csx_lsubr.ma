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

include "basic_2/rt_transition/cpx_lsubr.ma".
include "basic_2/rt_computation/csx_csx.ma".

(* STRONGLY NORMALIZING TERMS FOR UNCOUNTED PARALLEL RT-TRANSITION **********)

(* Advanced properties ******************************************************)

fact csx_appl_beta_aux: ∀h,o,p,G,L,U1. ⦃G, L⦄ ⊢ ⬈*[h, o] 𝐒⦃U1⦄ →
                        ∀V,W,T1. U1 = ⓓ{p}ⓝW.V.T1 → ⦃G, L⦄ ⊢ ⬈*[h, o] 𝐒⦃ⓐV.ⓛ{p}W.T1⦄.
#h #o #p #G #L #X #H @(csx_ind … H) -X
#X #HT1 #IHT1 #V #W #T1 #H1 destruct
@csx_intro #X #H1 #H2
elim (cpx_inv_appl1 … H1) -H1 *
[ -HT1 #V0 #Y #HLV0 #H #H0 destruct
  elim (cpx_inv_abst1 … H) -H #W0 #T0 #HLW0 #HLT0 #H destruct
  @IHT1 -IHT1 [4: // | skip ]
  [ lapply (lsubr_cpx_trans … HLT0 (L.ⓓⓝW.V) ?) -HLT0 -H2
    /3 width=1 by cpx_bind, cpx_flat, lsubr_beta/
  | #H elim (tdeq_inv_pair … H) -H
    #_ #H elim (tdeq_inv_pair … H) -H
    #_ /4 width=1 by tdeq_pair/
  ]
| -IHT1 -H2 #q #V0 #W0 #W2 #T0 #T2 #HLV0 #HLW02 #HLT02 #H1 #H3 destruct
  lapply (lsubr_cpx_trans … HLT02 (L.ⓓⓝW0.V) ?) -HLT02
  /4 width=5 by csx_cpx_trans, cpx_bind, cpx_flat, lsubr_beta/
| -HT1 -IHT1 -H2 #q #V0 #V1 #W0 #W1 #T0 #T3 #_ #_ #_ #_ #H destruct
]
qed-.

(* Basic_1: was just: sn3_beta *)
lemma csx_appl_beta: ∀h,o,p,G,L,V,W,T. ⦃G, L⦄ ⊢ ⬈*[h, o] 𝐒⦃ⓓ{p}ⓝW.V.T⦄ → ⦃G, L⦄ ⊢ ⬈*[h, o] 𝐒⦃ⓐV.ⓛ{p}W.T⦄.
/2 width=3 by csx_appl_beta_aux/ qed.
