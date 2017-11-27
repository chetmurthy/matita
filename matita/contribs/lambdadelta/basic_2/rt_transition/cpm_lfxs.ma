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

include "basic_2/rt_transition/cpx_lfxs.ma".
include "basic_2/rt_transition/cpm_cpx.ma".
include "basic_2/rt_transition/cpr_ext.ma".

(* CONTEXT-SENSITIVE PARALLEL REDUCTION FOR TERMS ***************************)

(* Properties with context-sensitive free variables *************************)

lemma cpm_frees_conf: ∀n,h,G. R_frees_confluent (cpm n h G).
/3 width=6 by cpm_fwd_cpx, cpx_frees_conf/ qed-.

lemma lfpr_frees_conf: ∀h,G. lexs_frees_confluent (cpr_ext h G) cfull.
/5 width=9 by cpm_fwd_cpx, lfpx_frees_conf, lexs_co, cext2_co/ qed-.

(* Properties with generic extension on referred entries ********************)

(* Basic_2A1: was just: cpr_llpx_sn_conf *)
lemma cpm_lfxs_conf: ∀R,n,h,G. s_r_confluent1 … (cpm n h G) (lfxs R).
/3 width=5 by cpm_fwd_cpx, cpx_lfxs_conf/ qed-.
