(* Copyright (C) 2002, HELM Team.
 * 
 * This file is part of HELM, an Hypertextual, Electronic
 * Library of Mathematics, developed at the Computer Science
 * Department, University of Bologna, Italy.
 * 
 * HELM is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * HELM is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with HELM; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston,
 * MA  02111-1307, USA.
 * 
 * For details, see the HELM World-Wide-Web page,
 * http://cs.unibo.it/helm/.
 *)

type tables = 
  Saturation.active_table * Saturation.passive_table * Equality.equality_bag

type cache = {
        univ : Universe.universe;
        tables : tables;
}


val empty_tables : unit -> tables
val empty : unit -> cache

val add_term_to_active: 
  cache -> Cic.metasenv -> Cic.substitution -> Cic.context -> 
    Cic.term -> Cic.term option -> cache
val pump: cache -> int -> cache
val pp_cache: cache -> unit


