include "logic/equality.ma".

(* Inclusion of: LAT049-1.p *)

(* -------------------------------------------------------------------------- *)

(*  File     : LAT049-1 : TPTP v3.7.0. Released v2.5.0. *)

(*  Domain   : Lattice Theory *)

(*  Problem  : Ortholattice is not weakly orthomodular lattice *)

(*  Version  : [McC88] (equality) axioms. *)

(*  English  :  *)

(*  Refs     : [McC88] McCune (1988), Challenge Equality Problems in Lattice  *)

(*           : [RW01]  Rose & Wilkinson (2001), Application of Model Search *)

(*  Source   : [RW01] *)

(*  Names    : mace-d.in [RW01] *)

(*  Status   : Satisfiable *)

(*  Rating   : 0.33 v2.5.0 *)

(*  Syntax   : Number of clauses     :   14 (   0 non-Horn;  14 unit;   1 RR) *)

(*             Number of atoms       :   14 (  14 equality) *)

(*             Maximal clause size   :    1 (   1 average) *)

(*             Number of predicates  :    1 (   0 propositional; 2-2 arity) *)

(*             Number of functors    :    7 (   4 constant; 0-2 arity) *)

(*             Number of variables   :   23 (   2 singleton) *)

(*             Maximal term depth    :    4 (   2 average) *)

(*  Comments :  *)

(* -------------------------------------------------------------------------- *)

(* ----Include lattice axioms  *)

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

(* ----Compatibility (6) *)

(* ----Invertability (5) *)

(* ----Denial of weak orthomodular law (10) *)
ntheorem prove_weak_orthomodular_law:
 (∀Univ:Type.∀X:Univ.∀Y:Univ.∀Z:Univ.
∀a:Univ.
∀b:Univ.
∀complement:∀_:Univ.Univ.
∀join:∀_:Univ.∀_:Univ.Univ.
∀meet:∀_:Univ.∀_:Univ.Univ.
∀n0:Univ.
∀n1:Univ.
∀H0:∀X:Univ.eq Univ (complement (complement X)) X.
∀H1:∀X:Univ.eq Univ (meet (complement X) X) n0.
∀H2:∀X:Univ.eq Univ (join (complement X) X) n1.
∀H3:∀X:Univ.∀Y:Univ.eq Univ (complement (meet X Y)) (join (complement X) (complement Y)).
∀H4:∀X:Univ.∀Y:Univ.eq Univ (complement (join X Y)) (meet (complement X) (complement Y)).
∀H5:∀X:Univ.∀Y:Univ.∀Z:Univ.eq Univ (join (join X Y) Z) (join X (join Y Z)).
∀H6:∀X:Univ.∀Y:Univ.∀Z:Univ.eq Univ (meet (meet X Y) Z) (meet X (meet Y Z)).
∀H7:∀X:Univ.∀Y:Univ.eq Univ (join X Y) (join Y X).
∀H8:∀X:Univ.∀Y:Univ.eq Univ (meet X Y) (meet Y X).
∀H9:∀X:Univ.∀Y:Univ.eq Univ (join X (meet X Y)) X.
∀H10:∀X:Univ.∀Y:Univ.eq Univ (meet X (join X Y)) X.
∀H11:∀X:Univ.eq Univ (join X X) X.
∀H12:∀X:Univ.eq Univ (meet X X) X.eq Univ (join (meet (complement a) (join a b)) (join (complement b) (meet a b))) n1)
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
#H10 ##.
#H11 ##.
#H12 ##.
nauto by H0,H1,H2,H3,H4,H5,H6,H7,H8,H9,H10,H11,H12 ##;
ntry (nassumption) ##;
nqed.

(* -------------------------------------------------------------------------- *)
