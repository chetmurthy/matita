include "logic/equality.ma".

(* Inclusion of: LAT032-1.p *)

(* -------------------------------------------------------------------------- *)

(*  File     : LAT032-1 : TPTP v3.7.0. Released v2.4.0. *)

(*  Domain   : Lattice Theory *)

(*  Problem  : Distributivity of join implies distributivity of meet  *)

(*  Version  : [McC88] (equality) axioms. *)

(*  English  : *)

(*  Refs     : [DeN00] DeNivelle (2000), Email to G. Sutcliffe *)

(*             [McC88] McCune (1988), Challenge Equality Problems in Lattice *)

(*  Source   : [DeN00] *)

(*  Names    : dist_meet [DeN00] *)

(*  Status   : Unsatisfiable *)

(*  Rating   : 0.00 v2.4.0 *)

(*  Syntax   : Number of clauses     :   10 (   0 non-Horn;  10 unit;   1 RR) *)

(*             Number of atoms       :   10 (  10 equality) *)

(*             Maximal clause size   :    1 (   1 average) *)

(*             Number of predicates  :    1 (   0 propositional; 2-2 arity) *)

(*             Number of functors    :    5 (   3 constant; 0-2 arity) *)

(*             Number of variables   :   19 (   2 singleton) *)

(*             Maximal term depth    :    3 (   2 average) *)

(*  Comments :  *)

(* -------------------------------------------------------------------------- *)

(* ----Include lattice theory axioms *)

(* Inclusion of: Axioms/LAT001-0.ax *)

(* -------------------------------------------------------------------------- *)

(*  File     : LAT001-0 : TPTP v3.7.0. Released v1.0.0. *)

(*  Domain   : Lattice Theory *)

(*  Axioms   : Lattice theory (equality) axioms *)

(*  Version  : [McC88] (equality) axioms. *)

(*  English  :  *)

(*  Refs     : [Bum65] Bumcroft (1965), Proceedings of the Glasgow Mathematic *)

(*           : [McC88] McCune (1988), Challenge Equality Problems in Lattice  *)

(*           : [Wos88] Wos (1988), Automated Reasoning - 33 Basic Research Pr *)

(*  Source   : [McC88] *)

(*  Names    :  *)

(*  Status   :  *)

(*  Syntax   : Number of clauses    :    8 (   0 non-Horn;   8 unit;   0 RR) *)

(*             Number of atoms      :    8 (   8 equality) *)

(*             Maximal clause size  :    1 (   1 average) *)

(*             Number of predicates :    1 (   0 propositional; 2-2 arity) *)

(*             Number of functors   :    2 (   0 constant; 2-2 arity) *)

(*             Number of variables  :   16 (   2 singleton) *)

(*             Maximal term depth   :    3 (   2 average) *)

(*  Comments :  *)

(* -------------------------------------------------------------------------- *)

(* ----The following 8 clauses characterise lattices  *)

(* -------------------------------------------------------------------------- *)

(* -------------------------------------------------------------------------- *)
ntheorem dist_meet:
 (∀Univ:Type.∀X:Univ.∀Y:Univ.∀Z:Univ.
∀join:∀_:Univ.∀_:Univ.Univ.
∀meet:∀_:Univ.∀_:Univ.Univ.
∀xx:Univ.
∀yy:Univ.
∀zz:Univ.
∀H0:∀X:Univ.∀Y:Univ.∀Z:Univ.eq Univ (join X (meet Y Z)) (meet (join X Y) (join X Z)).
∀H1:∀X:Univ.∀Y:Univ.∀Z:Univ.eq Univ (join (join X Y) Z) (join X (join Y Z)).
∀H2:∀X:Univ.∀Y:Univ.∀Z:Univ.eq Univ (meet (meet X Y) Z) (meet X (meet Y Z)).
∀H3:∀X:Univ.∀Y:Univ.eq Univ (join X Y) (join Y X).
∀H4:∀X:Univ.∀Y:Univ.eq Univ (meet X Y) (meet Y X).
∀H5:∀X:Univ.∀Y:Univ.eq Univ (join X (meet X Y)) X.
∀H6:∀X:Univ.∀Y:Univ.eq Univ (meet X (join X Y)) X.
∀H7:∀X:Univ.eq Univ (join X X) X.
∀H8:∀X:Univ.eq Univ (meet X X) X.eq Univ (meet xx (join yy zz)) (join (meet xx yy) (meet xx zz)))
.
#Univ ##.
#X ##.
#Y ##.
#Z ##.
#join ##.
#meet ##.
#xx ##.
#yy ##.
#zz ##.
#H0 ##.
#H1 ##.
#H2 ##.
#H3 ##.
#H4 ##.
#H5 ##.
#H6 ##.
#H7 ##.
#H8 ##.
nauto by H0,H1,H2,H3,H4,H5,H6,H7,H8 ##;
ntry (nassumption) ##;
nqed.

(* -------------------------------------------------------------------------- *)
