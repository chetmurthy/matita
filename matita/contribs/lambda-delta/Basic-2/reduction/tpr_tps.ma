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

include "Basic-2/substitution/tps_tps.ma".
include "Basic-2/substitution/ltps_tps.ma".
include "Basic-2/reduction/ltpr_drop.ma".

(* CONTEXT-FREE PARALLEL REDUCTION ON TERMS *********************************)

(* Note: the constant 1 comes from tps_subst *)
(* Basic-1: was: pr0_subst1 *)
lemma tpr_tps_ltpr: ∀T1,T2. T1 ⇒ T2 →
                    ∀L1,d,U1. L1 ⊢ T1 [d, 1] ≫ U1 →
                    ∀L2. L1 ⇒ L2 →
                    ∃∃U2. U1 ⇒ U2 & L2 ⊢ T2 [d, 1] ≫ U2.
#T1 #T2 #H elim H -H T1 T2
[ #I #L1 #d #X #H
  elim (tps_inv_atom1 … H) -H
  [ #H destruct -X /2/
  | * #K1 #V1 #i #Hdi #Hide #HLK1 #HVU1 #H #L2 #HL12 destruct -I;
    elim (ltpr_drop_conf … HLK1 … HL12) -HLK1 HL12 #X #HLK2 #H
    elim (ltpr_inv_pair1 … H) -H #K2 #V2 #_ #HV12 #H destruct -X;
    elim (lift_total V2 0 (i+1)) #U2 #HVU2
    lapply (tpr_lift … HV12 … HVU1 … HVU2) -HV12 HVU1 #HU12
    @ex2_1_intro [2: @HU12 | skip | /2/ ] (**) (* /3 width=6/ is too slow *)
  ]
| #I #V1 #V2 #T1 #T2 #_ #_ #IHV12 #IHT12 #L1 #d #X #H #L2 #HL12
  elim (tps_inv_flat1 … H) -H #W1 #U1 #HVW1 #HTU1 #H destruct -X;
  elim (IHV12 … HVW1 … HL12) -IHV12 HVW1;
  elim (IHT12 … HTU1 … HL12) -IHT12 HTU1 HL12 /3 width=5/
| #V1 #V2 #W #T1 #T2 #_ #_ #IHV12 #IHT12 #L1 #d #X #H #L2 #HL12
  elim (tps_inv_flat1 … H) -H #VV1 #Y #HVV1 #HY #HX destruct -X;
  elim (tps_inv_bind1 … HY) -HY #WW #TT1 #_ #HTT1 #H destruct -Y;
  elim (IHV12 … HVV1 … HL12) -IHV12 HVV1 #VV2 #HVV12 #HVV2
  elim (IHT12 … HTT1 (L2. 𝕓{Abst} WW) ?) -IHT12 HTT1 /2/ -HL12 #TT2 #HTT12 #HTT2
  lapply (tps_leq_repl_dx … HTT2 (L2. 𝕓{Abbr} VV2) ?) -HTT2 /3 width=5/
| #I #V1 #V2 #T1 #T2 #U2 #HV12 #_ #HTU2 #IHV12 #IHT12 #L1 #d #X #H #L2 #HL12
  elim (tps_inv_bind1 … H) -H #VV1 #TT1 #HVV1 #HTT1 #H destruct -X;
  elim (IHV12 … HVV1 … HL12) -IHV12 HVV1 #VV2 #HVV12 #HVV2
  elim (IHT12 … HTT1 (L2. 𝕓{I} VV2) ?) -IHT12 HTT1 /2/ -HL12 #TT2 #HTT12 #HTT2
  elim (tps_conf_neq … HTT2 … HTU2 ?) -HTT2 HTU2 T2 /2/ #T2 #HTT2 #HUT2
  lapply (tps_leq_repl_dx … HTT2 (L2. 𝕓{I} V2) ?) -HTT2 /2/ #HTT2
  elim (ltps_tps_conf … HTT2 (L2. 𝕓{I} VV2) (d + 1) 1 ?) -HTT2 /2/ #W2 #HTTW2 #HTW2
  lapply (tps_leq_repl_dx … HTTW2 (⋆. 𝕓{I} VV2) ?) -HTTW2 /2/ #HTTW2
  lapply (tps_trans_ge … HUT2 … HTW2 ?) -HUT2 HTW2 // #HUW2
  /3 width=5/
| #V #V1 #V2 #W1 #W2 #T1 #T2 #_ #HV2 #_ #_ #IHV12 #IHW12 #IHT12 #L1 #d #X #H #L2 #HL12
  elim (tps_inv_flat1 … H) -H #VV1 #Y #HVV1 #HY #HX destruct -X;
  elim (tps_inv_bind1 … HY) -HY #WW1 #TT1 #HWW1 #HTT1 #H destruct -Y;
  elim (IHV12 … HVV1 … HL12) -IHV12 HVV1 #VV2 #HVV12 #HVV2
  elim (IHW12 … HWW1 … HL12) -IHW12 HWW1 #WW2 #HWW12 #HWW2
  elim (IHT12 … HTT1 (L2. 𝕓{Abbr} WW2) ?) -IHT12 HTT1 /2/ -HL12 #TT2 #HTT12 #HTT2
  elim (lift_total VV2 0 1) #VV #H2VV
  lapply (tps_lift_ge … HVV2 (L2. 𝕓{Abbr} WW2) … HV2 H2VV ?) -HVV2 HV2 /2/ #HVV
  @ex2_1_intro [2: @tpr_theta |1: skip |3: @tps_bind [2: @tps_flat ] ] /width=11/ (**) (* /4 width=11/ is too slow *)
| #V1 #TT1 #T1 #T2 #HT1 #_ #IHT12 #L1 #d #X #H #L2 #HL12
  elim (tps_inv_bind1 … H) -H #V2 #TT2 #HV12 #HTT12 #H destruct -X;
  elim (tps_inv_lift1_ge … HTT12 L1 … HT1 ?) -HTT12 HT1 /2/ #T2 #HT12 #HTT2
  elim (IHT12 … HT12 … HL12) -IHT12 HT12 HL12 <minus_plus_m_m /3/
| #V1 #T1 #T2 #_ #IHT12 #L1 #d #X #H #L2 #HL12
  elim (tps_inv_flat1 … H) -H #VV1 #TT1 #HVV1 #HTT1 #H destruct -X;
  elim (IHT12 … HTT1 … HL12) -IHT12 HTT1 HL12 /3/
]
qed.

lemma tpr_tps_bind: ∀I,V1,V2,T1,T2,U1. V1 ⇒ V2 → T1 ⇒ T2 →
                    ⋆. 𝕓{I} V1 ⊢ T1 [0, 1] ≫ U1 →
                    ∃∃U2. U1 ⇒ U2 & ⋆. 𝕓{I} V2 ⊢ T2 [0, 1] ≫ U2.
/3 width=7/ qed.
