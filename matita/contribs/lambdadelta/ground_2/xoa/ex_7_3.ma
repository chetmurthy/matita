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

include "ground_2/notation/xoa/ex_7_3.ma".

(* multiple existental quantifier (7, 3) *)

inductive ex7_3 (A0,A1,A2:Type[0]) (P0,P1,P2,P3,P4,P5,P6:A0→A1→A2→Prop) : Prop ≝
   | ex7_3_intro: ∀x0,x1,x2. P0 x0 x1 x2 → P1 x0 x1 x2 → P2 x0 x1 x2 → P3 x0 x1 x2 → P4 x0 x1 x2 → P5 x0 x1 x2 → P6 x0 x1 x2 → ex7_3 ? ? ? ? ? ? ? ? ? ?
.

interpretation "multiple existental quantifier (7, 3)" 'Ex3 P0 P1 P2 P3 P4 P5 P6 = (ex7_3 ? ? ? P0 P1 P2 P3 P4 P5 P6).

