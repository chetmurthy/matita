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

(* ********************************************************************** *)
(*                          Progetto FreeScale                            *)
(*                                                                        *)
(*   Sviluppato da: Ing. Cosimo Oliboni, oliboni@cs.unibo.it              *)
(*   Sviluppo: 2008-2010                                                  *)
(*                                                                        *)
(* ********************************************************************** *)

include "emulator/status/HC05_status_base.ma".

(* *********************************** *)
(* STATUS INTERNO DEL PROCESSORE (ALU) *)
(* *********************************** *)

nlemma aluHC05_destruct_1 :
∀x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13.
 mk_alu_HC05 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 = mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 →
 x1 = y1.
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange with (match mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13
                with [ mk_alu_HC05 a _ _ _ _ _ _ _ _ _ _ _ _ ⇒ x1 = a ]);
 nrewrite < H;
 nnormalize;
 napply refl_eq.
nqed.

nlemma aluHC05_destruct_2 :
∀x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13.
 mk_alu_HC05 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 = mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 →
 x2 = y2.
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange with (match mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13
                with [ mk_alu_HC05 _ a _ _ _ _ _ _ _ _ _ _ _ ⇒ x2 = a ]);
 nrewrite < H;
 nnormalize;
 napply refl_eq.
nqed.

nlemma aluHC05_destruct_3 :
∀x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13.
 mk_alu_HC05 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 = mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 →
 x3 = y3.
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange with (match mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13
                with [ mk_alu_HC05 _ _ a _ _ _ _ _ _ _ _ _ _ ⇒ x3 = a ]);
 nrewrite < H;
 nnormalize;
 napply refl_eq.
nqed.

nlemma aluHC05_destruct_4 :
∀x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13.
 mk_alu_HC05 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 = mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 →
 x4 = y4.
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange with (match mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13
                with [ mk_alu_HC05 _ _ _ a _ _ _ _ _ _ _ _ _ ⇒ x4 = a ]);
 nrewrite < H;
 nnormalize;
 napply refl_eq.
nqed.

nlemma aluHC05_destruct_5 :
∀x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13.
 mk_alu_HC05 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 = mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 →
 x5 = y5.
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange with (match mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13
                with [ mk_alu_HC05 _ _ _ _ a _ _ _ _ _ _ _ _ ⇒ x5 = a ]);
 nrewrite < H;
 nnormalize;
 napply refl_eq.
nqed.

nlemma aluHC05_destruct_6 :
∀x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13.
 mk_alu_HC05 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 = mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 →
 x6 = y6.
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange with (match mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13
                with [ mk_alu_HC05 _ _ _ _ _ a _ _ _ _ _ _ _ ⇒ x6 = a ]);
 nrewrite < H;
 nnormalize;
 napply refl_eq.
nqed.

nlemma aluHC05_destruct_7 :
∀x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13.
 mk_alu_HC05 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 = mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 →
 x7 = y7.
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange with (match mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13
                with [ mk_alu_HC05 _ _ _ _ _ _ a _ _ _ _ _ _ ⇒ x7 = a ]);
 nrewrite < H;
 nnormalize;
 napply refl_eq.
nqed.

nlemma aluHC05_destruct_8 :
∀x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13.
 mk_alu_HC05 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 = mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 →
 x8 = y8.
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange with (match mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13
                with [ mk_alu_HC05 _ _ _ _ _ _ _ a _ _ _ _ _ ⇒ x8 = a ]);
 nrewrite < H;
 nnormalize;
 napply refl_eq.
nqed.

nlemma aluHC05_destruct_9 :
∀x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13.
 mk_alu_HC05 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 = mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 →
 x9 = y9.
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange with (match mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13
                with [ mk_alu_HC05 _ _ _ _ _ _ _ _ a _ _ _ _ ⇒ x9 = a ]);
 nrewrite < H;
 nnormalize;
 napply refl_eq.
nqed.

