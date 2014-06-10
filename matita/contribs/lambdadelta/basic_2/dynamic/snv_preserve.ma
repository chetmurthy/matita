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

include "basic_2/computation/fsb_aaa.ma".
include "basic_2/dynamic/snv_da_lpr.ma".
include "basic_2/dynamic/snv_lsstas.ma".
include "basic_2/dynamic/snv_lsstas_lpr.ma".
include "basic_2/dynamic/snv_lpr.ma".

(* STRATIFIED NATIVE VALIDITY FOR TERMS *************************************)

(* Main preservation properties *********************************************)

lemma snv_preserve: ∀h,g,G,L,T. ⦃G, L⦄ ⊢ T ¡[h, g] →
                    ∧∧ IH_da_cpr_lpr h g G L T
                     & IH_snv_cpr_lpr h g G L T
                     & IH_snv_lsstas h g G L T
                     & IH_lsstas_cpr_lpr h g G L T.
#h #g #G #L #T #HT elim (snv_fwd_aaa … HT) -HT
#A #HT @(aaa_ind_fpbg h g … HT) -G -L -T -A
#G #L #T #A #_ #IH -A @and4_intro
[ letin aux ≝ da_cpr_lpr_aux | letin aux ≝ snv_cpr_lpr_aux
| letin aux ≝ snv_lsstas_aux | letin aux ≝ lsstas_cpr_lpr_aux
]
@(aux … G L T) // #G0 #L0 #T0 #H elim (IH … H) -IH -H //
qed-.

theorem da_cpr_lpr: ∀h,g,G,L,T. IH_da_cpr_lpr h g G L T.
#h #g #G #L #T #HT elim (snv_preserve … HT) /2 width=1 by/
qed-.

theorem snv_cpr_lpr: ∀h,g,G,L,T. IH_snv_cpr_lpr h g G L T.
#h #g #G #L #T #HT elim (snv_preserve … HT) /2 width=1 by/
qed-.

theorem snv_lsstas: ∀h,g,G,L,T. IH_snv_lsstas h g G L T.
#h #g #G #L #T #HT elim (snv_preserve … HT) /2 width=5 by/
qed-.

theorem lsstas_cpr_lpr: ∀h,g,G,L,T. IH_lsstas_cpr_lpr h g G L T.
#h #g #G #L #T #HT elim (snv_preserve … HT) /2 width=3 by/
qed-.

(* Advanced preservation properties *****************************************)

lemma snv_cprs_lpr: ∀h,g,G,L1,T1. ⦃G, L1⦄ ⊢ T1 ¡[h, g] →
                    ∀T2. ⦃G, L1⦄ ⊢ T1 ➡* T2 → ∀L2. ⦃G, L1⦄ ⊢ ➡ L2 → ⦃G, L2⦄ ⊢ T2 ¡[h, g].
#h #g #G #L1 #T1 #HT1 #T2 #H
@(cprs_ind … H) -T2 /3 width=5 by snv_cpr_lpr/
qed-.

lemma da_cprs_lpr: ∀h,g,G,L1,T1. ⦃G, L1⦄ ⊢ T1 ¡[h, g] →
                   ∀l. ⦃G, L1⦄ ⊢ T1 ▪[h, g] l →
                   ∀T2. ⦃G, L1⦄ ⊢ T1 ➡* T2 → ∀L2. ⦃G, L1⦄ ⊢ ➡ L2 → ⦃G, L2⦄ ⊢ T2 ▪[h, g] l.
#h #g #G #L1 #T1 #HT1 #l #Hl #T2 #H
@(cprs_ind … H) -T2 /3 width=6 by snv_cprs_lpr, da_cpr_lpr/
qed-.

lemma da_cpcs: ∀h,g,G,L,T1. ⦃G, L⦄ ⊢ T1 ¡[h, g] →
               ∀T2. ⦃G, L⦄ ⊢ T2 ¡[h, g] →
               ∀l1. ⦃G, L⦄ ⊢ T1 ▪[h, g] l1 → ∀l2. ⦃G, L⦄ ⊢ T2 ▪[h, g] l2 →
               ⦃G, L⦄ ⊢ T1 ⬌* T2 → l1 = l2.
