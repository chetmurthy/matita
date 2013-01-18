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

include "paths/standard_trace.ma".
include "paths/labeled_sequential_computation.ma".
include "paths/labeled_st_reduction.ma".

(* PATH-LABELED STANDARD COMPUTATION (MULTISTEP) ****************************)

(* Note: lstar shuld be replaced by l_sreds *)
definition pl_sts: trace → relation subterms ≝ lstar … pl_st.

interpretation "path-labeled standard reduction"
    'StdStar F p G = (pl_sts p F G).

notation "hvbox( F break Ⓡ ↦* [ term 46 p ] break term 46 G )"
   non associative with precedence 45
   for @{ 'StdStar $F $p $G }.

lemma pl_sts_fwd_pl_sreds: ∀s,F1,F2. F1 Ⓡ↦*[s] F2 → ⇓F1 ↦*[s] ⇓F2.
#s #F1 #F2 #H @(lstar_ind_r … s F2 H) -s -F2 //
#p #s #F #F2 #_ #HF2 #IHF1
lapply (pl_st_fwd_pl_sred … HF2) -HF2 /2 width=3/
qed-.

lemma pl_sts_inv_pl_sreds: ∀s,M1,F2. {⊤}⇑M1 Ⓡ↦*[s] F2 → is_whd s →
                           ∃∃M2. M1 ↦*[s] M2 & {⊤}⇑M2 = F2.
#s #M1 #F2 #H @(lstar_ind_r … s F2 H) -s -F2 /2 width=3/
#p #s #F #F2 #_ #HF2 #IHF #H
elim (is_whd_inv_append … H) -H #Hs * #Hp #_
elim (IHF Hs) -IHF -Hs #M #HM #H destruct
elim (pl_st_inv_pl_sred … HF2) -HF2 // -Hp #M2 #HM2 #H
lapply (pl_sreds_step_dx … HM … HM2) -M /2 width=3/
qed-.

lemma pl_sts_refl: reflexive … (pl_sts (◊)).
//
qed.

lemma pl_sts_step_sn: ∀p,F1,F. F1 Ⓡ↦[p] F → ∀s,F2. F Ⓡ↦*[s] F2 → F1 Ⓡ↦*[p::s] F2.
/2 width=3/
qed-.

lemma pl_sts_step_dx: ∀s,F1,F. F1 Ⓡ↦*[s] F → ∀p,F2. F Ⓡ↦[p] F2 → F1 Ⓡ↦*[s@p::◊] F2.
/2 width=3/
qed-.

lemma pl_sts_step_rc: ∀p,F1,F2. F1 Ⓡ↦[p] F2 → F1 Ⓡ↦*[p::◊] F2.
/2 width=1/
qed.

lemma pl_sts_inv_nil: ∀s,F1,F2. F1 Ⓡ↦*[s] F2 → ◊ = s → F1 = F2.
/2 width=5 by lstar_inv_nil/
qed-.

lemma pl_sts_inv_cons: ∀s,F1,F2. F1 Ⓡ↦*[s] F2 → ∀q,r. q::r = s →
                       ∃∃F. F1 Ⓡ↦[q] F & F Ⓡ↦*[r] F2.
/2 width=3 by lstar_inv_cons/
qed-.

lemma pl_sts_inv_step_rc: ∀p,F1,F2. F1 Ⓡ↦*[p::◊] F2 → F1 Ⓡ↦[p] F2.
/2 width=1 by lstar_inv_step/
qed-.

lemma pl_sts_inv_pos: ∀s,F1,F2. F1 Ⓡ↦*[s] F2 → 0 < |s| →
                      ∃∃p,r,F. p::r = s & F1 Ⓡ↦[p] F & F Ⓡ↦*[r] F2.
/2 width=1 by lstar_inv_pos/
qed-.

lemma pl_sts_inv_rc_abst_dx: ∀b2,s,F1,T2. F1 Ⓡ↦*[s] {b2}𝛌.T2 → ∀r. rc:::r = s →
                             ∃∃b1,T1. T1 Ⓡ↦*[r] T2 & {b1}𝛌.T1 = F1.
#b2 #s #F1 #T2 #H @(lstar_ind_l … s F1 H) -s -F1
[ #r #H lapply (map_cons_inv_nil … r H) -H #H destruct /2 width=4/
| #p #s #F1 #F #HF1 #_ #IHF2 #r #H -b2
  elim (map_cons_inv_cons … r H) -H #q #r0 #Hp #Hs #Hr
  elim (pl_st_inv_rc … HF1 … Hp) -HF1 -p #b1 #T1 #T #HT1 #HF1 #HF destruct
  elim (IHF2 ??) -IHF2 [3: // |2: skip ] (**) (* simplify line *)
  #b0 #T0 #HT02 #H destruct
  lapply (pl_sts_step_sn … HT1 … HT02) -T /2 width=4/
]
qed-.

lemma pl_sts_lift: ∀s. sliftable (pl_sts s).
/2 width=1/
qed.

lemma pl_sts_inv_lift: ∀s. sdeliftable_sn (pl_sts s).
/3 width=3 by lstar_sdeliftable_sn, pl_st_inv_lift/
qed-.

lemma pl_sts_dsubst: ∀s. sdsubstable_f_dx … (booleanized ⊥) (pl_sts s).
/2 width=1/
qed.

theorem pl_sts_mono: ∀s. singlevalued … (pl_sts s).
/3 width=7 by lstar_singlevalued, pl_st_mono/
qed-.

theorem pl_sts_trans: ltransitive … pl_sts.
/2 width=3 by lstar_ltransitive/
qed-.

theorem pl_sts_inv_trans: inv_ltransitive … pl_sts.
/2 width=3 by lstar_inv_ltransitive/
qed-.

theorem pl_sts_fwd_is_standard: ∀s,F1,F2. F1 Ⓡ↦*[s] F2 → is_standard s.
#s elim s -s // #p1 * //
#p2 #s #IHs #F1 #F2 #H
elim (pl_sts_inv_cons … H ???) -H [4: // |2,3: skip ] #F3 #HF13 #H (**) (* simplify line *)
elim (pl_sts_inv_cons … H ???) [2: // |3,4: skip ] #F4 #HF34 #_ (**) (* simplify line *)
lapply (pl_st_fwd_sle … HF13 … HF34) -F1 -F4 /3 width=3/
qed-.

lemma pl_sts_fwd_abst_dx: ∀b2,s,F1,T2. F1 Ⓡ↦*[s] {b2}𝛌.T2 →
                          (∃r2. rc:::r2 = s) ∨ ∃∃r1,r2. r1@◊::rc:::r2 = s.
#b2 #s #F1 #T2 #H
lapply (pl_sts_fwd_is_standard … H)
@(lstar_ind_l … s F1 H) -s -F1
[ #_ @or_introl @(ex_intro … ◊) // (**) (* auto needs some help here *)
| * [ | * #p ] #s #F1 #F #HF1 #HF #IHF #Hs
  lapply (is_standard_fwd_cons … Hs) #H
  elim (IHF H) -IHF -H * [2,4,6,8: #r1 ] #r2 #H destruct
(* case 1: ◊, @ *)
  [ -Hs -F1 -F -T2 -b2
    @or_intror @(ex1_2_intro … (◊::r1) r2) // (**) (* auto needs some help here *)
(* case 2: rc, @ *)
  | -F1 -F -T2 -b2
    lapply (is_standard_fwd_sle … Hs) -Hs #H
    lapply (sle_nil_inv_in_whd … H) -H * #H #_ destruct
(* case 3: sn, @ *)
  | -F1 -F -T2 -b2
    lapply (is_standard_fwd_sle … Hs) -Hs #H
    lapply (sle_nil_inv_in_whd … H) -H * #H #_ destruct
(* case 4: dx, @ *)
  | -Hs -F1 -F -T2 -b2
    @or_intror @(ex1_2_intro … ((dx::p)::r1) r2) // (**) (* auto needs some help here *)
(* case 5: ◊, no @ *)
  | -Hs -F1 -F -T2 -b2
    @or_intror @(ex1_2_intro … ◊ r2) // (**) (* auto needs some help here *)
(* case 6, rc, no @ *)
  | -Hs -F1 -F -T2 -b2
    @or_introl @(ex_intro … (p::r2)) // (**) (* auto needs some help here *)
(* case 7: sn, no @ *)
  | elim (pl_sts_inv_rc_abst_dx … HF ??) -b2 [3: // |2: skip ] (**) (* simplify line *)
    #b #T #_ #HT -Hs -T2
    elim (pl_st_inv_sn … HF1 ??) -HF1 [3: // |2: skip ] (**) (* simplify line *)
    #c #V1 #V #T0 #_ #_ #HT0 -c -V1 -F1 destruct
(* case 8: dx, no @ *)
  | elim (pl_sts_inv_rc_abst_dx … HF ??) -b2 [3: // |2: skip ] (**) (* simplify line *)
    #b #T #_ #HT -Hs -T2
    elim (pl_st_inv_dx … HF1 ??) -HF1 [3: // |2: skip ] (**) (* simplify line *)
    #c #V #T1 #T0 #_ #_ #HT0 -T1 -F1 destruct
  ]
]
qed-.

lemma pl_sts_fwd_abst_dx_is_whd: ∀b2,s,F1,T2. F1 Ⓡ↦*[s] {b2}𝛌.T2 →
                                 ∃∃r1,r2. is_whd r1 & r1@rc:::r2 = s.
#b2 #s #F1 #T2 #H
lapply (pl_sts_fwd_is_standard … H)
elim (pl_sts_fwd_abst_dx … H) -b2 -F1 -T2 * [ | #r1 ] #r2 #Hs destruct
[ #_ @(ex2_2_intro … ◊ r2) //
| <(associative_append … r1 (◊::◊) (rc:::r2)) #Hs
  lapply (is_standard_fwd_append_sn … Hs) -Hs #H
  lapply (is_standard_fwd_is_whd … H) -H // /4 width=4/
]
qed-.

axiom pl_sred_is_standard_pl_st: ∀p,M,M2. M ↦[p] M2 → ∀F. ⇓F = M →
                                 ∀s,M1.{⊤}⇑ M1 Ⓡ↦*[s] F →
                                 is_standard (s@(p::◊)) →
                                 ∃∃F2. F Ⓡ↦[p] F2 & ⇓F2 = M2.
(*
#p #M #M2 #H elim H -p -M -M2
[ #B #A #F #HF #s #M1 #HM1 #Hs
  lapply (is_standard_fwd_is_whd … Hs) -Hs // #Hs
  elim (pl_sts_inv_pl_sreds … HM1 Hs) -HM1 -Hs #M #_ #H -s -M1 destruct
  >carrier_boolean in HF; #H destruct normalize /2 width=3/
| #p #A1 #A2 #_ #IHA12 #F #HF #s #M1 #HM1 #Hs
  elim (carrier_inv_abst … HF) -HF #b #T #HT #HF destruct
  elim (pl_sts_fwd_abst_dx_is_whd … HM1) #r1 #r2 #Hr1 #H destruct
  elim (pl_sts_inv_trans … HM1) -HM1 #F0 #HM1 #HT
  elim (pl_sts_inv_pl_sreds … HM1 ?) // #M0 #_ #H -M1 -Hr1 destruct
  elim (pl_sts_inv_rc_abst_dx … HT ??) -HT [3: // |2: skip ] #b0 #T0 #HT02 #H (**) (* simplify line *)
  elim (boolean_inv_abst … (sym_eq … H)) -H #A0 #_ #H #_ -b0 -M0 destruct
  >associative_append in Hs; #Hs
  lapply (is_standard_fwd_append_dx … Hs) -r1
  <(map_cons_append … r2 (p::◊)) #H
  lapply (is_standard_inv_compatible_rc … H) -H #H
  elim (IHA12 … HT02 ?) // -r2 -A0 -IHA12 #F2 #HF2 #H
  @(ex2_intro … ({⊥}𝛌.F2)) normalize // /2 width=1/ (**) (* auto needs some help here *)  
(*  
  elim (carrier_inv_appl … HF) -HF #b1 #V #G #HV #HG #HF
*)  
*)
theorem pl_sreds_is_standard_pl_sts: ∀s,M1,M2. M1 ↦*[s] M2 → is_standard s →
                                     ∃∃F2. {⊤}⇑ M1 Ⓡ↦*[s] F2 & ⇓F2 = M2.
#s #M1 #M2 #H @(lstar_ind_r … s M2 H) -s -M2 /2 width=3/
#p #s #M #M2 #_ #HM2 #IHM1 #Hsp
lapply (is_standard_fwd_append_sn … Hsp) #Hs
elim (IHM1 Hs) -IHM1 -Hs #F #HM1 #H
elim (pl_sred_is_standard_pl_st … HM2 … HM1 ?) -HM2 // -M -Hsp #F2 #HF2 #HFM2
lapply (pl_sts_step_dx … HM1 … HF2) -F
#H @(ex2_intro … F2) // (**) (* auto needs some help here *)
qed-.
