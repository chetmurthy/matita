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

include "static_2/static/rdeq_req.ma".
include "basic_2/rt_transition/rpx_rdeq.ma".
include "basic_2/rt_transition/rpx_lpx.ma".

(* UNBOUND PARALLEL RT-TRANSITION FOR FULL LOCAL ENVIRONMENTS ***************)

(* Properties with sort-irrelevant equivalence for local environments *******)

(* Basic_2A1: uses: lleq_lpx_trans *)
lemma rdeq_lpx_trans (h) (G): ∀L2,K2. ⦃G,L2⦄ ⊢ ⬈[h] K2 →
                              ∀L1. ∀T:term. L1 ≛[T] L2 →
                              ∃∃K1. ⦃G,L1⦄ ⊢ ⬈[h] K1 & K1 ≛[T] K2.
#h #G #L2 #K2 #HLK2 #L1 #T #HL12
lapply (lpx_rpx … T HLK2) -HLK2 #HLK2
elim (rdeq_rpx_trans … HLK2 … HL12) -L2 #K #H #HK2
elim (rpx_inv_lpx_req … H) -H #K1 #HLK1 #HK1
/3 width=5 by req_rdeq_trans, ex2_intro/
qed-.
