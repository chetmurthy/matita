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

include "delayed_updating/reduction/dfr.ma".
include "delayed_updating/reduction/ifr.ma".

include "delayed_updating/unwind/unwind2_constructors.ma".
include "delayed_updating/unwind/unwind2_preterm_fsubst.ma".
include "delayed_updating/unwind/unwind2_preterm_eq.ma".
include "delayed_updating/unwind/unwind2_prototerm_lift.ma".
include "delayed_updating/unwind/unwind2_rmap_closed.ma".

include "delayed_updating/substitution/fsubst_eq.ma".
include "delayed_updating/substitution/lift_prototerm_eq.ma".

include "delayed_updating/syntax/prototerm_proper_constructors.ma".
include "delayed_updating/syntax/path_closed_structure.ma".
include "delayed_updating/syntax/path_structure_depth.ma".

(* DELAYED FOCUSED REDUCTION ************************************************)

(* Main destructions with ifr ***********************************************)

theorem dfr_des_ifr (f) (t1) (t2) (r): t1 ϵ 𝐓 →
        t1 ➡𝐝𝐟[r] t2 → ▼[f]t1 ➡𝐢𝐟[⊗r] ▼[f]t2.
#f #t1 #t2 #r #H0t1
* #p #q #n #Hr #Hn #Ht1 #Ht2 destruct
@(ex4_3_intro … (⊗p) (⊗q) (♭q))
[ -H0t1 -Hn -Ht1 -Ht2 //
| -H0t1 -Ht1 -Ht2
  /2 width=2 by path_closed_structure_depth/
| lapply (in_comp_unwind2_path_term f … Ht1) -Ht2 -Ht1 -H0t1
  <unwind2_path_d_dx <tr_pap_succ_nap <list_append_rcons_sn
  <unwind2_rmap_append_closed_Lq_dx_nap_depth //
| lapply (unwind2_term_eq_repl_dx f … Ht2) -Ht2 #Ht2
  @(subset_eq_trans … Ht2) -t2
  @(subset_eq_trans … (unwind2_term_fsubst_ppc …))
  [ @fsubst_eq_repl [ // | // ]
    @(subset_eq_trans … (unwind2_term_iref…))
    @(subset_eq_canc_sn … (lift_term_eq_repl_dx …))
    [ @unwind2_term_grafted_S /2 width=2 by ex_intro/ | skip ] -Ht1
    @(subset_eq_trans … (lift_unwind2_term_after …))
    @unwind2_term_eq_repl_sn
(* Note: crux of the proof begins *)
    <list_append_rcons_sn
    @(stream_eq_trans … (tr_compose_uni_dx_pap …)) <tr_pap_succ_nap
    @tr_compose_eq_repl
    [ <unwind2_rmap_append_closed_Lq_dx_nap_depth //
    | /2 width=2 by tls_succ_unwind2_rmap_append_closed_Lq_dx/
    ]
(* Note: crux of the proof ends *)
  | //
  | /2 width=2 by ex_intro/
  | //
  ]
]
qed.
