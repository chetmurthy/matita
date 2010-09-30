include "logic/equality.ma".

(* Inclusion of: GRP524-1.p *)

(* -------------------------------------------------------------------------- *)

(*  File     : GRP524-1 : TPTP v3.7.0. Bugfixed v2.7.0. *)

(*  Domain   : Group Theory (Abelian) *)

(*  Problem  : Axiom for Abelian group theory, in division, part 4 *)

(*  Version  : [McC93] (equality) axioms. *)

(*  English  :  *)

(*  Refs     : [Tar38] Tarski (1938), Ein Beitrag zur Axiomatik der Abelschen *)

(*           : [McC93] McCune (1993), Single Axioms for Groups and Abelian Gr *)

(*  Source   : [TPTP] *)

(*  Names    :  *)

(*  Status   : Unsatisfiable *)

(*  Rating   : 0.00 v3.4.0, 0.12 v3.3.0, 0.00 v2.7.0 *)

(*  Syntax   : Number of clauses     :    4 (   0 non-Horn;   4 unit;   1 RR) *)

(*             Number of atoms       :    4 (   4 equality) *)

(*             Maximal clause size   :    1 (   1 average) *)

(*             Number of predicates  :    1 (   0 propositional; 2-2 arity) *)

(*             Number of functors    :    5 (   2 constant; 0-2 arity) *)

(*             Number of variables   :    8 (   0 singleton) *)

(*             Maximal term depth    :    5 (   3 average) *)

(*  Comments : A UEQ part of GRP088-1 *)

(*  Bugfixes : v2.7.0 - Grounded conjecture *)

(* -------------------------------------------------------------------------- *)
ntheorem prove_these_axioms_4:
 (∀Univ:Type.∀A:Univ.∀B:Univ.∀C:Univ.
∀a:Univ.
∀b:Univ.
∀divide:∀_:Univ.∀_:Univ.Univ.
∀inverse:∀_:Univ.Univ.
∀multiply:∀_:Univ.∀_:Univ.Univ.
∀H0:∀A:Univ.∀B:Univ.eq Univ (inverse A) (divide (divide B B) A).
∀H1:∀A:Univ.∀B:Univ.∀C:Univ.eq Univ (multiply A B) (divide A (divide (divide C C) B)).
∀H2:∀A:Univ.∀B:Univ.∀C:Univ.eq Univ (divide A (divide B (divide C (divide A B)))) C.eq Univ (multiply a b) (multiply b a))
.
#Univ ##.
#A ##.
#B ##.
#C ##.
#a ##.
#b ##.
#divide ##.
#inverse ##.
#multiply ##.
#H0 ##.
#H1 ##.
#H2 ##.
nauto by H0,H1,H2 ##;
ntry (nassumption) ##;
nqed.

(* -------------------------------------------------------------------------- *)
