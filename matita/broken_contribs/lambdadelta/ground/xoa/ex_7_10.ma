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

(* LOGIC ********************************************************************)

(* NOTE: This file was generated by xoa, do not edit ************************)

include "basics/pts.ma".

include "basics/core_notation/imply_2.ma".

include "ground/notation/xoa/ex_7_10.ma".

(* Note: multiple existental quantifier (7, 10) *)
inductive ex7_10 (A0,A1,A2,A3,A4,A5,A6,A7,A8,A9:Type[0]) (P0,P1,P2,P3,P4,P5,P6:A0→A1→A2→A3→A4→A5→A6→A7→A8→A9→Prop) : Prop ≝
  | ex7_10_intro: ∀x0,x1,x2,x3,x4,x5,x6,x7,x8,x9. P0 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 → P1 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 → P2 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 → P3 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 → P4 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 → P5 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 → P6 x0 x1 x2 x3 x4 x5 x6 x7 x8 x9 → ex7_10 ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?
.

interpretation "multiple existental quantifier (7, 10)" 'Ex10 P0 P1 P2 P3 P4 P5 P6 = (ex7_10 ? ? ? ? ? ? ? ? ? ? P0 P1 P2 P3 P4 P5 P6).

