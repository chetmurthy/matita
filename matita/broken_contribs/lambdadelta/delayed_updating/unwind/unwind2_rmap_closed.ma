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

include "delayed_updating/unwind/unwind2_rmap_ctls.ma".
include "delayed_updating/syntax/path_closed.ma".
include "delayed_updating/syntax/path_depth.ma".
include "ground/relocation/fb/fbr_uni_lapp.ma".
include "ground/relocation/fb/fbr_after_xapp.ma".
include "ground/relocation/fb/fbr_after_lapp.ma".
include "ground/relocation/fb/fbr_ctls_lapp.ma".
include "ground/arith/nat_le_plus.ma".
include "ground/arith/nat_le_pred.ma".

(* TAILED UNWIND FOR RELOCATION MAP *****************************************)

(* Constructions with pcc ***************************************************)

(* Note: arithmetic miracle in the case of label "𝗱"! *)
lemma eq_succ_depth_unwind2_rmap_Lq_pcc (f) (q) (n):
      ♭q = ▶[𝗟◗q]f＠§❨n❩ →
      q ϵ 𝐂❨n❩.
#f #q <unwind2_rmap_L_sn elim q -q
[ #n
  <depth_empty <unwind2_rmap_empty #H0
  <(eq_inv_zero_fbr_lapp_push … H0) -H0 //
| * [ #k ] #q #IH #n
  [ <depth_d_dx <unwind2_rmap_d_dx
    <fbr_lapp_after <fbr_lapp_uni #Hq
    /3 width=1 by pcc_d_dx/
  | <depth_L_dx <unwind2_rmap_L_dx #Hq
    elim (eq_inv_succ_fbr_lapp_push … Hq) -Hq #Hn #Hn >Hn
    /3 width=2 by pcc_L_dx/
  | <depth_A_dx <unwind2_rmap_A_dx #Hq
    /3 width=2 by pcc_A_dx/
  | <depth_S_dx <unwind2_rmap_S_dx #Hq
    /3 width=2 by pcc_S_dx/
  ]
]
qed-.

(* Destructions with pcc ****************************************************)

lemma unwind2_rmap_append_closed_dx_xapp_le (f) (p) (q) (n):
      q ϵ 𝐂❨n❩ → ∀m. m ≤ n →
      (▶[q]f)＠❨m❩ = (▶[p●q]f)＠❨m❩.
#f #p #q #n #Hq elim Hq -q -n
[|*: #q #n [ #k ] #_ #IH ] #m #Hm
[ <(nle_inv_zero_dx … Hm) -m //
| <unwind2_rmap_d_dx <unwind2_rmap_d_dx
  <fbr_xapp_after <fbr_xapp_after
  @IH -IH (**) (* auto too slow *)
  @nle_trans [| @fbr_xapp_uni_le ]
  /2 width=1 by nle_plus_bi_dx/
| <unwind2_rmap_L_dx <unwind2_rmap_L_dx
  elim (nle_inv_succ_dx … Hm) -Hm // * #Hm #H0
  >H0 -H0 <fbr_xapp_push_succ <fbr_xapp_push_succ
  <IH -IH //
| <unwind2_rmap_A_dx <unwind2_rmap_A_dx
  /2 width=2 by/
| <unwind2_rmap_S_dx <unwind2_rmap_S_dx
  /2 width=2 by/
]
qed-.

lemma unwind2_rmap_append_closed_Lq_dx_lapp (f) (p) (q) (n):
      q ϵ 𝐂❨n❩ →
      (▶[𝗟◗q]f)＠§❨n❩ = (▶[p●𝗟◗q]f)＠§❨n❩.
#f #p #q #n #Hq
lapply (pcc_L_sn … Hq) -Hq #Hq
lapply (unwind2_rmap_append_closed_dx_xapp_le f p … Hq (⁤↑n) ?) -Hq //
<fbr_xapp_succ_lapp <fbr_xapp_succ_lapp #Hq
/2 width=1 by eq_inv_nsucc_bi/
qed-.

(* Note: this inverts eq_succ_depth_unwind2_rmap_Lq_pcc *)
lemma unwind2_rmap_push_closed_lapp (f) (q) (n):
      q ϵ 𝐂❨n❩ →
      ♭q = (▶[q]⫯f)＠§❨n❩.
#f #q #n #Hq elim Hq -q -n
[|*: #q #n [ #k ] #_ #IH ] //
<unwind2_rmap_L_dx <depth_L_dx >IH -IH //
qed-.

lemma unwind2_rmap_append_closed_Lq_dx_lapp_depth (f) (p) (q) (n):
      q ϵ 𝐂❨n❩ →
      ♭q = (▶[p●𝗟◗q]f)＠§❨n❩.
#f #p #q #n #Hq
<unwind2_rmap_append_closed_Lq_dx_lapp //
/2 width=1 by unwind2_rmap_push_closed_lapp/
qed-.

lemma ctls_succ_plus_unwind2_rmap_push_closed (f) (q) (n):
      q ϵ 𝐂❨n❩ →
      ∀m. ⫰*[m]f = ⫰*[⁤↑(m+n)]▶[q]⫯f.
#f #q #n #Hq elim Hq -q -n //
#q #n [ #k ] #_ #IH #m
[ <ctls_unwind2_rmap_d_dx >IH -IH
  <nplus_assoc <nplus_succ_sn //
| <unwind2_rmap_L_dx <fbr_ctls_succ
  <nplus_succ_dx //
]
qed-.

lemma ctls_succ_unwind2_rmap_append_closed_Lq_dx (f) (p) (q) (n):
      q ϵ 𝐂❨n❩ →
      ▶[p]f = ⫰*[⁤↑n]▶[p●𝗟◗q]f.
/2 width=1 by ctls_succ_plus_unwind2_rmap_push_closed/
qed-.

theorem unwind2_rmap_append_closed_Lq_dx_lapp_plus (f) (p) (q) (m) (n):
        q ϵ 𝐂❨n❩ →
        (▶[p]f)＠❨m❩+♭q = (▶[p●𝗟◗q]f)＠§❨m+n❩.
#f #p #q #m #n #Hq
<fbr_lapp_plus_dx_xapp
<ctls_succ_unwind2_rmap_append_closed_Lq_dx //
<unwind2_rmap_append_closed_Lq_dx_lapp_depth //
qed-.

theorem ctls_succ_plus_unwind2_rmap_append_closed_Lq_dx (f) (p) (q) (m) (n):
        q ϵ 𝐂❨n❩ →
        (⫰*[m]▶[p]f) = ⫰*[⁤↑(m+n)]▶[p●𝗟◗q]f.
#f #p #q #m #n #Hn
<nplus_comm >nplus_succ_sn <fbr_ctls_plus
<ctls_succ_unwind2_rmap_append_closed_Lq_dx //
qed-.
