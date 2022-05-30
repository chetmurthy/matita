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

include "delayed_updating/substitution/lift_path_id.ma".
include "ground/relocation/tr_uni_pap.ma".
include "ground/relocation/tr_uni_tls.ma".

(* LIFT FOR PATH ************************************************************)

(* Constructions with tr_uni ************************************************)

lemma lift_path_d_sn_uni (p) (m) (n):
      (𝗱(n+m)◗p) = ↑[𝐮❨m❩](𝗱(n)◗p).
#p #m #n
<lift_path_d_sn <tr_uni_pap >nsucc_pnpred
<tr_tls_succ_uni //
qed.
