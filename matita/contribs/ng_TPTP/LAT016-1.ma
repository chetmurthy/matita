include "logic/equality.ma".

(* Inclusion of: LAT016-1.p *)

(* -------------------------------------------------------------------------- *)

(*  File     : LAT016-1 : TPTP v3.7.0. Bugfixed v2.2.1. *)

(*  Domain   : Lattice Theory (Ortholattices) *)

(*  Problem  : E1 fails for Ortholattices. *)

(*  Version  : [McC98b] (equality) axioms. *)

(*  English  : Show that Ortholattices do not necessarily satisfy equation E1. *)

(*  Refs     : [McC98a] McCune (1998), Automatic Proofs and Counterexamples f *)

(*           : [McC98b] McCune (1998), Email to G. Sutcliffe *)

(*  Source   : [McC98b] *)

(*  Names    : OL-1 [McC98b] *)

(*  Status   : Satisfiable *)

(*  Rating   : 0.33 v2.6.0, 0.67 v2.5.0, 1.00 v2.2.1 *)

(*  Syntax   : Number of clauses     :   11 (   0 non-Horn;  11 unit;   1 RR) *)

(*             Number of atoms       :   11 (  11 equality) *)

(*             Maximal clause size   :    1 (   1 average) *)

(*             Number of predicates  :    1 (   0 propositional; 2-2 arity) *)

(*             Number of functors    :    7 (   4 constant; 0-2 arity) *)

(*             Number of variables   :   19 (   2 singleton) *)

(*             Maximal term depth    :    9 (   3 average) *)

(*  Comments : Ortholattice lemmas are included in McCunes original, but have *)

(*             been removed here. *)

(*           : The smallest model has 10 elements. *)

(*  Bugfixes : v2.2.1 - Bugfix in LAT003-0.ax. *)

(* -------------------------------------------------------------------------- *)

(* ----Include ortholattice axioms *)

(* Inclusion of: Axioms/LAT003-0.ax *)

(* -------------------------------------------------------------------------- *)

(*  File     : LAT003-0 : TPTP v3.7.0. Bugfixed v2.2.1. *)

(*  Domain   : Lattice Theory (Ortholattices) *)

(*  Axioms   : Ortholattice theory (equality) axioms *)

(*  Version  : [McC98b] (equality) axioms. *)

(*  English  :  *)

(*  Refs     : [McC98a] McCune (1998), Automatic Proofs and Counterexamples f *)

(*           : [McC98b] McCune (1998), Email to G. Sutcliffe *)

(*  Source   : [McC98b] *)

(*  Names    :  *)

(*  Status   :  *)

(*  Syntax   : Number of clauses    :   10 (   0 non-Horn;  10 unit;   0 RR) *)

(*             Number of atoms      :   10 (  10 equality) *)

(*             Maximal clause size  :    1 (   1 average) *)

(*             Number of predicates :    1 (   0 propositional; 2-2 arity) *)

(*             Number of functors   :    5 (   2 constant; 0-2 arity) *)

(*             Number of variables  :   19 (   2 singleton) *)

(*             Maximal term depth   :    4 (   2 average) *)

(*  Comments :  *)

(*  Bugfixes : v2.2.1 - Added clauses top and bottom. *)

(* -------------------------------------------------------------------------- *)

(* ----Axioms for an Ortholattice: *)

(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)

(* ----Denial of equation E1 *)
ntheorem prove_e1:
 (∀Univ:Type.∀X:Univ.∀Y:Univ.∀Z:Univ.
∀a:Univ.
∀b:Univ.
∀complement:∀_:Univ.Univ.
∀join:∀_:Univ.∀_:Univ.Univ.
∀meet:∀_:Univ.∀_:Univ.Univ.
∀n0:Univ.
∀n1:Univ.
∀H0:∀X:Univ.∀Y:Univ.eq Univ (meet X Y) (complement (join (complement X) (complement Y))).
∀H1:∀X:Univ.∀Y:Univ.eq Univ (join X (join Y (complement Y))) (join Y (complement Y)).
∀H2:∀X:Univ.eq Univ (complement (complement X)) X.
∀H3:∀X:Univ.∀Y:Univ.∀Z:Univ.eq Univ (join (join X Y) Z) (join X (join Y Z)).
∀H4:∀X:Univ.∀Y:Univ.∀Z:Univ.eq Univ (meet (meet X Y) Z) (meet X (meet Y Z)).
∀H5:∀X:Univ.∀Y:Univ.eq Univ (join X Y) (join Y X).
∀H6:∀X:Univ.∀Y:Univ.eq Univ (meet X Y) (meet Y X).
∀H7:∀X:Univ.∀Y:Univ.eq Univ (join X (meet X Y)) X.
∀H8:∀X:Univ.eq Univ (meet (complement X) X) n0.
∀H9:∀X:Univ.eq Univ (join (complement X) X) n1.eq Univ (join (complement (join (meet a (complement b)) (complement a))) (join (meet a (complement b)) (join (meet (complement a) (meet (join a (complement b)) (join a b))) (meet (complement a) (complement (meet (join a (complement b)) (join a b))))))) n1)
.
#Univ ##.
#X ##.
#Y ##.
#Z ##.
#a ##.
#b ##.
#complement ##.
#join ##.
#meet ##.
#n0 ##.
#n1 ##.
#H0 ##.
#H1 ##.
#H2 ##.
#H3 ##.
#H4 ##.
#H5 ##.
#H6 ##.
#H7 ##.
#H8 ##.
#H9 ##.
nauto by H0,H1,H2,H3,H4,H5,H6,H7,H8,H9 ##;
ntry (nassumption) ##;
nqed.

(* -------------------------------------------------------------------------- *)