nlemma aluHC05_destruct_10 :
∀x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13.
 mk_alu_HC05 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 = mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 →
 x10 = y10.
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange with (match mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13
                with [ mk_alu_HC05 _ _ _ _ _ _ _ _ _ a _ _ _ ⇒ x10 = a ]);
 nrewrite < H;
 nnormalize;
 napply refl_eq.
nqed.

nlemma aluHC05_destruct_11 :
∀x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13.
 mk_alu_HC05 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 = mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 →
 x11 = y11.
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange with (match mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13
                with [ mk_alu_HC05 _ _ _ _ _ _ _ _ _ _ a _ _ ⇒ x11 = a ]);
 nrewrite < H;
 nnormalize;
 napply refl_eq.
nqed.

nlemma aluHC05_destruct_12 :
∀x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13.
 mk_alu_HC05 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 = mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 →
 x12 = y12.
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange with (match mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13
                with [ mk_alu_HC05 _ _ _ _ _ _ _ _ _ _ _ a _ ⇒ x12 = a ]);
 nrewrite < H;
 nnormalize;
 napply refl_eq.
nqed.

nlemma aluHC05_destruct_13 :
∀x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,y1,y2,y3,y4,y5,y6,y7,y8,y9,y10,y11,y12,y13.
 mk_alu_HC05 x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 = mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 →
 x13 = y13.
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange with (match mk_alu_HC05 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13
                with [ mk_alu_HC05 _ _ _ _ _ _ _ _ _ _ _ _ a ⇒ x13 = a ]);
 nrewrite < H;
 nnormalize;
 napply refl_eq.
nqed.

nlemma eq_to_eqaluHC05 : ∀alu1,alu2.alu1 = alu2 → eq_HC05_alu alu1 alu2 = true.
 #alu1; #alu2;
 ncases alu1;
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 ncases alu2;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nrewrite > (aluHC05_destruct_1 … H);
 nrewrite > (aluHC05_destruct_2 … H);
 nrewrite > (aluHC05_destruct_3 … H);
 nrewrite > (aluHC05_destruct_4 … H);
 nrewrite > (aluHC05_destruct_5 … H);
 nrewrite > (aluHC05_destruct_6 … H);
 nrewrite > (aluHC05_destruct_7 … H);
 nrewrite > (aluHC05_destruct_8 … H);
 nrewrite > (aluHC05_destruct_9 … H);
 nrewrite > (aluHC05_destruct_10 … H);
 nrewrite > (aluHC05_destruct_11 … H);
 nrewrite > (aluHC05_destruct_12 … H);
 nrewrite > (aluHC05_destruct_13 … H);
 nchange with (
 ((eqc ? y1 y1) ⊗ (eqc ? y2 y2) ⊗
  (eqc ? y3 y3) ⊗ (eqc ? y4 y4) ⊗
  (eqc ? y5 y5) ⊗ (eqc ? y6 y6) ⊗
  (eqc ? y7 y7) ⊗ (eqc ? y8 y8) ⊗
  (eqc ? y9 y9) ⊗ (eqc ? y10 y10) ⊗
  (eqc ? y11 y11) ⊗ (eqc ? y12 y12) ⊗
  (eqc ? y13 y13)) = true); 
 nrewrite > (eq_to_eqc ? y1 y1 (refl_eq …));
 nrewrite > (eq_to_eqc ? y2 y2 (refl_eq …));
 nrewrite > (eq_to_eqc ? y3 y3 (refl_eq …));
 nrewrite > (eq_to_eqc ? y4 y4 (refl_eq …));
 nrewrite > (eq_to_eqc ? y5 y5 (refl_eq …));
 nrewrite > (eq_to_eqc ? y6 y6 (refl_eq …));
 nrewrite > (eq_to_eqc ? y7 y7 (refl_eq …));
 nrewrite > (eq_to_eqc ? y8 y8 (refl_eq …));
 nrewrite > (eq_to_eqc ? y9 y9 (refl_eq …));
 nrewrite > (eq_to_eqc ? y10 y10 (refl_eq …));
 nrewrite > (eq_to_eqc ? y11 y11 (refl_eq …));
 nrewrite > (eq_to_eqc ? y12 y12 (refl_eq …));
 nrewrite > (eq_to_eqc ? y13 y13 (refl_eq …));
 napply refl_eq.
