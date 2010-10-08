(* Copyright (C) 2005, HELM Team.
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
 * http://helm.cs.unibo.it/
 *)

exception Drop
exception IncludedFileNotCompiled of string * string
exception Macro of
 GrafiteAst.loc *
  (Cic.context -> GrafiteTypes.status * (Cic.term,unit) GrafiteAst.macro)
exception NMacro of GrafiteAst.loc * GrafiteAst.nmacro

type 'a disambiguator_input = string * int * 'a

val eval_ast :
  disambiguate_command:
   (GrafiteTypes.status ->
    (('term,'obj) GrafiteAst.command) disambiguator_input ->
    GrafiteTypes.status * (Cic.term, Cic.obj) GrafiteAst.command) ->

  disambiguate_macro:
   (GrafiteTypes.status ->
    (('term,'lazy_term) GrafiteAst.macro) disambiguator_input ->
    Cic.context -> GrafiteTypes.status * (Cic.term,unit) GrafiteAst.macro) ->

  ?do_heavy_checks:bool ->
  GrafiteTypes.status ->
  (('term, 'lazy_term, 'reduction, 'obj, 'ident) GrafiteAst.statement)
  disambiguator_input ->
   (* the new status and generated objects, if any *)
   GrafiteTypes.status * [`Old of UriManager.uri list | `New of NUri.uri list]
