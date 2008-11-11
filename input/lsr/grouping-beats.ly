%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.62"

\header {
  lsrtags = "rhythms"

  texidoces = "
Los patrones de barrado se pueden alterar con la propiedad
@code{beatGrouping}:

"
  doctitlees = "Agrupar los pulsos"

  texidoc = "
Beaming patterns may be altered with the @code{beatGrouping} property: 

"
  doctitle = "Grouping beats"
} % begin verbatim

\relative c'' {
  \time 5/16
  \set beatGrouping = #'(2 3)
  c8[^"(2+3)" c16 c8]
  \set beatGrouping = #'(3 2)
  c8[^"(3+2)" c16 c8]
}

