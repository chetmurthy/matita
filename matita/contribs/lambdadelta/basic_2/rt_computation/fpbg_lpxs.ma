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

include "basic_2/rt_computation/fpbs_lpxs.ma".
include "basic_2/rt_computation/fpbg.ma".

(* PROPER PARALLEL RST-COMPUTATION FOR CLOSURES *****************************)

(* Properties with unbound rt-computation on full local environments ********)

(* Basic_2A1: uses: lpxs_fpbg *)
lemma lpxs_rdneq_fpbg: ∀h,G,L1,L2,T. ⦃G, L1⦄ ⊢ ⬈*[h] L2 →
                       (L1 ≛[T] L2 → ⊥) → ⦃G, L1, T⦄ >[h] ⦃G, L2, T⦄.
#h #G #L1 #L2 #T #H #H0
elim (lpxs_rdneq_inv_step_sn … H … H0) -H -H0
/4 width=7 by fpb_lpx, lpxs_fdeq_fpbs, fdeq_intro_sn, ex2_3_intro/
qed.
