%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.17.25"

\header {
  lsrtags = "expressive-marks"

  texidoc = "
Hairpin dynamics may be printed with a circled tip (@qq{al niente}
notation) by setting the @code{circled-tip} property of the
@code{Hairpin} object to @code{#t}.

"
  doctitle = "Printing hairpins using al niente notation"
} % begin verbatim


\relative c'' {
  \override Hairpin.circled-tip = ##t
  c2\< c\!
  c4\> c\< c2\!
}