#h #g #G #L #T1 #HT1 #T2 #HT2 #l1 #Hl1 #l2 #Hl2 #H
elim (cpcs_inv_cprs … H) -H /3 width=12 by da_cprs_lpr, da_mono/
qed-.

lemma ssta_cpr_lpr: ∀h,g,G,L1,T1. ⦃G, L1⦄ ⊢ T1 ¡[h, g] →
                    ∀l. ⦃G, L1⦄ ⊢ T1 ▪[h, g] l+1 →
                    ∀U1. ⦃G, L1⦄ ⊢ T1 •[h, g] U1 →
                    ∀T2. ⦃G, L1⦄ ⊢ T1 ➡ T2 → ∀L2. ⦃G, L1⦄ ⊢ ➡ L2 →
                    ∃∃U2. ⦃G, L2⦄ ⊢ T2 •[h, g] U2 & ⦃G, L2⦄ ⊢ U1 ⬌* U2.
#h #g #G #L1 #T1 #HT1 #l #Hl #U1 #HTU1 #T2 #HT12 #L2 #HL12
elim (lsstas_cpr_lpr  … 1 … Hl U1 … HT12 … HL12) -Hl -HT12 -HL12
/3 width=3 by lsstas_inv_SO, ssta_lsstas, ex2_intro/
qed-.

lemma lsstas_cprs_lpr: ∀h,g,G,L1,T1. ⦃G, L1⦄ ⊢ T1 ¡[h, g] →
                       ∀l1,l2. l2 ≤ l1 → ⦃G, L1⦄ ⊢ T1 ▪[h, g] l1 →
                       ∀U1. ⦃G, L1⦄ ⊢ T1 •*[h, g, l2] U1 →
                       ∀T2. ⦃G, L1⦄ ⊢ T1 ➡* T2 → ∀L2. ⦃G, L1⦄ ⊢ ➡ L2 →
                       ∃∃U2. ⦃G, L2⦄ ⊢ T2 •*[h, g, l2] U2 & ⦃G, L2⦄ ⊢ U1 ⬌* U2.
#h #g #G #L1 #T1 #HT1 #l1 #l2 #Hl21 #Hl1 #U1 #HTU1 #T2 #H
@(cprs_ind … H) -T2 [ /2 width=9 by lsstas_cpr_lpr/ ]
#T #T2 #HT1T #HTT2 #IHT1 #L2 #HL12
elim (IHT1 L1) // -IHT1 #U #HTU #HU1
elim (lsstas_cpr_lpr … Hl21 … HTU … HTT2 … HL12) -HTU -HTT2
[2,3: /2 width=6 by snv_cprs_lpr, da_cprs_lpr/ ] -T1 -T -l1
/4 width=5 by lpr_cpcs_conf, cpcs_trans, ex2_intro/
qed-.

lemma lsstas_cpcs_lpr: ∀h,g,G,L1,T1. ⦃G, L1⦄ ⊢ T1 ¡[h, g] →
                       ∀l,l1. l ≤ l1 → ⦃G, L1⦄ ⊢ T1 ▪[h, g] l1 → ∀U1. ⦃G, L1⦄ ⊢ T1 •*[h, g, l] U1 →
                       ∀T2. ⦃G, L1⦄ ⊢ T2 ¡[h, g] →
                       ∀l2. l ≤ l2 → ⦃G, L1⦄ ⊢ T2 ▪[h, g] l2 → ∀U2. ⦃G, L1⦄ ⊢ T2 •*[h, g, l] U2 →
                       ⦃G, L1⦄ ⊢ T1 ⬌* T2 → ∀L2. ⦃G, L1⦄ ⊢ ➡ L2 → ⦃G, L2⦄ ⊢ U1 ⬌* U2.
