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

include "delayed_updating/substitution/lift.ma".
include "ground/relocation/tr_compose_compose.ma".
include "ground/relocation/tr_compose_pn.ma".
include "ground/relocation/tr_compose_eq.ma".
include "ground/relocation/tr_pn_eq.ma".

(* LIFT FOR PATH ***********************************************************)

definition lift_exteq (A): relation2 (lift_continuation A) (lift_continuation A) ≝
           λk1,k2. ∀f1,f2,p. f1 ≗ f2 → k1 f1 p = k2 f2 p.

interpretation
  "extensional equivalence (lift continuation)"
  'RingEq A k1 k2 = (lift_exteq A k1 k2).

(* Constructions with lift_exteq ********************************************)

lemma lift_eq_repl (A) (p) (k1) (k2):
      k1 ≗{A} k2 → stream_eq_repl … (λf1,f2. ↑❨k1, f1, p❩ = ↑❨k2, f2, p❩).
#A #p @(path_ind_lift … p) -p [| #n #IH | #n #l0 #q #IH |*: #q #IH ]
#k1 #k2 #f1 #f2 #Hk #Hf
[ <lift_empty <lift_empty /2 width=1 by/
| <lift_d_empty_sn <lift_d_empty_sn <(tr_pap_eq_repl … Hf)
  /3 width=1 by tr_compose_eq_repl, stream_eq_refl/
| <lift_d_lcons_sn <lift_d_lcons_sn
  /3 width=1 by tr_compose_eq_repl, stream_eq_refl/
| /2 width=1 by/
| /3 width=1 by tr_push_eq_repl/
| /3 width=1 by/
| /3 width=1 by/
]
qed-.

(* Advanced constructions ***************************************************)

lemma lift_lcons_alt (A) (k) (f) (p) (l): k ≗ k →
      ↑❨λg,p2. k g (l◗p2), f, p❩ = ↑{A}❨λg,p2. k g ((l◗𝐞)●p2), f, p❩.
#A #k #f #p #l #Hk
@lift_eq_repl // #g1 #g2 #p2 #Hg @Hk -Hk // (**) (* auto fail *)
qed.

lemma lift_append_rcons_sn (A) (k) (f) (p1) (p) (l): k ≗ k →
      ↑❨λg,p2. k g (p1●l◗p2), f, p❩ = ↑{A}❨λg,p2. k g (p1◖l●p2), f, p❩.
#A #k #f #p1 #p #l #Hk
@lift_eq_repl // #g1 #g2 #p2 #Hg
<list_append_rcons_sn @Hk -Hk // (**) (* auto fail *)
qed.

(* Advanced constructions with proj_path ************************************)

lemma proj_path_proper:
      proj_path ≗ proj_path.
// qed.

lemma lift_path_eq_repl (p):
      stream_eq_repl … (λf1,f2. ↑[f1]p = ↑[f2]p).
/2 width=1 by lift_eq_repl/ qed.

lemma lift_path_append_sn (p) (f) (q):
      q●↑[f]p = ↑❨(λg,p. proj_path g (q●p)), f, p❩.
#p @(path_ind_lift … p) -p // [ #n #l #p |*: #p ] #IH #f #q
[ <lift_d_lcons_sn <lift_d_lcons_sn <IH -IH //
| <lift_m_sn <lift_m_sn //
| <lift_L_sn <lift_L_sn >lift_lcons_alt // >lift_append_rcons_sn //
  <IH <IH -IH <list_append_rcons_sn //
| <lift_A_sn <lift_A_sn >lift_lcons_alt >lift_append_rcons_sn //
  <IH <IH -IH <list_append_rcons_sn //
| <lift_S_sn <lift_S_sn >lift_lcons_alt >lift_append_rcons_sn //
  <IH <IH -IH <list_append_rcons_sn //
]
qed.

lemma lift_path_lcons (f) (p) (l):
      l◗↑[f]p = ↑❨(λg,p. proj_path g (l◗p)), f, p❩.
#f #p #l
>lift_lcons_alt <lift_path_append_sn //
qed.

lemma lift_path_L_sn (f) (p):
      (𝗟◗↑[⫯f]p) = ↑[f](𝗟◗p).
// qed.

lemma lift_path_A_sn (f) (p):
      (𝗔◗↑[f]p) = ↑[f](𝗔◗p).
// qed.

lemma lift_path_S_sn (f) (p):
      (𝗦◗↑[f]p) = ↑[f](𝗦◗p).
// qed.

lemma lift_path_after (p) (f1) (f2):
      ↑[f2]↑[f1]p = ↑[f2∘f1]p.
#p @(path_ind_lift … p) -p // [ #n #l #p | #p ] #IH #f1 #f2
[ <lift_path_d_lcons_sn <lift_path_d_lcons_sn
  >(lift_path_eq_repl … (tr_compose_assoc …)) //
| <lift_path_L_sn <lift_path_L_sn <lift_path_L_sn
  >tr_compose_push_bi //
]
qed.
