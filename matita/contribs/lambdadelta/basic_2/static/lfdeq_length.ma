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

include "basic_2/relocation/lifts_tdeq.ma".
include "basic_2/static/lfxs_length.ma".
include "basic_2/static/lfxs_fsle.ma".
include "basic_2/static/lfdeq.ma".

(* DEGREE-BASED EQUIVALENCE FOR LOCAL ENVIRONMENTS ON REFERRED ENTRIES ******)

(* Advanved properties with free variables inclusion ************************)

lemma lfdeq_fsle_comp: ∀h,o. lfxs_fsle_compatible (cdeq h o).
#h #o #L1 #L2 #T * #f1 #Hf1 #HL12
lapply (frees_lfdeq_conf h o … Hf1 … HL12)
lapply (lexs_fwd_length … HL12)
/3 width=8 by lveq_length_eq, ex4_4_intro/ (**) (* full auto fails *)
qed-.

(* Properties with length for local environments ****************************)

(* Basic_2A1: uses: lleq_lift_le lleq_lift_ge *)
lemma lfdeq_lifts_bi: ∀L1,L2. |L1| = |L2| → ∀h,o,K1,K2,T. K1 ≛[h, o, T] K2 →
                      ∀b,f. ⬇*[b, f] L1 ≡ K1 → ⬇*[b, f] L2 ≡ K2 →
                      ∀U. ⬆*[f] T ≡ U → L1 ≛[h, o, U] L2.
/3 width=9 by lfxs_lifts_bi, tdeq_lifts_sn/ qed-.

(* Forward lemmas with length for local environments ************************)

(* Basic_2A1: lleq_fwd_length *)
lemma lfdeq_fwd_length: ∀h,o,L1,L2. ∀T:term. L1 ≛[h, o, T] L2 → |L1| = |L2|.
/2 width=3 by lfxs_fwd_length/ qed-.