#h #g #G #L1 #T1 #HT1 #l #l1 #Hl1 #HTl1 #U1 #HTU1 #T2 #HT2 #l2 #Hl2 #HTl2 #U2 #HTU2 #H #L2 #HL12
elim (cpcs_inv_cprs … H) -H #T #H1 #H2
elim (lsstas_cprs_lpr … HT1 … Hl1 HTl1 … HTU1 … H1 … HL12) -T1 #W1 #H1 #HUW1
elim (lsstas_cprs_lpr … HT2 … Hl2 HTl2 … HTU2 … H2 … HL12) -T2 #W2 #H2 #HUW2
lapply (lsstas_mono … H1 … H2) -h -T -l #H destruct /2 width=3 by cpcs_canc_dx/
qed-.

lemma snv_ssta: ∀h,g,G,L,T. ⦃G, L⦄ ⊢ T ¡[h, g] →
                ∀l. ⦃G, L⦄ ⊢ T ▪[h, g] l+1 →
                ∀U. ⦃G, L⦄ ⊢ T •[h, g] U → ⦃G, L⦄ ⊢ U ¡[h, g].
/3 width=7 by lsstas_inv_SO, ssta_lsstas, snv_lsstas/ qed-.

lemma lsstas_cpds: ∀h,g,G,L,T1. ⦃G, L⦄ ⊢ T1 ¡[h, g] →
                   ∀l1,l2. l2 ≤ l1 → ⦃G, L⦄ ⊢ T1 ▪[h, g] l1 →
                   ∀U1. ⦃G, L⦄ ⊢ T1 •*[h, g, l2] U1 → ∀T2. ⦃G, L⦄ ⊢ T1 •*➡*[h, g] T2 →
                   ∃∃U2,l. l ≤ l2 & ⦃G, L⦄ ⊢ T2 •*[h, g, l] U2 & ⦃G, L⦄ ⊢ U1 •*⬌*[h, g] U2.
#h #g #G #L #T1 #HT1 #l1 #l2 #Hl21 #Hl1 #U1 #HTU1 #T2 * #T #l0 #l #Hl0 #H #HT1T #HTT2
lapply (da_mono … H … Hl1) -H #H destruct
lapply (lsstas_da_conf … HTU1 … Hl1) #Hl12
elim (le_or_ge l2 l) #Hl2
[ lapply (lsstas_conf_le … HTU1 … HT1T) -HT1T //
  /5 width=11 by cpds_cpes_dx, monotonic_le_minus_l, ex3_2_intro, ex4_3_intro/
| lapply (lsstas_da_conf … HT1T … Hl1) #Hl1l
  lapply (lsstas_conf_le … HT1T … HTU1) -HTU1 // #HTU1
  elim (lsstas_cprs_lpr … Hl1l … HTU1 … HTT2 L) -Hl1l -HTU1 -HTT2
  /3 width=7 by snv_lsstas, cpcs_cpes, monotonic_le_minus_l, ex3_2_intro/
]
qed-.

lemma cpds_cpr_lpr: ∀h,g,G,L1,T1. ⦃G, L1⦄ ⊢ T1 ¡[h, g] →
                    ∀U1. ⦃G, L1⦄ ⊢ T1 •*➡*[h, g] U1 →
                    ∀T2. ⦃G, L1⦄ ⊢ T1 ➡ T2 → ∀L2. ⦃G, L1⦄ ⊢ ➡ L2 →
                    ∃∃U2. ⦃G, L2⦄ ⊢ T2 •*➡*[h, g] U2 & ⦃G, L2⦄ ⊢ U1 ➡* U2.
#h #g #G #L1 #T1 #HT1 #U1 * #W1 #l1 #l2 #Hl21 #Hl1 #HTW1 #HWU1 #T2 #HT12 #L2 #HL12
elim (lsstas_cpr_lpr … HTW1 … HT12 … HL12) // #W2 #HTW2 #HW12
lapply (da_cpr_lpr … Hl1 … HT12 … HL12) // -T1
lapply (lpr_cprs_conf … HL12 … HWU1) -L1 #HWU1
lapply (cpcs_canc_sn … HW12 HWU1) -W1 #H
elim (cpcs_inv_cprs … H) -H /3 width=7 by ex4_3_intro, ex2_intro/
qed-.
