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

include "delayed_updating/unwind_k/unwind2_path.ma".
include "delayed_updating/unwind_k/unwind2_rmap_lift.ma".
include "delayed_updating/substitution/lift_path_structure.ma".

(* TAILED UNWIND FOR PATH ***************************************************)

(* Constructions with lift_path *********************************************)

lemma lift_unwind2_path_after (g) (f) (p):
      (🠡[g]▼[f]p) = ▼[g•f]p.
#g #f * // * [ #k ] #p //
[ <unwind2_path_d_dx <unwind2_path_d_dx <lift_path_d_dx
  <lift_path_structure >trz_after_unfold
  /4 width=1 by trz_dapp_eq_repl_fwd, eq_f2, eq_f/
| <unwind2_path_L_dx <unwind2_path_L_dx //
| <unwind2_path_A_dx <unwind2_path_A_dx //
| <unwind2_path_S_dx <unwind2_path_S_dx //
qed.

lemma unwind2_lift_path_after (g) (f) (p):
      ▼[g]🠡[f]p = ▼[g•f]p.
#g #f * // * [ #k ] #p
[ <unwind2_path_d_dx <unwind2_path_d_dx
  <structure_lift_path >trz_after_unfold
  /4 width=1 by trz_dapp_eq_repl_fwd, eq_f2, eq_f/
| <unwind2_path_m_dx <unwind2_path_m_dx //
| <unwind2_path_L_dx <unwind2_path_L_dx //
| <unwind2_path_A_dx <unwind2_path_A_dx //
| <unwind2_path_S_dx <unwind2_path_S_dx //
]
qed.
