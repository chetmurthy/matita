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

include "ground_2/notation/xoa/ex_2_3.ma".

(* multiple existental quantifier (2, 3) *)

inductive ex2_3 (A0,A1,A2:Type[0]) (P0,P1:A0→A1→A2→Prop) : Prop ≝
   | ex2_3_intro: ∀x0,x1,x2. P0 x0 x1 x2 → P1 x0 x1 x2 → ex2_3 ? ? ? ? ?
.

interpretation "multiple existental quantifier (2, 3)" 'Ex3 P0 P1 = (ex2_3 ? ? ? P0 P1).

