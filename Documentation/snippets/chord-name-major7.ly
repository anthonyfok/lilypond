%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.2"

\header {
  lsrtags = "chords, specific-notation"

  texidoc = "
The layout of the major 7 can be tuned with @code{majorSevenSymbol}.

"
  doctitle = "chord name major7"
} % begin verbatim


\chords {
  c:7+
  \set majorSevenSymbol = \markup { j7 }
  c:7+
}
