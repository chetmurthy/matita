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

include "basic_2/static/lfdeq_lfdeq.ma".
include "basic_2/static/ffdeq.ma".

(* DEGREE-BASED EQUIVALENCE FOR CLOSURES ON REFERRED ENTRIES ****************)

(* Advanced properties ******************************************************)

lemma ffdeq_sym: ∀h,o. tri_symmetric … (ffdeq h o).
#h #o #G1 #G2 #L1 #L2 #T1 #T2 * -G1 -L1 -T1
/3 width=1 by ffdeq_intro_dx, lfdeq_sym, tdeq_sym/
qed-.

(* Main properties **********************************************************)

theorem ffdeq_trans: ∀h,o. tri_transitive … (ffdeq h o).
#h #o #G1 #G #L1 #L #T1 #T * -G -L -T
#L #T #HL1 #HT1 #G2 #L2 #T2 * -G2 -L2 -T2
/4 width=5 by ffdeq_intro_sn, lfdeq_trans, tdeq_lfdeq_div, tdeq_trans/
qed-.

theorem ffdeq_canc_sn: ∀h,o,G,G1,G2,L,L1,L2,T,T1,T2.
                       ⦃G, L, T⦄ ≛[h, o] ⦃G1, L1, T1⦄→ ⦃G, L, T⦄ ≛[h, o] ⦃G2, L2, T2⦄ → ⦃G1, L1, T1⦄ ≛[h, o] ⦃G2, L2, T2⦄.
/3 width=5 by ffdeq_trans, ffdeq_sym/ qed-.

theorem ffdeq_canc_dx: ∀h,o,G1,G2,G,L1,L2,L,T1,T2,T.
                       ⦃G1, L1, T1⦄ ≛[h, o] ⦃G, L, T⦄ → ⦃G2, L2, T2⦄ ≛[h, o] ⦃G, L, T⦄ → ⦃G1, L1, T1⦄ ≛[h, o] ⦃G2, L2, T2⦄.
/3 width=5 by ffdeq_trans, ffdeq_sym/ qed-.

(* Main inversion lemmas with degree-based equivalence on terms *************)

theorem ffdeq_tdneq_repl_dx: ∀h,o,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ≛[h, o] ⦃G2, L2, T2⦄ →
                             ∀U1,U2. ⦃G1, L1, U1⦄ ≛[h, o] ⦃G2, L2, U2⦄ →
                             (T2 ≛[h, o] U2 → ⊥) → (T1 ≛[h, o] U1 → ⊥).
#h #o #G1 #G2 #L1 #L2 #T1 #T2 #HT #U1 #U2 #HU #HnTU2 #HTU1
elim (ffdeq_inv_gen_sn … HT) -HT #_ #_ #HT
elim (ffdeq_inv_gen_sn … HU) -HU #_ #_ #HU
/3 width=5 by tdeq_repl/
qed-.
