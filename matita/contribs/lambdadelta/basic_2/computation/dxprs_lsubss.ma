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

include "basic_2/unwind/sstas_lsubss.ma".
include "basic_2/computation/dxprs.ma".

(* DECOMPOSED EXTENDED PARALLEL COMPUTATION ON TERMS ************************)

(* Properties on lenv ref for stratified type assignment ********************)

lemma lsubss_dxprs_trans: ∀h,g,L1,L2. h ⊢ L1 •⊑[g] L2 →
                          ∀T1,T2. ⦃h, L2⦄ ⊢ T1 •*➡*[g] T2 → ⦃h, L1⦄ ⊢ T1 •*➡*[g] T2.
#h #g #L1 #L2 #HL12 #T1 #T2 *
lapply (lsubss_fwd_lsubs2 … HL12) /3 width=5/
qed-.
