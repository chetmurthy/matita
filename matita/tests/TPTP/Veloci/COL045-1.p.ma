
include "logic/equality.ma".
(* Inclusion of: COL045-1.p *)
(* -------------------------------------------------------------------------- *)
(*  File     : COL045-1 : TPTP v3.1.1. Released v1.0.0. *)
(*  Domain   : Combinatory Logic *)
(*  Problem  : Weak fixed point for B, M and S *)
(*  Version  : [WM88] (equality) axioms. *)
(*  English  : The weak fixed point property holds for the set P consisting  *)
(*             of the combinators B, M and S, where ((Sx)y)z = (xz)(yz),  *)
(*             ((Bx)y)z = x(yz), Mx = xx. *)
(*  Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi *)
(*           : [MW87]  McCune & Wos (1987), A Case Study in Automated Theorem *)
(*           : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq *)
(*           : [Wos89] Wos (1989), A Challenge Problem and a Recent Workshop *)
(*  Source   : [Wos89] *)
(*  Names    : - [Wos89] *)
(*  Status   : Unsatisfiable *)
(*  Rating   : 0.00 v2.0.0 *)
(*  Syntax   : Number of clauses     :    4 (   0 non-Horn;   4 unit;   1 RR) *)
(*             Number of atoms       :    4 (   4 equality) *)
(*             Maximal clause size   :    1 (   1 average) *)
(*             Number of predicates  :    1 (   0 propositional; 2-2 arity) *)
(*             Number of functors    :    5 (   4 constant; 0-2 arity) *)
(*             Number of variables   :    8 (   0 singleton) *)
(*             Maximal term depth    :    4 (   3 average) *)
(*  Comments :  *)
(* -------------------------------------------------------------------------- *)
theorem prove_fixed_point:
 \forall Univ:Set.
\forall apply:\forall _:Univ.\forall _:Univ.Univ.
\forall b:Univ.
\forall combinator:Univ.
\forall m:Univ.
\forall s:Univ.
\forall H0:\forall X:Univ.eq Univ (apply m X) (apply X X).
\forall H1:\forall X:Univ.\forall Y:Univ.\forall Z:Univ.eq Univ (apply (apply (apply b X) Y) Z) (apply X (apply Y Z)).
\forall H2:\forall X:Univ.\forall Y:Univ.\forall Z:Univ.eq Univ (apply (apply (apply s X) Y) Z) (apply (apply X Z) (apply Y Z)).\exist Y:Univ.eq Univ Y (apply combinator Y)
.
intros.
exists[
2:
autobatch paramodulation timeout=100;
try assumption.
|
skip]
print proofterm.
qed.
(* -------------------------------------------------------------------------- *)
