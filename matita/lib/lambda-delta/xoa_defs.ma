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

(* This file was generated by xoa.native: do not edit *********************)

include "basics/pts.ma".

(* multiple existental quantifier (2, 1) *)

inductive ex2_1 (A0:Type[0]) (P0,P1:A0→Prop) : Prop ≝
   | ex2_1_intro: ∀x0. P0 x0 → P1 x0 → ex2_1 ? ? ?
.

interpretation "multiple existental quantifier (2, 1)" 'Ex P0 P1 = (ex2_1 ? P0 P1).

(* multiple existental quantifier (2, 2) *)

inductive ex2_2 (A0,A1:Type[0]) (P0,P1:A0→A1→Prop) : Prop ≝
   | ex2_2_intro: ∀x0,x1. P0 x0 x1 → P1 x0 x1 → ex2_2 ? ? ? ?
.

interpretation "multiple existental quantifier (2, 2)" 'Ex P0 P1 = (ex2_2 ? ? P0 P1).

(* multiple existental quantifier (3, 1) *)

inductive ex3_1 (A0:Type[0]) (P0,P1,P2:A0→Prop) : Prop ≝
   | ex3_1_intro: ∀x0. P0 x0 → P1 x0 → P2 x0 → ex3_1 ? ? ? ?
.

interpretation "multiple existental quantifier (3, 1)" 'Ex P0 P1 P2 = (ex3_1 ? P0 P1 P2).

(* multiple existental quantifier (3, 2) *)

inductive ex3_2 (A0,A1:Type[0]) (P0,P1,P2:A0→A1→Prop) : Prop ≝
   | ex3_2_intro: ∀x0,x1. P0 x0 x1 → P1 x0 x1 → P2 x0 x1 → ex3_2 ? ? ? ? ?
.

interpretation "multiple existental quantifier (3, 2)" 'Ex P0 P1 P2 = (ex3_2 ? ? P0 P1 P2).

(* multiple existental quantifier (3, 3) *)

inductive ex3_3 (A0,A1,A2:Type[0]) (P0,P1,P2:A0→A1→A2→Prop) : Prop ≝
   | ex3_3_intro: ∀x0,x1,x2. P0 x0 x1 x2 → P1 x0 x1 x2 → P2 x0 x1 x2 → ex3_3 ? ? ? ? ? ?
.

interpretation "multiple existental quantifier (3, 3)" 'Ex P0 P1 P2 = (ex3_3 ? ? ? P0 P1 P2).

(* multiple existental quantifier (4, 3) *)

inductive ex4_3 (A0,A1,A2:Type[0]) (P0,P1,P2,P3:A0→A1→A2→Prop) : Prop ≝
   | ex4_3_intro: ∀x0,x1,x2. P0 x0 x1 x2 → P1 x0 x1 x2 → P2 x0 x1 x2 → P3 x0 x1 x2 → ex4_3 ? ? ? ? ? ? ?
.

interpretation "multiple existental quantifier (4, 3)" 'Ex P0 P1 P2 P3 = (ex4_3 ? ? ? P0 P1 P2 P3).

(* multiple existental quantifier (4, 4) *)

inductive ex4_4 (A0,A1,A2,A3:Type[0]) (P0,P1,P2,P3:A0→A1→A2→A3→Prop) : Prop ≝
   | ex4_4_intro: ∀x0,x1,x2,x3. P0 x0 x1 x2 x3 → P1 x0 x1 x2 x3 → P2 x0 x1 x2 x3 → P3 x0 x1 x2 x3 → ex4_4 ? ? ? ? ? ? ? ?
.

interpretation "multiple existental quantifier (4, 4)" 'Ex P0 P1 P2 P3 = (ex4_4 ? ? ? ? P0 P1 P2 P3).

(* multiple existental quantifier (5, 3) *)

inductive ex5_3 (A0,A1,A2:Type[0]) (P0,P1,P2,P3,P4:A0→A1→A2→Prop) : Prop ≝
   | ex5_3_intro: ∀x0,x1,x2. P0 x0 x1 x2 → P1 x0 x1 x2 → P2 x0 x1 x2 → P3 x0 x1 x2 → P4 x0 x1 x2 → ex5_3 ? ? ? ? ? ? ? ?