nqed.

nlemma neqaluHC05_to_neq : ∀alu1,alu2.eq_HC05_alu alu1 alu2 = false → alu1 ≠ alu2.
 #s1; #s2; #H;
 napply (not_to_not (s1 = s2) (eq_HC05_alu s1 s2 = true) …);
 ##[ ##1: napply (eq_to_eqaluHC05 s1 s2)
 ##| ##2: napply (eqfalse_to_neqtrue … H)
 ##]
nqed.

nlemma eqaluHC05_to_eq : ∀alu1,alu2.eq_HC05_alu alu1 alu2 = true → alu1 = alu2.
 #alu1; #alu2;
 ncases alu1;
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 ncases alu2;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13; #H;
 nchange in H:(%) with (
 ((eqc ? x1 y1) ⊗ (eqc ? x2 y2) ⊗
  (eqc ? x3 y3) ⊗ (eqc ? x4 y4) ⊗
  (eqc ? x5 y5) ⊗ (eqc ? x6 y6) ⊗
  (eqc ? x7 y7) ⊗ (eqc ? x8 y8) ⊗
  (eqc ? x9 y9) ⊗ (eqc ? x10 y10) ⊗
  (eqc ? x11 y11) ⊗ (eqc ? x12 y12) ⊗
  (eqc ? x13 y13)) = true);  
 nrewrite > (eqc_to_eq … (andb_true_true_r … H));
 nletin H1 ≝ (andb_true_true_l … H);
 nrewrite > (eqc_to_eq … (andb_true_true_r … (andb_true_true_l … H)));
 nletin H2 ≝ (andb_true_true_l … H1);
 nrewrite > (eqc_to_eq … (andb_true_true_r … H2));
 nletin H3 ≝ (andb_true_true_l … H2);
 nrewrite > (eqc_to_eq … (andb_true_true_r … H3));
 nletin H4 ≝ (andb_true_true_l … H3);
 nrewrite > (eqc_to_eq … (andb_true_true_r … H4));
 nletin H5 ≝ (andb_true_true_l … H4);
 nrewrite > (eqc_to_eq … (andb_true_true_r … H5));
 nletin H6 ≝ (andb_true_true_l … H5);
 nrewrite > (eqc_to_eq … (andb_true_true_r … H6));
 nletin H7 ≝ (andb_true_true_l … H6);
 nrewrite > (eqc_to_eq … (andb_true_true_r … H7));
 nletin H8 ≝ (andb_true_true_l … H7);
 nrewrite > (eqc_to_eq … (andb_true_true_r … H8));
 nletin H9 ≝ (andb_true_true_l … H8);
 nrewrite > (eqc_to_eq … (andb_true_true_r … H9));
 nletin H10 ≝ (andb_true_true_l … H9);
 nrewrite > (eqc_to_eq … (andb_true_true_r … H10));
 nletin H11 ≝ (andb_true_true_l … H10);
 nrewrite > (eqc_to_eq … (andb_true_true_r … H11));
 nrewrite > (eqc_to_eq … (andb_true_true_l … H11));
 napply refl_eq.
nqed.

nlemma neq_to_neqaluHC05 : ∀alu1,alu2.alu1 ≠ alu2 → eq_HC05_alu alu1 alu2 = false.
 #s1; #s2; #H;
 napply (neqtrue_to_eqfalse (eq_HC05_alu s1 s2));
 napply (not_to_not (eq_HC05_alu s1 s2 = true) (s1 = s2) ? H);
 napply (eqaluHC05_to_eq s1 s2).
