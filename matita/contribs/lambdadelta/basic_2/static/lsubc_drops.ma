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

include "basic_2/static/aaa_drops.ma".
include "basic_2/static/lsubc.ma".

(* LOCAL ENVIRONMENT REFINEMENT FOR GENERIC REDUCIBILITY ********************)

(* Properties with generic slicing ******************************************)

(* Note: the premise 𝐔⦃f⦄ cannot be removed *)
(* Basic_1: includes: csubc_drop_conf_O *)
(* Basic_2A1: includes: lsubc_drop_O1_trans *)
lemma lsubc_drops_trans_isuni: ∀RP,G,L1,L2. G ⊢ L1 ⫃[RP] L2 →
                               ∀b,f,K2. 𝐔⦃f⦄ → ⬇*[b, f] L2 ≡ K2 →
                               ∃∃K1. ⬇*[b, f] L1 ≡ K1 & G ⊢ K1 ⫃[RP] K2.
#RP #G #L1 #L2 #H elim H -L1 -L2
[ /2 width=3 by ex2_intro/
| #I #L1 #L2 #V #HL12 #IH #b #f #K2 #Hf #H
  elim (drops_inv_pair1_isuni … Hf H) -Hf -H *
  [ #Hf #H destruct -IH
    /3 width=3 by lsubc_pair, drops_refl, ex2_intro/
  | #g #Hg #HLK2 #H destruct -HL12
    elim (IH … Hg HLK2) -L2 -Hg /3 width=3 by drops_drop, ex2_intro/
  ]
| #L1 #L2 #V #W #A #HV #H1W #H2W #HL12 #IH #b #f #K2 #Hf #H
  elim (drops_inv_pair1_isuni … Hf H) -Hf -H *
  [ #Hf #H destruct -IH
    /3 width=8 by drops_refl, lsubc_beta, ex2_intro/
  | #g #Hg #HLK2 #H destruct -HL12
    elim (IH … Hg HLK2) -L2 -Hg /3 width=3 by drops_drop, ex2_intro/
  ]
]
qed-.

(* Basic_1: was: csubc_drop1_conf_rev *)
(* Basic_1: includes: csubc_drop_conf_rev *)
(* Basic_2A1: includes: drop_lsubc_trans *)
lemma drops_lsubc_trans: ∀RR,RS,RP. gcp RR RS RP →
                         ∀b,f,G,L1,K1. ⬇*[b, f] L1 ≡ K1 → ∀K2. G ⊢ K1 ⫃[RP] K2 →
                         ∃∃L2. G ⊢ L1 ⫃[RP] L2 & ⬇*[b, f] L2 ≡ K2.
#RR #RS #RP #HR #b #f #G #L1 #K1 #H elim H -f -L1 -K1
[ #f #Hf #Y #H lapply (lsubc_inv_atom1 … H) -H
  #H destruct /4 width=3 by lsubc_atom, drops_atom, ex2_intro/
| #f #I #L1 #K1 #V1 #_ #IH #K2 #HK12 elim (IH … HK12) -K1
  /3 width=5 by lsubc_pair, drops_drop, ex2_intro/
| #f #I #L1 #K1 #V1 #V2 #HLK1 #HV21 #IH #X #H elim (lsubc_inv_pair1 … H) -H *
  [ #K2 #HK12 #H destruct -HLK1
    elim (IH … HK12) -K1 /3 width=5 by lsubc_pair, drops_skip, ex2_intro/
  | #K2 #V #W2 #A #HV #H1W2 #H2W2 #HK12 #H1 #H2 #H3 destruct
    elim (lifts_inv_flat1 … HV21) -HV21 #W3 #V3 #HW23 #HV3 #H destruct
    elim (IH … HK12) -IH -HK12 #K #HL1K #HK2
    lapply (acr_lifts … HR … HV … HLK1 … HV3) -HV
    lapply (acr_lifts … HR … H1W2 … HLK1 … HW23) -H1W2
    /4 width=10 by lsubc_beta, aaa_lifts, drops_skip, ex2_intro/
  ]
]
qed-.