.

interpretation "multiple existental quantifier (5, 3)" 'Ex P0 P1 P2 P3 P4 = (ex5_3 ? ? ? P0 P1 P2 P3 P4).

(* multiple existental quantifier (5, 4) *)

inductive ex5_4 (A0,A1,A2,A3:Type[0]) (P0,P1,P2,P3,P4:A0→A1→A2→A3→Prop) : Prop ≝
   | ex5_4_intro: ∀x0,x1,x2,x3. P0 x0 x1 x2 x3 → P1 x0 x1 x2 x3 → P2 x0 x1 x2 x3 → P3 x0 x1 x2 x3 → P4 x0 x1 x2 x3 → ex5_4 ? ? ? ? ? ? ? ? ?
.

interpretation "multiple existental quantifier (5, 4)" 'Ex P0 P1 P2 P3 P4 = (ex5_4 ? ? ? ? P0 P1 P2 P3 P4).

(* multiple existental quantifier (6, 6) *)

inductive ex6_6 (A0,A1,A2,A3,A4,A5:Type[0]) (P0,P1,P2,P3,P4,P5:A0→A1→A2→A3→A4→A5→Prop) : Prop ≝
   | ex6_6_intro: ∀x0,x1,x2,x3,x4,x5. P0 x0 x1 x2 x3 x4 x5 → P1 x0 x1 x2 x3 x4 x5 → P2 x0 x1 x2 x3 x4 x5 → P3 x0 x1 x2 x3 x4 x5 → P4 x0 x1 x2 x3 x4 x5 → P5 x0 x1 x2 x3 x4 x5 → ex6_6 ? ? ? ? ? ? ? ? ? ? ? ?
.

interpretation "multiple existental quantifier (6, 6)" 'Ex P0 P1 P2 P3 P4 P5 = (ex6_6 ? ? ? ? ? ? P0 P1 P2 P3 P4 P5).

(* multiple existental quantifier (7, 6) *)

inductive ex7_6 (A0,A1,A2,A3,A4,A5:Type[0]) (P0,P1,P2,P3,P4,P5,P6:A0→A1→A2→A3→A4→A5→Prop) : Prop ≝
   | ex7_6_intro: ∀x0,x1,x2,x3,x4,x5. P0 x0 x1 x2 x3 x4 x5 → P1 x0 x1 x2 x3 x4 x5 → P2 x0 x1 x2 x3 x4 x5 → P3 x0 x1 x2 x3 x4 x5 → P4 x0 x1 x2 x3 x4 x5 → P5 x0 x1 x2 x3 x4 x5 → P6 x0 x1 x2 x3 x4 x5 → ex7_6 ? ? ? ? ? ? ? ? ? ? ? ? ?
.

interpretation "multiple existental quantifier (7, 6)" 'Ex P0 P1 P2 P3 P4 P5 P6 = (ex7_6 ? ? ? ? ? ? P0 P1 P2 P3 P4 P5 P6).

(* multiple disjunction connective (3) *)

inductive or3 (P0,P1,P2:Prop) : Prop ≝
   | or3_intro0: P0 → or3 ? ? ?
   | or3_intro1: P1 → or3 ? ? ?
   | or3_intro2: P2 → or3 ? ? ?
.

interpretation "multiple disjunction connective (3)" 'Or P0 P1 P2 = (or3 P0 P1 P2).

(* multiple disjunction connective (4) *)

inductive or4 (P0,P1,P2,P3:Prop) : Prop ≝
   | or4_intro0: P0 → or4 ? ? ? ?
   | or4_intro1: P1 → or4 ? ? ? ?
   | or4_intro2: P2 → or4 ? ? ? ?
   | or4_intro3: P3 → or4 ? ? ? ?
.

interpretation "multiple disjunction connective (4)" 'Or P0 P1 P2 P3 = (or4 P0 P1 P2 P3).

(* multiple conjunction connective (3) *)

inductive and3 (P0,P1,P2:Prop) : Prop ≝
   | and3_intro: P0 → P1 → P2 → and3 ? ? ?
.

interpretation "multiple conjunction connective (3)" 'And P0 P1 P2 = (and3 P0 P1 P2).

