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

include "ground_2/notation/xoa/ex_4_5.ma".

(* multiple existental quantifier (4, 5) *)

inductive ex4_5 (A0,A1,A2,A3,A4:Type[0]) (P0,P1,P2,P3:A0→A1→A2→A3→A4→Prop) : Prop ≝
   | ex4_5_intro: ∀x0,x1,x2,x3,x4. P0 x0 x1 x2 x3 x4 → P1 x0 x1 x2 x3 x4 → P2 x0 x1 x2 x3 x4 → P3 x0 x1 x2 x3 x4 → ex4_5 ? ? ? ? ? ? ? ? ?
.

interpretation "multiple existental quantifier (4, 5)" 'Ex5 P0 P1 P2 P3 = (ex4_5 ? ? ? ? ? P0 P1 P2 P3).

