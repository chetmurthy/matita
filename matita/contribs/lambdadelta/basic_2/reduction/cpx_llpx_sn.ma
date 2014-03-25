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

include "basic_2/relocation/llpx_sn_ldrop.ma".
include "basic_2/reduction/cpx.ma".

(* CONTEXT-SENSITIVE EXTENDED PARALLEL REDUCTION FOR TERMS ******************)

(* Properties on lazy sn pointwise extensions *******************************)

(* Note: lemma 1000 *)
lemma llpx_sn_cpx_conf: ∀R. (∀L. reflexive … (R L)) → l_liftable R → l_deliftable_sn R →
                        ∀h,g,G. s_r_confluent1 … (cpx h g G) (llpx_sn R 0).
#R #H1R #H2R #H3R #h #g #G #Ls #T1 #T2 #H elim H -G -Ls -T1 -T2
[ //
| /3 width=4 by llpx_sn_fwd_length, llpx_sn_sort/
| #I #G #Ls #Ks #V1s #V2s #W2s #i #HLKs #_ #HVW2s #IHV12s #Ld #H elim (llpx_sn_inv_lref_ge_sn … H … HLKs) // -H
  #Kd #V1d #HLKd #HV1s #HV1sd
  lapply (ldrop_fwd_drop2 … HLKs) -HLKs #HLKs
  lapply (ldrop_fwd_drop2 … HLKd) -HLKd #HLKd
  @(llpx_sn_lift_le … HLKs HLKd … HVW2s) -HLKs -HLKd -HVW2s /2 width=1 by/ (**) (* full auto too slow *)
| #a #I #G #Ls #V1 #V2 #T1 #T2 #_ #_ #IHV12 #IHT12 #Ld #H elim (llpx_sn_inv_bind_O … H) -H
  /4 width=5 by llpx_sn_bind_repl_SO, llpx_sn_bind/
| #I #G #Ls #V1 #V2 #T1 #T2 #_ #_ #IHV12 #IHT12 #Ld #H elim (llpx_sn_inv_flat … H) -H
  /3 width=1 by llpx_sn_flat/
| #G #Ls #V #T1 #T2 #T #_ #HT2 #IHT12 #Ld #H elim (llpx_sn_inv_bind_O … H) -H
  /3 width=10 by llpx_sn_inv_lift_le, ldrop_drop/
| #G #Ls #V #T1 #T2 #_ #IHT12 #Ld #H elim (llpx_sn_inv_flat … H) -H /2 width=1 by/
| #G #Ls #V1 #V2 #T #_ #IHV12 #Ld #H elim (llpx_sn_inv_flat … H) -H /2 width=1 by/
| #a #G #Ls #V1 #V2 #W1 #W2 #T1 #T2 #_ #_ #_ #IHV12 #IHW12 #IHT12 #Ld #H elim (llpx_sn_inv_flat … H) -H
  #HV1 #H elim (llpx_sn_inv_bind_O … H) -H
  /4 width=5 by llpx_sn_bind_repl_SO, llpx_sn_flat, llpx_sn_bind/
| #a #G #Ls #V1 #V2 #V #W1 #W2 #T1 #T2 #_ #HV2 #_ #_ #IHV12 #IHW12 #IHT12 #Ld #H elim (llpx_sn_inv_flat … H) -H
  #HV1 #H elim (llpx_sn_inv_bind_O … H) -H //
  #HW1 #HT1 @llpx_sn_bind_O /2 width=1 by/ @llpx_sn_flat (**) (* full auto too slow *)
  [ /3 width=10 by llpx_sn_lift_le, ldrop_drop/
  | /3 width=4 by llpx_sn_bind_repl_O/
]
qed-.
