
\header {
    texidoc = "Scoring based slur formatting."
}

\paper {
    raggedright = ##t
}

% #(ly:set-option 'debug-beam #t)

%% help lilypond-book
%% \score

\relative {
    \override Slur #'after-line-breaking-callback = #New_slur::after_line_breaking
    \override Slur #'print-function = #New_slur::print     
    \override Slur #'height = ##f

    \grace {
	e=''16( 
    }
    d8.[) c16]
    d8.[ \grace f16( e16)]
    s2 

    << {c=''8.([ es16] bes4~bes )}
       \\
       {r8  <as es> r <f des> r }
   >>
    s4
    
    f'=''16( e)    d( c)
    s2.
    
    c'=''2(~c8 d16 c b8 a)
    
    <c=' g>4 ( f <g b>) f
    <c g>^( f <g b>) f
    <c g>_( f <g b>)
    <g b>_( g  <b d>)
    <g b>_( \stemDown g \stemBoth  <b d>)
    c,^( c'' c) 
    c,,^( c'')
    c,,^( c')
    }

% #(ly:set-option 'debug-beam #f)
