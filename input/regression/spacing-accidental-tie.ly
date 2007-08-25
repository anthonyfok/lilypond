\version "2.11.30"

\header {
  texidoc = "Horizontal spacing works as expected on tied notes with
accidentals. No space is reserved for accidentals that end up not being printed,
but accindentals that are printed don't collide with anything."
}

\paper { ragged-right = ##t }

\relative c'
{ \time 1/4
  cis16 cis cis cis~
  cis cis cis cis
  c c c c \break

  cis16 cis cis cis~
  cis! cis cis cis
  c c c c \break

  cis cis cis cis~ \break
  cis
}