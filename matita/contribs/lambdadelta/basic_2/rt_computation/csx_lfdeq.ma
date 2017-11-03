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

include "basic_2/rt_transition/cpx_lfdeq.ma".
include "basic_2/rt_computation/csx_csx.ma".

(* STRONGLY NORMALIZING TERMS FOR UNCOUNTED PARALLEL RT-TRANSITION **********)

(* Properties with degree-based equivalence for local environments **********)

(* Basic_2A1: uses: csx_lleq_conf *)
lemma csx_lfdeq_conf: ∀h,o,G,L1,T. ⦃G, L1⦄ ⊢ ⬈*[h, o] 𝐒⦃T⦄ →
                      ∀L2. L1 ≡[h, o, T] L2 → ⦃G, L2⦄ ⊢ ⬈*[h, o] 𝐒⦃T⦄.
#h #o #G #L1 #T #H
@(csx_ind … H) -T #T1 #_ #IH #L2 #HL12
@csx_intro #T2 #HT12 #HnT12
elim (lfdeq_cpx_trans … HL12 … HT12) -HT12
/5 width=4 by cpx_lfdeq_conf_sn, csx_tdeq_trans, tdeq_trans/
qed-.

(* Basic_2A1: uses: csx_lleq_conf *)
lemma csx_lfdeq_trans: ∀h,o,L1,L2,T. L1 ≡[h, o, T] L2 →
                       ∀G. ⦃G, L2⦄ ⊢ ⬈*[h, o] 𝐒⦃T⦄ → ⦃G, L1⦄ ⊢ ⬈*[h, o] 𝐒⦃T⦄.
/3 width=3 by csx_lfdeq_conf, lfdeq_sym/ qed-.
