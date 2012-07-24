%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.2"

\header {
  lsrtags = "correction-wanted, spacing, text, vocal-music, workaround"

  texidoc = "
This snippet shows how to bring the lyrics line closer to the staff.

"
  doctitle = "Adjusting lyrics vertical spacing"
} % begin verbatim

% Default layout:
<<
  \new Staff \new Voice = melody \relative c' {
    c4 d e f
    g4 f e d
    c1
  }
  \new Lyrics \lyricsto melody { aa aa aa aa aa aa aa aa aa }

  \new Staff {
    \new Voice = melody \relative c' {
      c4 d e f
      g4 f e d
      c1
    }
  }
  % Reducing the minimum space below the staff and above the lyrics:
  \new Lyrics \with {
    \override VerticalAxisGroup #'nonstaff-relatedstaff-spacing = #'((basic-distance . 1))
  }
  \lyricsto melody { aa aa aa aa aa aa aa aa aa }
>>
