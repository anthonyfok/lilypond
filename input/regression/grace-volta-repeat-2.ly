#(ly:set-option 'old-relative)
\version "1.9.1"

\header {

    texidoc = "Graces at combined with volta repeats: a repeat
starting with a grace, following a repeat directly. The bars should be
merged into one :||:."

      }

    \paper { raggedright= ##t }

\score {\notes\relative c' {
\repeat volta 2 {
        c1 
}
\repeat volta 2 {
        \grace {c8 } c4
}
}}
