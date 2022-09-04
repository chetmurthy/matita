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

include "delayed_updating/substitution/lift_rmap_eq.ma".
include "delayed_updating/syntax/path_closed.ma".
include "ground/lib/stream_eq_eq.ma".

(* LIFT MAP FOR PATH ********************************************************)

(* Destructions with cpp ****************************************************)

lemma tls_plus_lift_rmap_closed (f) (q) (n):
      q ϵ 𝐂❨n❩ →
      ∀m. ⇂*[m]f ≗ ⇂*[m+n]↑[q]f.
#f #q #n #Hq elim Hq -q -n //
#q #n #_ #IH #m
<nplus_succ_dx <stream_tls_swap //
qed-.

lemma tls_lift_rmap_closed (f) (q) (n):
      q ϵ 𝐂❨n❩ →
      f ≗ ⇂*[n]↑[q]f.
#f #q #n #H0
/2 width=1 by tls_plus_lift_rmap_closed/
qed-.

lemma tls_succ_lift_rmap_append_L_closed_dx (f) (p) (q) (n):
      q ϵ 𝐂❨n❩ →
      ↑[p]f ≗ ⇂*[↑n]↑[p●𝗟◗q]f.
#f #p #q #n #Hq
/3 width=1 by tls_lift_rmap_closed, pcc_L_sn/
qed-.
