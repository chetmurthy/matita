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

include "basic_2/relocation/cpy_lift.ma".
include "basic_2/substitution/cpys.ma".

(* CONTEXT-SENSITIVE EXTENDED MULTIPLE SUBSTITUTION FOR TERMS ***************)

(* Advanced properties ******************************************************)

lemma cpys_subst: ∀I,G,L,K,V,U1,i,d,e.
                  d ≤ i → i < d + e →
                  ⇩[0, i] L ≡ K.ⓑ{I}V → ⦃G, K⦄ ⊢ V ▶*×[0, d+e-i-1] U1 →
                  ∀U2. ⇧[0, i + 1] U1 ≡ U2 → ⦃G, L⦄ ⊢ #i ▶*×[d, e] U2.
#I #G #L #K #V #U1 #i #d #e #Hdi #Hide #HLK #H @(cpys_ind … H) -U1
[ /3 width=5 by cpy_cpys, cpy_subst/
| #U #U1 #_ #HU1 #IHU #U2 #HU12
  elim (lift_total U 0 (i+1)) #U0 #HU0
  lapply (IHU … HU0) -IHU #H
  lapply (ldrop_fwd_ldrop2 … HLK) -HLK #HLK
  lapply (cpy_lift_ge … HU1 … HLK HU0 HU12 ?) -HU1 -HLK -HU0 -HU12 // normalize #HU02
  lapply (cpy_weak … HU02 d e ? ?) -HU02 [2,3: /2 width=3 by cpys_strap1, le_S/ ]
  >minus_plus >commutative_plus /2 width=1 by le_minus_to_plus_r/
]
qed.

(* Advanced inverion lemmas *************************************************)

lemma cpys_inv_atom1: ∀G,L,T2,I,d,e. ⦃G, L⦄ ⊢ ⓪{I} ▶*×[d, e] T2 →
                      T2 = ⓪{I} ∨
                      ∃∃J,K,V1,V2,i. d ≤ i & i < d + e &
                                    ⇩[O, i] L ≡ K.ⓑ{J}V1 &
                                     ⦃G, K⦄ ⊢ V1 ▶*×[0, d+e-i-1] V2 &
                                     ⇧[O, i + 1] V2 ≡ T2 &
                                     I = LRef i.
#G #L #T2 #I #d #e #H @(cpys_ind … H) -T2
[ /2 width=1 by or_introl/
| #T #T2 #_ #HT2 *
  [ #H destruct
    elim (cpy_inv_atom1 … HT2) -HT2 [ /2 width=1 by or_introl/ | * /3 width=11 by ex6_5_intro, or_intror/ ]
  | * #J #K #V1 #V #i #Hdi #Hide #HLK #HV1 #HVT #HI
    lapply (ldrop_fwd_ldrop2 … HLK) #H
    elim (cpy_inv_lift1_ge_up … HT2 … H … HVT) normalize -HT2 -H -HVT [2,3,4: /2 width=1 by le_S/ ]
    <minus_plus /4 width=11 by cpys_strap1, ex6_5_intro, or_intror/
  ]
]
qed-.

lemma cpys_inv_lref1: ∀G,L,T2,i,d,e. ⦃G, L⦄ ⊢ #i ▶*×[d, e] T2 →
                      T2 = #i ∨
                      ∃∃I,K,V1,V2. d ≤ i & i < d + e &
                                   ⇩[O, i] L ≡ K.ⓑ{I}V1 &
                                   ⦃G, K⦄ ⊢ V1 ▶*×[0, d + e - i - 1] V2 &
                                   ⇧[O, i + 1] V2 ≡ T2.
#G #L #T2 #i #d #e #H elim (cpys_inv_atom1 … H) -H /2 width=1 by or_introl/
* #I #K #V1 #V2 #j #Hdj #Hjde #HLK #HV12 #HVT2 #H destruct /3 width=7 by ex5_4_intro, or_intror/
qed-.

(* Relocation properties ****************************************************)

lemma cpys_lift_le: ∀G,K,T1,T2,dt,et. ⦃G, K⦄ ⊢ T1 ▶*×[dt, et] T2 →
                    ∀L,U1,d,e. dt + et ≤ d → ⇩[d, e] L ≡ K →
                    ⇧[d, e] T1 ≡ U1 → ∀U2. ⇧[d, e] T2 ≡ U2 →
                    ⦃G, L⦄ ⊢ U1 ▶*×[dt, et] U2.
