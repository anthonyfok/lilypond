%% Do not edit this file; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.13.39"

\header {
  lsrtags = "expressive-marks, editorial-annotations"

%% Translation of GIT committish: a874fda3641c9e02f61be5c41b215b8304b8ed00
  texidoces = "
Se puede cambiar el aspecto de las ligaduras de expresión de
continuas a punteadas o intermitentes.

"
  doctitlees = "Modificar el aspecto continuo de una ligadura de expresión a punteado o intermitente"

  texidoc = "
The appearance of slurs may be changed from solid to dotted or dashed.

"
  doctitle = "Changing the appearance of a slur from solid to dotted or dashed"
} % begin verbatim

\relative c' {
  c4( d e c)
  \slurDotted
  c4( d e c)
  \slurSolid
  c4( d e c)
  \slurDashed
  c4( d e c)
  \slurSolid
  c4( d e c)
}


