(* Properties on supclosure *************************************************)

lemma lpx_fqup_trans: ∀h,o,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ⊐+ ⦃G2, L2, T2⦄ →
                      ∀K1. ⦃G1, K1⦄ ⊢ ➡[h, o] L1 →
                      ∃∃K2,T. ⦃G1, K1⦄ ⊢ T1 ➡*[h, o] T & ⦃G1, K1, T⦄ ⊐+ ⦃G2, K2, T2⦄ & ⦃G2, K2⦄ ⊢ ➡[h, o] L2.
#h #o #G1 #G2 #L1 #L2 #T1 #T2 #H @(fqup_ind … H) -G2 -L2 -T2
[ #G2 #L2 #T2 #H12 #K1 #HKL1 elim (lpx_fqu_trans … H12 … HKL1) -L1
  /3 width=5 by cpx_cpxs, fqu_fqup, ex3_2_intro/
| #G #G2 #L #L2 #T #T2 #_ #H2 #IH1 #K1 #HLK1 elim (IH1 … HLK1) -L1
  #L0 #T0 #HT10 #HT0 #HL0 elim (lpx_fqu_trans … H2 … HL0) -L
  #L #T3 #HT3 #HT32 #HL2 elim (fqup_cpx_trans … HT0 … HT3) -T
  /3 width=7 by cpxs_strap1, fqup_strap1, ex3_2_intro/
]
qed-.

lemma lpx_fqus_trans: ∀h,o,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ⊐* ⦃G2, L2, T2⦄ →
                      ∀K1. ⦃G1, K1⦄ ⊢ ➡[h, o] L1 →
                      ∃∃K2,T. ⦃G1, K1⦄ ⊢ T1 ➡*[h, o] T & ⦃G1, K1, T⦄ ⊐* ⦃G2, K2, T2⦄ & ⦃G2, K2⦄ ⊢ ➡[h, o] L2.
#h #o #G1 #G2 #L1 #L2 #T1 #T2 #H @(fqus_ind … H) -G2 -L2 -T2 [ /2 width=5 by ex3_2_intro/ ]
#G #G2 #L #L2 #T #T2 #_ #H2 #IH1 #K1 #HLK1 elim (IH1 … HLK1) -L1
#L0 #T0 #HT10 #HT0 #HL0 elim (lpx_fquq_trans … H2 … HL0) -L
#L #T3 #HT3 #HT32 #HL2 elim (fqus_cpx_trans … HT0 … HT3) -T
/3 width=7 by cpxs_strap1, fqus_strap1, ex3_2_intro/
qed-.

lemma lpxs_fquq_trans: ∀h,o,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ⊐⸮ ⦃G2, L2, T2⦄ →
                       ∀K1. ⦃G1, K1⦄ ⊢ ➡*[h, o] L1 →
                       ∃∃K2,T. ⦃G1, K1⦄ ⊢ T1 ➡*[h, o] T & ⦃G1, K1, T⦄ ⊐⸮ ⦃G2, K2, T2⦄ & ⦃G2, K2⦄ ⊢ ➡*[h, o] L2.
#h #o #G1 #G2 #L1 #L2 #T1 #T2 #HT12 #K1 #H @(lpxs_ind_dx … H) -K1
[ /2 width=5 by ex3_2_intro/
| #K1 #K #HK1 #_ * #L #T #HT1 #HT2 #HL2 -HT12
  lapply (lpx_cpxs_trans … HT1 … HK1) -HT1
  elim (lpx_fquq_trans … HT2 … HK1) -K
  /3 width=7 by lpxs_strap2, cpxs_strap1, ex3_2_intro/
]
qed-.

lemma lpxs_fqup_trans: ∀h,o,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ⊐+ ⦃G2, L2, T2⦄ →
                       ∀K1. ⦃G1, K1⦄ ⊢ ➡*[h, o] L1 →
                       ∃∃K2,T. ⦃G1, K1⦄ ⊢ T1 ➡*[h, o] T & ⦃G1, K1, T⦄ ⊐+ ⦃G2, K2, T2⦄ & ⦃G2, K2⦄ ⊢ ➡*[h, o] L2.