#G #K #T1 #T2 #dt #et #H #L #U1 #d #e #Hdetd #HLK #HTU1 @(cpys_ind … H) -T2
[ #U2 #H >(lift_mono … HTU1 … H) -H //
| -HTU1 #T #T2 #_ #HT2 #IHT #U2 #HTU2
  elim (lift_total T d e) #U #HTU
  lapply (IHT … HTU) -IHT #HU1
  lapply (cpy_lift_le … HT2 … HLK HTU HTU2 ?) -HT2 -HLK -HTU -HTU2 /2 width=3 by cpys_strap1/
]
qed-.

lemma cpys_lift_be: ∀G,K,T1,T2,dt,et. ⦃G, K⦄ ⊢ T1 ▶*×[dt, et] T2 →
                    ∀L,U1,d,e. dt ≤ d → d ≤ dt + et →
                    ⇩[d, e] L ≡ K → ⇧[d, e] T1 ≡ U1 →
                    ∀U2. ⇧[d, e] T2 ≡ U2 → ⦃G, L⦄ ⊢ U1 ▶*×[dt, et + e] U2.
#G #K #T1 #T2 #dt #et #H #L #U1 #d #e #Hdtd #Hddet #HLK #HTU1 @(cpys_ind … H) -T2
[ #U2 #H >(lift_mono … HTU1 … H) -H //
| -HTU1 #T #T2 #_ #HT2 #IHT #U2 #HTU2
  elim (lift_total T d e) #U #HTU
  lapply (IHT … HTU) -IHT #HU1
  lapply (cpy_lift_be … HT2 … HLK HTU HTU2 ? ?) -HT2 -HLK -HTU -HTU2 /2 width=3 by cpys_strap1/
]
qed-.

lemma cpys_lift_ge: ∀G,K,T1,T2,dt,et. ⦃G, K⦄ ⊢ T1 ▶*×[dt, et] T2 →
                    ∀L,U1,d,e. d ≤ dt → ⇩[d, e] L ≡ K →
                    ⇧[d, e] T1 ≡ U1 → ∀U2. ⇧[d, e] T2 ≡ U2 →
                    ⦃G, L⦄ ⊢ U1 ▶*×[dt + e, et] U2.
#G #K #T1 #T2 #dt #et #H #L #U1 #d #e #Hddt #HLK #HTU1 @(cpys_ind … H) -T2
[ #U2 #H >(lift_mono … HTU1 … H) -H //
| -HTU1 #T #T2 #_ #HT2 #IHT #U2 #HTU2
  elim (lift_total T d e) #U #HTU
  lapply (IHT … HTU) -IHT #HU1
  lapply (cpy_lift_ge … HT2 … HLK HTU HTU2 ?) -HT2 -HLK -HTU -HTU2 /2 width=3 by cpys_strap1/
]
qed-.

lemma cpys_inv_lift1_le: ∀G,L,U1,U2,dt,et. ⦃G, L⦄ ⊢ U1 ▶*×[dt, et] U2 →
                         ∀K,d,e. ⇩[d, e] L ≡ K → ∀T1. ⇧[d, e] T1 ≡ U1 →
                         dt + et ≤ d →
                         ∃∃T2. ⦃G, K⦄ ⊢ T1 ▶*×[dt, et] T2 & ⇧[d, e] T2 ≡ U2.
#G #L #U1 #U2 #dt #et #H #K #d #e #HLK #T1 #HTU1 #Hdetd @(cpys_ind … H) -U2
[ /2 width=3 by ex2_intro/
| -HTU1 #U #U2 #_ #HU2 * #T #HT1 #HTU
  elim (cpy_inv_lift1_le … HU2 … HLK … HTU) -HU2 -HLK -HTU /3 width=3 by cpys_strap1, ex2_intro/
]
qed-.

lemma cpys_inv_lift1_be: ∀G,L,U1,U2,dt,et. ⦃G, L⦄ ⊢ U1 ▶*×[dt, et] U2 →
                         ∀K,d,e. ⇩[d, e] L ≡ K → ∀T1. ⇧[d, e] T1 ≡ U1 →
                         dt ≤ d → d + e ≤ dt + et →
                         ∃∃T2. ⦃G, K⦄ ⊢ T1 ▶*×[dt, et - e] T2 & ⇧[d, e] T2 ≡ U2.
#G #L #U1 #U2 #dt #et #H #K #d #e #HLK #T1 #HTU1 #Hdtd #Hdedet @(cpys_ind … H) -U2
[ /2 width=3 by ex2_intro/
| -HTU1 #U #U2 #_ #HU2 * #T #HT1 #HTU
  elim (cpy_inv_lift1_be … HU2 … HLK … HTU) -HU2 -HLK -HTU /3 width=3 by cpys_strap1, ex2_intro/
]
qed-.

