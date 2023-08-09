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

include "ground/notation/xoa/ex_5_1.ma".

(* Note: multiple existental quantifier (5, 1) *)
inductive ex5 (A0:Type[0]) (P0,P1,P2,P3,P4:A0→Prop) : Prop ≝
  | ex5_intro: ∀x0. P0 x0 → P1 x0 → P2 x0 → P3 x0 → P4 x0 → ex5 ? ? ? ? ? ?
.

interpretation "multiple existental quantifier (5, 1)" 'Ex P0 P1 P2 P3 P4 = (ex5 ? P0 P1 P2 P3 P4).

