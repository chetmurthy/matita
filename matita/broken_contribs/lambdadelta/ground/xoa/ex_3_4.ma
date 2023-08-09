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

include "ground/notation/xoa/ex_3_4.ma".

(* Note: multiple existental quantifier (3, 4) *)
inductive ex3_4 (A0,A1,A2,A3:Type[0]) (P0,P1,P2:A0→A1→A2→A3→Prop) : Prop ≝
  | ex3_4_intro: ∀x0,x1,x2,x3. P0 x0 x1 x2 x3 → P1 x0 x1 x2 x3 → P2 x0 x1 x2 x3 → ex3_4 ? ? ? ? ? ? ?
.

interpretation "multiple existental quantifier (3, 4)" 'Ex4 P0 P1 P2 = (ex3_4 ? ? ? ? P0 P1 P2).