#h #o #G1 #G2 #L1 #L2 #T1 #T2 #HT12 #K1 #H @(lpxs_ind_dx … H) -K1
[ /2 width=5 by ex3_2_intro/
| #K1 #K #HK1 #_ * #L #T #HT1 #HT2 #HL2 -HT12
  lapply (lpx_cpxs_trans … HT1 … HK1) -HT1
  elim (lpx_fqup_trans … HT2 … HK1) -K
  /3 width=7 by lpxs_strap2, cpxs_trans, ex3_2_intro/
]
qed-.

lemma lpxs_fqus_trans: ∀h,o,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ⊐* ⦃G2, L2, T2⦄ →
                       ∀K1. ⦃G1, K1⦄ ⊢ ➡*[h, o] L1 →
                       ∃∃K2,T. ⦃G1, K1⦄ ⊢ T1 ➡*[h, o] T & ⦃G1, K1, T⦄ ⊐* ⦃G2, K2, T2⦄ & ⦃G2, K2⦄ ⊢ ➡*[h, o] L2.
#h #o #G1 #G2 #L1 #L2 #T1 #T2 #H @(fqus_ind … H) -G2 -L2 -T2 /2 width=5 by ex3_2_intro/
#G #G2 #L #L2 #T #T2 #_ #H2 #IH1 #K1 #HLK1 elim (IH1 … HLK1) -L1
#L0 #T0 #HT10 #HT0 #HL0 elim (lpxs_fquq_trans … H2 … HL0) -L
#L #T3 #HT3 #HT32 #HL2 elim (fqus_cpxs_trans … HT3 … HT0) -T
/3 width=7 by cpxs_trans, fqus_strap1, ex3_2_intro/
qed-.

lemma lpxs_lleq_fqu_trans: ∀h,o,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ⊐ ⦃G2, L2, T2⦄ →
                           ∀K1. ⦃G1, K1⦄ ⊢ ➡*[h, o] L1 → K1 ≡[T1, 0] L1 →
                           ∃∃K2. ⦃G1, K1, T1⦄ ⊐ ⦃G2, K2, T2⦄ & ⦃G2, K2⦄ ⊢ ➡*[h, o] L2 & K2 ≡[T2, 0] L2.
