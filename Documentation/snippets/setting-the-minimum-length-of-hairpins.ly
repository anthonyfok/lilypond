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
If hairpins are too short, they can be lengthened by modifying the
@code{minimum-length} property of the @code{Hairpin} object.

"
  doctitle = "Setting the minimum length of hairpins"
} % begin verbatim


\relative c'' {
  c4\< c\! d\> e\!
  \override Hairpin.minimum-length = #5
  << f1 { s4 s\< s\> s\! } >>
}
