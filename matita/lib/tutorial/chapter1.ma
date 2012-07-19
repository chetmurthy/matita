(* 
Data types, functions and theorems

Matita is both a programming language and a theorem proving environment:
you define datatypes and programs, and then prove properties on them.
Very few things are built-in: not even booleans or logical connectives
(but you may of course use libraries, as in normal programming languages). 
The main philosophy of the system is to let you define your own data-types 
and functions using a powerful computational mechanism based on the 
declaration of inductive types. 

Let us start this tutorial with a simple example based on the following well 
known problem.

The goat, the wolf and the cabbage
A farmer need to transfer a goat, a wolf and a cabbage across a river, but there
is only one place available on his boat. Furthermore, the goat will eat the 
cabbage if they are left alone on the same bank, and similarly the wolf will eat
the goat. The problem consists in bringing all three items safely across the 
river. 

Our first data type defines the two banks of the river, which will be named east
and west. It is a simple example of enumerated type, defined by explicitly 
declaring all its elements. The type itself is called "bank".
Before giving its definition we "include" the file "logic.ma" that contains a 
few preliminary notions not worth discussing for the moment.
*)

include "basics/logic.ma".

inductive bank: Type[0] ≝
| east : bank 
| west : bank.

(* We can now define a simple function computing, for each bank of the river, the
opposite one. *)

definition opposite ≝ λs.
match s with
  [ east ⇒ west
  | west ⇒ east
  ].

(* Functions are live entities, and can be actually computed. To check this, let
us state the property that the opposite bank of east is west; every lemma needs a 
name for further reference, and we call it "east_to_west". *)
 
lemma east_to_west : opposite east = west.

(* 
The goal window

If you stop the execution here you will see a new window on the  right side
of the screen: it is the goal window, providing a sequent like representation of
the form

B1
B2
....
Bk
-----------------------
A

for each open goal remaining to be solved. A is the conclusion of the goal and 
B1, ..., Bk is its context, that is the set of current hypothesis and type 
declarations. In this case, we have only one goal, and its context is empty. 
The proof proceeds by typing commands to the system. In this case, we
want to evaluate the function, that can be done by invoking the  "normalize"
command:
*)

normalize

(* By executing it - just type the advance command - you will see that the goal
has changed to west = west, by reducing the subexpression (opposite east). 
You may use the retract bottom to undo the step, if you wish. 

The new goal west = west is trivial: it is just a consequence of reflexivity.
Such trivial steps can be just closed in Matita by typing a double slash. 
We complete the proof by the qed command, that instructs the system to store the
lemma performing some book-keeping operations. 
*)

// qed.

(* In exactly the same way, we can prove that the opposite side of west is east.
In this case, we avoid the unnecessary simplification step: // will take care of 
it. *) 

lemma west_to_east : opposite west = east.
// qed.

(*
Introduction

A slightly more complex problem consists in proving that opposite is idempotent *)

lemma idempotent_opposite : ∀x. opposite (opposite x) = x.

