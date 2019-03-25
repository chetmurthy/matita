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

include "static_2/static/rdeq_fqup.ma".
include "basic_2/rt_transition/cwhx.ma".

(* WHD NORMAL TERMS FOR UNBOUND CONTEXT-SENSITIVE PARALLEL RT-TRANSITION ****)

(* Properties with sort-irrelevant equivalence ******************************)

lemma rdeq_tdeq_cwhx_trans (h) (G):
                           ∀L2,T2. ⦃G,L2⦄ ⊢ ⬈[h] 𝐖𝐇⦃T2⦄ →
                           ∀T1. T1 ≛ T2 →
                           ∀L1. L1 ≛[T1] L2 → ⦃G,L1⦄ ⊢ ⬈[h] 𝐖𝐇⦃T1⦄.
#h #G #L2 #T2 #H elim H -L2 -T2
[ #L2 #s2 #X1 #HX #L1 #HL
  elim (tdeq_inv_sort2 … HX) -HX #s1 #H destruct -s2 //
| #p #L2 #W2 #T2 #X1 #HX #L1 #HL
  elim (tdeq_inv_pair2 … HX) -HX #W1 #T1 #_ #_ #H destruct -W2 -T2 //
| #L2 #V2 #T2 #_ #IH #X1 #HX #L1 #HL
  elim (tdeq_inv_pair2 … HX) -HX #V1 #T1 #HV12 #HT12 #H destruct
  elim (rdeq_inv_bind … HL) -HL #HV1 #HT1
  /5 width=2 by cwhx_ldef, rdeq_bind_repl_dx, ext2_pair/
]
qed-.

lemma tdeq_cwhx_trans (h) (G) (L):
                      ∀T2. ⦃G,L⦄ ⊢ ⬈[h] 𝐖𝐇⦃T2⦄ →
                      ∀T1. T1 ≛ T2 → ⦃G,L⦄ ⊢ ⬈[h] 𝐖𝐇⦃T1⦄.
/3 width=5 by rdeq_tdeq_cwhx_trans/ qed-.
