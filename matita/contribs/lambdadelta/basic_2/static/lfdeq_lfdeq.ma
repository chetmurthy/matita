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

include "basic_2/syntax/tdeq_tdeq.ma".
include "basic_2/static/lfxs_lfxs.ma".
include "basic_2/static/lfdeq.ma".

(* DEGREE-BASED EQUIVALENCE FOR LOCAL ENVIRONMENTS ON REFERRED ENTRIES ******)

(* Advanced properties ******************************************************)

lemma lfdeq_dec: ∀h,o,L1,L2. ∀T:term. Decidable (L1 ≡[h, o, T] L2).
/3 width=1 by lfxs_dec, tdeq_dec/ qed-.

(* Main properties **********************************************************)

theorem lfdeq_bind: ∀h,o,p,I,L1,L2,V1,V2,T.
                    L1 ≡[h, o, V1] L2 → L1.ⓑ{I}V1 ≡[h, o, T] L2.ⓑ{I}V2 →
                    L1 ≡[h, o, ⓑ{p,I}V1.T] L2.
/2 width=2 by lfxs_bind/ qed.

theorem lfdeq_flat: ∀h,o,I,L1,L2,V,T. L1 ≡[h, o, V] L2 → L1 ≡[h, o, T] L2 →
                    L1 ≡[h, o, ⓕ{I}V.T] L2.
/2 width=1 by lfxs_flat/ qed.

theorem lfdeq_trans: ∀h,o,T. Transitive … (lfdeq h o T).
#h #o #T #L1 #L * #f1 #Hf1 #HL1 #L2 * #f2 #Hf2 #HL2
lapply (frees_tdeq_conf_lexs … Hf1 T … HL1) // #H0
lapply (frees_mono … Hf2 … H0) -Hf2 -H0
/4 width=7 by lexs_trans, lexs_eq_repl_back, tdeq_trans, ex2_intro/
qed-.

theorem lfdeq_canc_sn: ∀h,o,T. left_cancellable … (lfdeq h o T).
/3 width=3 by lfdeq_trans, lfdeq_sym/ qed-.

theorem lfdeq_canc_dx: ∀h,o,T. right_cancellable … (lfdeq h o T).
/3 width=3 by lfdeq_trans, lfdeq_sym/ qed-.

theorem lfdeq_repl: ∀h,o,L1,L2. ∀T:term. L1 ≡[h, o, T] L2 →
                    ∀K1. L1 ≡[h, o, T] K1 → ∀K2. L2 ≡[h, o, T] K2 → K1 ≡[h, o, T] K2.
/3 width=3 by lfdeq_canc_sn, lfdeq_trans/ qed-.

(* Advanced properies on negated lazy equivalence *****************************)

(* Note: auto works with /4 width=8/ so lfdeq_canc_sn is preferred ************) 
lemma lfdeq_nlfdeq_trans: ∀h,o.∀T:term.∀L1,L. L1 ≡[h, o, T] L →
                          ∀L2. (L ≡[h, o, T] L2 → ⊥) → (L1 ≡[h, o, T] L2 → ⊥).
/3 width=3 by lfdeq_canc_sn/ qed-.

lemma nlfdeq_lfdeq_div: ∀h,o.∀T:term.∀L2,L. L2 ≡[h, o, T] L →
                        ∀L1. (L1 ≡[h, o, T] L → ⊥) → (L1 ≡[h, o, T] L2 → ⊥).
/3 width=3 by lfdeq_trans/ qed-.
