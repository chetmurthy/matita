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

(* Initial invocation: - Patience on us to gain peace and perfection! - *)

include "preamble.ma".

(* TERM STRUCTURE ***********************************************************)

(* Policy: term metavariables: A, B, C, D, M, N
           de Bruijn indexes : i, j
*)
inductive term: Type[0] ≝
| VRef: nat → term         (* variable reference by index *)
| Abst: term → term        (* function formation          *)
| Appl: term → term → term (* function application        *)
.

interpretation "term construction (variable reference by index)"
   'VariableReferenceByIndex i = (VRef i).

interpretation "term construction (abstraction)"
   'Abstraction A = (Abst A).

interpretation "term construction (application)"
   'Application C A = (Appl C A).

notation "hvbox( # term 90 i )"
 non associative with precedence 90
 for @{ 'VariableReferenceByIndex $i }.

notation "hvbox( 𝛌  . term 46 A )"
   non associative with precedence 46
   for @{ 'Abstraction $A }.

notation > "hvbox( 𝛌 term 46 A )"
   non associative with precedence 46
   for @{ 'Abstraction $A }.

notation "hvbox( @ term 46 C . break term 46 A )"
   non associative with precedence 46
   for @{ 'Application $C $A }.