lemma cpys_inv_lift1_ge: ∀G,L,U1,U2,dt,et. ⦃G, L⦄ ⊢ U1 ▶*×[dt, et] U2 →
                         ∀K,d,e. ⇩[d, e] L ≡ K → ∀T1. ⇧[d, e] T1 ≡ U1 →
                         d + e ≤ dt →
                         ∃∃T2. ⦃G, K⦄ ⊢ T1 ▶*×[dt - e, et] T2 & ⇧[d, e] T2 ≡ U2.
#G #L #U1 #U2 #dt #et #H #K #d #e #HLK #T1 #HTU1 #Hdedt @(cpys_ind … H) -U2
[ /2 width=3 by ex2_intro/
| -HTU1 #U #U2 #_ #HU2 * #T #HT1 #HTU
  elim (cpy_inv_lift1_ge … HU2 … HLK … HTU ?) -HU2 -HLK -HTU /3 width=3 by cpys_strap1, ex2_intro/
]
qed-.

lemma cpys_inv_lift1_eq: ∀G,L,U1,U2,d,e.
                         ⦃G, L⦄ ⊢ U1 ▶*×[d, e] U2 → ∀T1. ⇧[d, e] T1 ≡ U1 → U1 = U2.
#G #L #U1 #U2 #d #e #H #T1 #HTU1 @(cpys_ind … H) -U2 //
#U #U2 #_ #HU2 #IHU destruct
<(cpy_inv_lift1_eq … HU2 … HTU1) -HU2 -HTU1 //
qed-.

lemma cpys_inv_lift1_ge_up: ∀G,L,U1,U2,dt,et. ⦃G, L⦄ ⊢ U1 ▶*×[dt, et] U2 →
                            ∀K,d,e. ⇩[d, e] L ≡ K → ∀T1. ⇧[d, e] T1 ≡ U1 →
                            d ≤ dt → dt ≤ d + e → d + e ≤ dt + et →
                            ∃∃T2. ⦃G, K⦄ ⊢ T1 ▶*×[d, dt + et - (d + e)] T2 &
                                 ⇧[d, e] T2 ≡ U2.
#G #L #U1 #U2 #dt #et #H #K #d #e #HLK #T1 #HTU1 #Hddt #Hdtde #Hdedet @(cpys_ind … H) -U2
[ /2 width=3 by ex2_intro/
| -HTU1 #U #U2 #_ #HU2 * #T #HT1 #HTU
  elim (cpy_inv_lift1_ge_up … HU2 … HLK … HTU) -HU2 -HLK -HTU /3 width=3 by cpys_strap1, ex2_intro/
]
qed-.

lemma cpys_inv_lift1_be_up: ∀G,L,U1,U2,dt,et. ⦃G, L⦄ ⊢ U1 ▶*×[dt, et] U2 →
                            ∀K,d,e. ⇩[d, e] L ≡ K → ∀T1. ⇧[d, e] T1 ≡ U1 →
                            dt ≤ d → dt + et ≤ d + e →
                            ∃∃T2. ⦃G, K⦄ ⊢ T1 ▶*×[dt, d - dt] T2 & ⇧[d, e] T2 ≡ U2.
#G #L #U1 #U2 #dt #et #H #K #d #e #HLK #T1 #HTU1 #Hdtd #Hdetde @(cpys_ind … H) -U2
[ /2 width=3 by ex2_intro/
| -HTU1 #U #U2 #_ #HU2 * #T #HT1 #HTU
  elim (cpy_inv_lift1_be_up … HU2 … HLK … HTU) -HU2 -HLK -HTU /3 width=3 by cpys_strap1, ex2_intro/
]
qed-.

lemma cpys_inv_lift1_le_up: ∀G,L,U1,U2,dt,et. ⦃G, L⦄ ⊢ U1 ▶*×[dt, et] U2 →
                            ∀K,d,e. ⇩[d, e] L ≡ K → ∀T1. ⇧[d, e] T1 ≡ U1 →
                            dt ≤ d → d ≤ dt + et → dt + et ≤ d + e →
                            ∃∃T2. ⦃G, K⦄ ⊢ T1 ▶*×[dt, d - dt] T2 & ⇧[d, e] T2 ≡ U2.
#G #L #U1 #U2 #dt #et #H #K #d #e #HLK #T1 #HTU1 #Hdtd #Hddet #Hdetde @(cpys_ind … H) -U2
[ /2 width=3 by ex2_intro/
| -HTU1 #U #U2 #_ #HU2 * #T #HT1 #HTU
  elim (cpy_inv_lift1_le_up … HU2 … HLK … HTU) -HU2 -HLK -HTU /3 width=3 by cpys_strap1, ex2_intro/
]
qed-.