#h #o #G1 #G2 #L1 #L2 #T1 #T2 #H elim H -G1 -G2 -L1 -L2 -T1 -T2
[ #I #G1 #L1 #V1 #X #H1 #H2 elim (lpxs_inv_pair2 … H1) -H1
  #K0 #V0 #H1KL1 #_ #H destruct
  elim (lleq_inv_lref_ge_dx … H2 ? I L1 V1) -H2 //
  #K1 #H #H2KL1 lapply (drop_inv_O2 … H) -H #H destruct
  /2 width=4 by fqu_lref_O, ex3_intro/
| * [ #a ] #I #G1 #L1 #V1 #T1 #K1 #HLK1 #H
  [ elim (lleq_inv_bind … H)
  | elim (lleq_inv_flat … H)
  ] -H /2 width=4 by fqu_pair_sn, ex3_intro/
| #a #I #G1 #L1 #V1 #T1 #K1 #HLK1 #H elim (lleq_inv_bind_O … H) -H
  /3 width=4 by lpxs_pair, fqu_bind_dx, ex3_intro/
| #I #G1 #L1 #V1 #T1 #K1 #HLK1 #H elim (lleq_inv_flat … H) -H
  /2 width=4 by fqu_flat_dx, ex3_intro/
| #G1 #L1 #L #T1 #U1 #k #HL1 #HTU1 #K1 #H1KL1 #H2KL1
  elim (drop_O1_le (Ⓕ) (k+1) K1)
  [ #K #HK1 lapply (lleq_inv_lift_le … H2KL1 … HK1 HL1 … HTU1 ?) -H2KL1 //
    #H2KL elim (lpxs_drop_trans_O1 … H1KL1 … HL1) -L1
    #K0 #HK10 #H1KL lapply (drop_mono … HK10 … HK1) -HK10 #H destruct
    /3 width=4 by fqu_drop, ex3_intro/
  | lapply (drop_fwd_length_le2 … HL1) -L -T1 -o
    lapply (lleq_fwd_length … H2KL1) //
  ]
]
qed-.

lemma lpxs_lleq_fquq_trans: ∀h,o,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ⊐⸮ ⦃G2, L2, T2⦄ →
                            ∀K1. ⦃G1, K1⦄ ⊢ ➡*[h, o] L1 → K1 ≡[T1, 0] L1 →
                            ∃∃K2. ⦃G1, K1, T1⦄ ⊐⸮ ⦃G2, K2, T2⦄ & ⦃G2, K2⦄ ⊢ ➡*[h, o] L2 & K2 ≡[T2, 0] L2.
#h #o #G1 #G2 #L1 #L2 #T1 #T2 #H #K1 #H1KL1 #H2KL1
elim (fquq_inv_gen … H) -H
[ #H elim (lpxs_lleq_fqu_trans … H … H1KL1 H2KL1) -L1
  /3 width=4 by fqu_fquq, ex3_intro/
| * #HG #HL #HT destruct /2 width=4 by ex3_intro/
]
qed-.

lemma lpxs_lleq_fqup_trans: ∀h,o,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ⊐+ ⦃G2, L2, T2⦄ →
                            ∀K1. ⦃G1, K1⦄ ⊢ ➡*[h, o] L1 → K1 ≡[T1, 0] L1 →
                            ∃∃K2. ⦃G1, K1, T1⦄ ⊐+ ⦃G2, K2, T2⦄ & ⦃G2, K2⦄ ⊢ ➡*[h, o] L2 & K2 ≡[T2, 0] L2.
#h #o #G1 #G2 #L1 #L2 #T1 #T2 #H @(fqup_ind … H) -G2 -L2 -T2
[ #G2 #L2 #T2 #H #K1 #H1KL1 #H2KL1 elim (lpxs_lleq_fqu_trans … H … H1KL1 H2KL1) -L1
  /3 width=4 by fqu_fqup, ex3_intro/
| #G #G2 #L #L2 #T #T2 #_ #HT2 #IHT1 #K1 #H1KL1 #H2KL1 elim (IHT1 … H2KL1) // -L1
  #K #HT1 #H1KL #H2KL elim (lpxs_lleq_fqu_trans … HT2 … H1KL H2KL) -L
  /3 width=5 by fqup_strap1, ex3_intro/
]
qed-.

lemma lpxs_lleq_fqus_trans: ∀h,o,G1,G2,L1,L2,T1,T2. ⦃G1, L1, T1⦄ ⊐* ⦃G2, L2, T2⦄ →
                            ∀K1. ⦃G1, K1⦄ ⊢ ➡*[h, o] L1 → K1 ≡[T1, 0] L1 →
                            ∃∃K2. ⦃G1, K1, T1⦄ ⊐* ⦃G2, K2, T2⦄ & ⦃G2, K2⦄ ⊢ ➡*[h, o] L2 & K2 ≡[T2, 0] L2.
#h #o #G1 #G2 #L1 #L2 #T1 #T2 #H #K1 #H1KL1 #H2KL1
elim (fqus_inv_gen … H) -H
[ #H elim (lpxs_lleq_fqup_trans … H … H1KL1 H2KL1) -L1
  /3 width=4 by fqup_fqus, ex3_intro/
| * #HG #HL #HT destruct /2 width=4 by ex3_intro/
]
qed-.