(* we start the proof moving x from the conclusion into the context, that is a 
(backward) introduction step. Matita syntax for an introduction step is simply 
the sharp character followed by the name of the item to be moved into the 
context. This also allows us to rename the item, if needed: for instance if we 
wish to rename x into b (since it is a bank), we just type #b. *)

#b

(* See the effect of the execution in the goal window on the right: b has been 
added to the context (replacing x in the conclusion); moreover its implicit type 
"bank" has been made explicit. 
*)

(*
Case analysis

But how are we supposed to proceed, now? Simplification cannot help us, since b
is a variable: just try to call normalize and you will see that it has no effect.
The point is that we must proceed by cases according to the possible values of b,
namely east and west. To this aim, you must invoke the cases command, followed by
the name of the hypothesis (more generally, an arbitrary expression) that must be
the object of the case analysis (in our case, b).
*)

cases b

(* Executing the previous command has the effect of opening two subgoals, 
corresponding to the two cases b=east and b=west: you may switch from one to the 
other by using the hyperlinks over the top of the goal window. 
Both goals can be closed by trivial computations, so we may use // as usual.
If we had to treat each subgoal in a different way, we should focus on each of 
them in turn, in a way that will be described at the end of this section.
*)

// qed.

(* 
Predicates

Instead of working with functions, it is sometimes convenient to work with
predicates. For instance, instead of defining a function computing the opposite 
bank, we could declare a predicate stating when two banks are opposite to each 
other. Only two cases are possible, leading naturally to the following 
definition:
*)

inductive opp : bank → bank → Prop ≝ 
| east_west : opp east west
| west_east : opp west east.

(* In precisely the same way as "bank" is the smallest type containing east and
west, opp is the smallest predicate containing the two sub-cases east_west and
weast_east. If you have some familiarity with Prolog, you may look at opp as the
predicate defined by the two clauses - in this case, the two facts - ast_west and
west_east.

Between opp and opposite we have the following relation:
    opp a b iff a = opposite b
Let us prove it, starting from the left to right implication, first *)

lemma opp_to_opposite: ∀a,b. opp a b → a = opposite b.
 
(* We start the proof introducing a, b and the hypothesis opp a b, that we
call oppab. *)
#a #b #oppab

(* Now we proceed by cases on the possible proofs of (opp a b), that is on the 
possible shapes of oppab. By definition, there are only two possibilities, 
namely east_west or west_east. Both subcases are trivial, and can be closed by
automation *)

cases oppab // qed.

(* 
Rewriting

Let us come to the opposite direction. *)

lemma opposite_to_opp: ∀a,b. a = opposite b → opp a b.

(* As usual, we start introducing a, b and the hypothesis (a = opposite b), 
that we call eqa. *)

#a #b #eqa

(* The right way to proceed, now, is by rewriting a into (opposite b). We do
this by typing ">eqa". If we wished to rewrite in the opposite direction, namely
opposite b into a, we would have typed "<eqa". *)

>eqa

(* We conclude the proof by cases on b. *)

cases b // qed.

(*
Records

It is time to proceed with our formalization of the farmer's problem. 
A state of the system is defined by the position of four items: the goat, the 
wolf, the cabbage, and the boat. The simplest way to declare such a data type
is to use a record.
*)

record state : Type[0] ≝
  {goat_pos : bank;
   wolf_pos : bank;
   cabbage_pos: bank;
   boat_pos : bank}.

(* When you define a record named foo, the system automatically defines a record 
constructor named mk_foo. To construct a new record you pass as arguments to 
mk_foo the values of the record fields *)

definition start ≝ mk_state east east east east.
definition end ≝ mk_state west west west west.

(* We must now define the possible moves. A natural way to do it is in the form 
of a relation (a binary predicate) over states. *)

inductive move : state → state → Prop ≝
| move_goat: ∀g,g1,w,c. opp g g1 → move (mk_state g w c g) (mk_state g1 w c g1)
  (* We can move the goat from a bank g to the opposite bank g1 if and only if the
     boat is on the same bank g of the goat and we move the boat along with it. *)
| move_wolf: ∀g,w,w1,c. opp w w1 → move (mk_state g w c w) (mk_state g w1 c w1)
| move_cabbage: ∀g,w,c,c1.opp c c1 → move (mk_state g w c c) (mk_state g w c1 c1)
| move_boat: ∀g,w,c,b,b1. opp b b1 → move (mk_state g w c b) (mk_state g w c b1).

(* A state is safe if either the goat is on the same bank of the boat, or both 
the wolf and the cabbage are on the opposite bank of the goat. *)

inductive safe_state : state → Prop ≝
| with_boat : ∀g,w,c.safe_state (mk_state g w c g)
| opposite_side : ∀g,g1,b.opp g g1 → safe_state (mk_state g g1 g1 b).

(* Finally, a state y is reachable from x if either there is a single move 
leading from x to y, or there is a safe state z such that z is reachable from x 
and there is a move leading from z to y *)

inductive reachable : state → state → Prop ≝
| one : ∀x,y.move x y → reachable x y
| more : ∀x,z,y. reachable x z → safe_state z → move z y → reachable x y.

(* 
Automation

Remarkably, Matita is now able to solve the problem by itslef, provided
you allow automation to exploit more resources. The command /n/ is similar to
//, where n is a measure of this complexity: in particular it is a bound to
the depth of the expected proof tree (more precisely, to the number of nested
applicative nodes). In this case, there is a solution in six moves, and we
need a few more applications to handle reachability, and side conditions. 
The magic number to let automation work is, in this case, 9.  *)

lemma problem: reachable start end.
normalize /9/ qed. 

(* 
Application

Let us now try to derive the proof in a more interactive way. Of course, we
expect to need several moves to transfer all items from a bank to the other, so 
we should start our proof by applying "more". Matita syntax for invoking the 
application of a property named foo is to write "@foo". In general, the philosophy 
of Matita is to describe each proof of a property P as a structured collection of 
objects involved in the proof, prefixed by simple modalities (#,<,@,...) explaining 
the way it is actually used (e.g. for introduction, rewriting, in an applicative 
step, and so on).
*)

lemma problem1: reachable start end.
normalize @more

(* 
Focusing

After performing the previous application, we have four open subgoals:

  X : STATE
  Y : reachable [east,east,east,east] X
  W : safe_state X
  Z : move X [west,west,west,west]
 
That is, we must guess a state X, such that this is reachable from start, it is 
safe, and there is a move leading from X to end. All goals are active, that is
emphasized by the fact that they are all red. Any command typed by the user is
normally applied in parallel to all active goals, but clearly we must proceed 
here is a different way for each of them. The way to do it, is by structuring
the script using the following syntax: [...|... |...|...] where we typically have
as many cells inside the brackets as the number of the active subgoals. The
interesting point is that we can associate with the three symbol "[", "|" and
"]" a small-step semantics that allow to execute them individually. In particular

- the operator "[" opens a new focusing section for the currently active goals,
  and focus on the first of them
- the operator "|" shift the focus to the next goal
- the operator "]" close the focusing section, falling back to the previous level
  and adding to it all remaining goals not yet closed

Let us see the effect of the "[" on our proof:
*)

  [  

(* As you see, only the first goal has now the focus on. Moreover, all goals got
a progressive numerical label, to help designating them, if needed. 
We can now proceed in several possible ways. The most straightforward way is to 
provide the intermediate state, that is [east,west,west,east]. We can do it, by 
just applying this term. *)

   @(mk_state east west west east) 

(* This application closes the goal; at present, no goal has the focus on.
In order to act on the next goal, we must focus on it using the "|" operator. In
this case, we would like to skip the next goal, and focus on the trivial third 
subgoal: a simple way to do it, is by retyping "|". The proof that 
[east,west,west,east] is safe is trivial and can be done with //.*)

  || //

(*
We then advance to the next goal, namely the fact that there is a move from 
[east,west,west,east] to [west,west,west,west]; this is trivial too, but it 
requires /2/ since move_goat opens an additional subgoal. By applying "]" we
refocus on the skipped goal, going back to a situation similar to the one we
started with. *)

  | /2/ ] 

(* 
Implicit arguments

Let us perform the next step, namely moving back the boat, in a sligtly 
different way. The more operation expects as second argument the new 
intermediate state, hence instead of applying more we can apply this term
already instatated on the next intermediate state. As first argument, we
type a question mark that stands for an implicit argument to be guessed by
the system. *)

@(more ? (mk_state east west west west))

(* We now get three independent subgoals, all actives, and two of them are 
trivial. We can just apply automation to all of them, and it will close the two
trivial goals. *)

/2/

(* Let us come to the next step, that consists in moving the wolf. Suppose that 
instead of specifying the next intermediate state, we prefer to specify the next 
move. In the spirit of the previous example, we can do it in the following way 
*)

@(more … (move_wolf … ))

(* The dots stand here for an arbitrary number of implicit arguments, to be 
guessed by the system. 
Unfortunately, the previous move is not enough to fully instantiate the new 
intermediate state: a bank B remains unknown. Automation cannot help here,
since all goals depend from this bank and automation refuses to close some
subgoals instantiating other subgoals remaining open (the instantiation could
be arbitrary). The simplest way to proceed is to focus on the bank, that is
the fourth subgoal, and explicitly instatiate it. Instead of repeatedly using "|",
we can perform focusing by typing "4:" as described by the following command. *)

[4: @east] /2/

(* Alternatively, we can directly instantiate the bank into the move. Let
us complete the proof in this, very readable way. *)

@(more … (move_goat west … )) /2/
@(more … (move_cabbage ?? east … )) /2/
@(more … (move_boat ??? west … )) /2/
@one /2/ qed.