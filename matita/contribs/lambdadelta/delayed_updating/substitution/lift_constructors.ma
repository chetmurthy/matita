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

include "delayed_updating/substitution/lift_prototerm_id.ma".
include "delayed_updating/substitution/lift_path_uni.ma".
include "delayed_updating/syntax/prototerm_constructors.ma".

(* LIFT FOR PROTOTERM *******************************************************)

lemma lift_iref_bi (t1) (t2) (n):
      t1 ⇔ t2 → 𝛗n.t1 ⇔ 𝛗n.t2.
/2 width=1 by subset_equivalence_ext_f1_bi/
qed.

lemma lift_iref_sn (f) (t:prototerm) (n:pnat):
      (𝛗f＠⧣❨n❩.↑[⇂*[n]f]t) ⊆ ↑[f](𝛗n.t).
#f #t #n #p * #q * #r #Hr #H1 #H2 destruct
@(ex2_intro … (𝗱n◗𝗺◗r))
/2 width=1 by in_comp_iref/
qed-.

lemma lift_iref_dx (f) (t) (n:pnat):
      ↑[f](𝛗n.t) ⊆ 𝛗f＠⧣❨n❩.↑[⇂*[n]f]t.
#f #t #n #p * #q #Hq #H0 destruct
elim (in_comp_inv_iref … Hq) -Hq #p #H0 #Hp destruct
/3 width=1 by in_comp_iref, in_comp_lift_bi/
qed-.

lemma lift_iref (f) (t) (n:pnat):
      (𝛗f＠⧣❨n❩.↑[⇂*[n]f]t) ⇔ ↑[f](𝛗n.t).
/3 width=1 by conj, lift_iref_sn, lift_iref_dx/
qed.

lemma lift_iref_uni (t) (m) (n):
      (𝛗(n+m).t) ⇔ ↑[𝐮❨m❩](𝛗n.t).
#t #m #n
@(subset_eq_trans … (lift_iref …))
<tr_uni_pap >nsucc_pnpred <tr_tls_succ_uni
/3 width=1 by lift_iref_bi, lift_term_id/
qed.
