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

include "delayed_updating/reduction/ibfr.ma".

include "delayed_updating/substitution/fsubst_lift.ma".
include "delayed_updating/substitution/fsubst_eq.ma".
include "delayed_updating/substitution/lift_prototerm_after.ma".
include "delayed_updating/substitution/lift_path_closed.ma".
include "delayed_updating/substitution/lift_path_structure.ma".
include "delayed_updating/substitution/lift_path_clear.ma".
include "delayed_updating/substitution/lift_path_depth.ma".

include "ground/relocation/fb/fbr_uni_ctls.ma".

(* IMMEDIATE BALANCED FOCUSED REDUCTION *************************************)

(* Constructions with lift **************************************************)

theorem ibfr_lift_bi (f) (t1) (t2) (r):
        t1 ➡𝐢𝐛𝐟[r] t2 → 🠡[f]t1 ➡𝐢𝐛𝐟[🠡[f]r] 🠡[f]t2.
#f #t1 #t2 #r
* #p #b #q #n #Hr #Hb #Hn #Ht1 #Ht2 destruct
@(ex5_4_intro … (🠡[f]p) (🠡[🠢[p◖𝗔]f]b) (🠡[🠢[p◖𝗔●b◖𝗟]f]q) n)
[ -Hb -Hn -Ht1 -Ht2 //
| -Hn -Ht1 -Ht2 //
| -Hb -Ht1 -Ht2 <lift_path_closed_des_gen //
| lapply (in_comp_lift_path_term f … Ht1) -Ht2 -Ht1
  <lift_path_d_dx <path_append_pLq
  <lift_rmap_append_L_closed_dx_xapp_succ //
| lapply (lift_term_eq_repl_dx f … Ht2) -Ht2 #Ht2 -Ht1
  @(subset_eq_trans … Ht2) -t2
  @(subset_eq_trans … (lift_term_fsubst …))
  @fsubst_eq_repl [ // | // ]
  @(subset_eq_trans … (lift_pt_append …))
  <lift_path_clear_swap @pt_append_eq_repl
  @(subset_eq_trans … (lift_pt_append …))
  <lift_path_L_sn <lift_rmap_L_dx <lift_rmap_A_dx <lift_path_depth
  <(lift_path_closed_des_gen … Hn) <(lift_path_closed_des_gen … Hn)
  @pt_append_eq_repl
  @(subset_eq_canc_sn … (lift_term_eq_repl_dx …))
  [ @lift_term_grafted_S | skip ]
  @(subset_eq_trans … (lift_term_after …))
  @(subset_eq_canc_dx … (lift_term_after …))
  @lift_term_eq_repl_sn
(* Note: crux of the proof begins *)
  >lift_rmap_append <fbr_after_uni_dx
  <lift_rmap_append_clear_L_closed_dx_xapp_succ_plus //
  <ctls_succ_plus_lift_rmap_append_clear_L_closed_dx //
(* Note: crux of the proof ends *)
]
qed.
