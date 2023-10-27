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

include "delayed_updating/substitution/lift_path.ma".
include "delayed_updating/substitution/lift_rmap_closed.ma".
include "ground/arith/nat_le_plus.ma".

(* LIFT FOR PATH ************************************************************)

(* Constructions with pcc ***************************************************)

lemma lift_path_closed_des_gen (f) (q) (n):
      q ϵ 𝐂❨n❩ → q = 🠡[f]q.
#f #q #n #Hq elim Hq -q -n //
#q #n #k #Hq #IH
<lift_path_d_dx <(lift_rmap_closed_xapp_le … Hq) -Hq //
qed-.