nqed.

nlemma decidable_aluHC05 : ∀x,y:alu_HC05.decidable (x = y).
 #x; #y; nnormalize;
 napply (or2_elim (eq_HC05_alu x y = true) (eq_HC05_alu x y = false) ? (decidable_bexpr ?));
 ##[ ##1: #H; napply (or2_intro1 (x = y) (x ≠ y) (eqaluHC05_to_eq … H))
 ##| ##2: #H; napply (or2_intro2 (x = y) (x ≠ y) (neqaluHC05_to_neq … H))
 ##]
nqed.

nlemma symmetric_eqaluHC05 : symmetricT alu_HC05 bool eq_HC05_alu.
 #alu1; #alu2;
 ncases alu1;
 #x1; #x2; #x3; #x4; #x5; #x6; #x7; #x8; #x9; #x10; #x11; #x12; #x13;
 ncases alu2;
 #y1; #y2; #y3; #y4; #y5; #y6; #y7; #y8; #y9; #y10; #y11; #y12; #y13;
 nchange with (
  ((eqc ? x1 y1) ⊗ (eqc ? x2 y2) ⊗ (eqc ? x3 y3) ⊗ (eqc ? x4 y4) ⊗
  (eqc ? x5 y5) ⊗ (eqc ? x6 y6) ⊗  (eqc ? x7 y7) ⊗ (eqc ? x8 y8) ⊗
  (eqc ? x9 y9) ⊗ (eqc ? x10 y10) ⊗  (eqc ? x11 y11) ⊗ (eqc ? x12 y12) ⊗
  (eqc ? x13 y13)) = ((eqc ? y1 x1) ⊗  (eqc ? y2 x2) ⊗ (eqc ? y3 x3) ⊗
  (eqc ? y4 x4) ⊗ (eqc ? y5 x5) ⊗  (eqc ? y6 x6) ⊗ (eqc ? y7 x7) ⊗
  (eqc ? y8 x8) ⊗ (eqc ? y9 x9) ⊗  (eqc ? y10 x10) ⊗ (eqc ? y11 x11) ⊗
  (eqc ? y12 x12) ⊗ (eqc ? y13 x13)));
 nrewrite > (symmetric_eqc ? x1 y1);
 nrewrite > (symmetric_eqc ? x2 y2);
 nrewrite > (symmetric_eqc ? x3 y3);
 nrewrite > (symmetric_eqc ? x4 y4);
 nrewrite > (symmetric_eqc ? x5 y5);
 nrewrite > (symmetric_eqc ? x6 y6);
 nrewrite > (symmetric_eqc ? x7 y7);
 nrewrite > (symmetric_eqc ? x8 y8);
 nrewrite > (symmetric_eqc ? x9 y9);
 nrewrite > (symmetric_eqc ? x10 y10);
 nrewrite > (symmetric_eqc ? x11 y11);
 nrewrite > (symmetric_eqc ? x12 y12);
 nrewrite > (symmetric_eqc ? x13 y13);
 napply refl_eq.
nqed.

nlemma aluHC05_is_comparable : comparable.
 @ alu_HC05
  ##[ napply (mk_alu_HC05 (zeroc ?) (zeroc ?) (zeroc ?) (zeroc ?)
                          (zeroc ?) (zeroc ?) (zeroc ?) (zeroc ?)
                          (zeroc ?) (zeroc ?) (zeroc ?) (zeroc ?)
                          (zeroc ?))
  ##| napply forall_HC05_alu
  ##| napply eq_HC05_alu
  ##| napply eqaluHC05_to_eq
  ##| napply eq_to_eqaluHC05
  ##| napply neqaluHC05_to_neq
  ##| napply neq_to_neqaluHC05
  ##| napply decidable_aluHC05
  ##| napply symmetric_eqaluHC05
  ##]
nqed.

unification hint 0 ≔ ⊢ carr aluHC05_is_comparable ≡ alu_HC05.
