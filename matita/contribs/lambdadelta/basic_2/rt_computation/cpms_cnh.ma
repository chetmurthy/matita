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

include "static_2/syntax/theq_theq.ma".
include "basic_2/rt_transition/cnh_cnh.ma".
include "basic_2/rt_computation/cpms.ma".

(* T-BOUND CONTEXT-SENSITIVE PARALLEL RT-COMPUTATION FOR TERMS **************)

(* Inversion lemmas with normal terms for head t-unbound rt-transition ******)

lemma cpms_inv_cnh_sn (h) (n) (G) (L):
      ∀T1,T2. ⦃G,L⦄ ⊢ T1 ➡*[n,h] T2 → ⦃G,L⦄ ⊢ ⥲[h] 𝐍⦃T1⦄ → T1 ⩳ T2.
#h #n #G #L #T1 #T2 #H @(cpms_ind_sn … H) -T1 //
#n1 #n2 #T1 #T0 #HT10 #_ #IH #HT1
/4 width=9 by cnh_cpm_trans, theq_trans/
qed-.
