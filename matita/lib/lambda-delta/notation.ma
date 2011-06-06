(*
    ||M||  This file is part of HELM, an Hypertextual, Electronic
    ||A||  Library of Mathematics, developed at the Computer Science
    ||T||  Department of the University of Bologna, Italy.
    ||I||
    ||T||
    ||A||  This file is distributed under the terms of the
    \   /  GNU General Public License Version 2
     \ /
      V_______________________________________________________________ *)

(* NOTATION FOR THE FORMAL SYSTEM λδ ****************************************)

(* language *****************************************************************)

notation "hvbox( ζ I )"
 non associative with precedence 45
 for @{ 'Zeta $I }.

notation "hvbox( τ I )"
 non associative with precedence 45
 for @{ 'Tau $I }.

notation "hvbox( θ I )"
 non associative with precedence 45
 for @{ 'Theta $I }.

notation "hvbox( ⋆ )"
 non associative with precedence 90
 for @{ 'Star }.

notation "hvbox( ⋆ k )"
 non associative with precedence 90
 for @{ 'Star $k }.

notation "hvbox( 𝕚 { I } break (term 90 T1) . break (term 90 T) )"
 non associative with precedence 90
 for @{ 'SItem $I $T1 $T }.

notation "hvbox( 𝕓 { I } break (term 90 T1) . break (term 90 T) )"
 non associative with precedence 90
 for @{ 'SBind $I $T1 $T }.

notation "hvbox( 𝕗 { I } break (term 90 T1) . break (term 90 T) )"
 non associative with precedence 90
 for @{ 'SFlat $I $T1 $T }.

notation "hvbox( T . break 𝕓 { I } break (term 90 T1) )"
 non associative with precedence 89
 for @{ 'DBind $T $I $T1 }.

notation "hvbox( # term 90 x )"
 non associative with precedence 90
 for @{ 'Weight $x }.

notation "hvbox( # [ x , break y ] )"
 non associative with precedence 90
 for @{ 'Weight $x $y }.

(* substitution *************************************************************)

notation "hvbox( ↑ [ d , break e ] break T1 ≡ break T2 )"
   non associative with precedence 45
   for @{ 'RLift $T1 $d $e $T2 }.

notation "hvbox( ↓ [ d , break e ] break L1 ≡ break L2 )"
   non associative with precedence 45
   for @{ 'RSubst $L1 $d $e $L2 }.

notation "hvbox( L ⊢ break ↓ [ d , break e ] break T1 ≡ break T2 )"
   non associative with precedence 45
   for @{ 'RSubst $L $T1 $d $e $T2 }.

(* reduction ****************************************************************)

notation "hvbox( L ⊢ break T1 ⇒ break T2 )"
   non associative with precedence 45
   for @{ 'PR $L $T1 $T2 }.
