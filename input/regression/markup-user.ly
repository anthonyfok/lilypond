
\header {
  texidoc = "Users may define non-standard markup commands using
the @code{define-markup-command} scheme macro."
}


\layout { ragged-right = ##t }
  


\version "2.12.0"

#(define-markup-command (upcase paper props str) (string?)
  "Upcase the string characters. Syntax: \\upcase #\"string\""
  (interpret-markup paper props (make-simple-markup (string-upcase str))))

\score{
  {
    c''-\markup \upcase #"hello world"
				% produces a "HELLO WORLD" markup
  }

  \layout {
    \context {
      \Score
      \override PaperColumn #'keep-inside-line = ##f
    }
  }

}
