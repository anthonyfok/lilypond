%% Do not edit this file; it is auto-generated from LSR http://lsr.dsi.unimi.it
%% This file is in the public domain.
\version "2.11.62"

\header {
  lsrtags = "simultaneous-notes, chords, keyboards"

  texidoces = "
Los «clusters» o racimos son un mecanismo para indicar la
interpretación de un ámbito de notas al mismo tiempo.

"
  doctitlees = "Clusters («racimos»)"

  texidoc = "
Clusters are a device to denote that a complete range of notes is to be
played.

"
  doctitle = "Clusters"
} % begin verbatim

\layout {
  ragged-right = ##t 
}

fragment = \relative c' {
  c4 f <e d'>4
  <g a>8 <e a> a4 c2 <d b>4
  e2 c
}

<<
  \new Staff \fragment
  \new Staff \makeClusters \fragment
>>
