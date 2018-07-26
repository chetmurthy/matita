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

include "basic_2/rt_computation/fpbs_cpxs.ma".
include "basic_2/rt_computation/cpms_cpxs.ma".

(* T-BOUND CONTEXT-SENSITIVE PARALLEL RT-COMPUTATION FOR TERMS **************)

(* Forward lemmas with parallel rst-computation for closures ****************)

(* Basic_2A1: uses: cprs_fpbs *)
lemma cpms_fwd_fpbs (n) (h) (o): ∀G,L,T1,T2. ⦃G, L⦄ ⊢ T1 ➡*[n,h] T2 → ⦃G, L, T1⦄ ≥[h,o] ⦃G, L, T2⦄.
/3 width=2 by cpms_fwd_cpxs, cpxs_fpbs/ qed-.
