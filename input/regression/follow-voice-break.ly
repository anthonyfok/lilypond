#(ly:set-option 'old-relative)
\version "1.9.1"
\header{
       texidoc = "
When put across line breaks, only the part before the line break is
printed. The line-spanners connects to the Y position of the note  on the next line.
"

}

\score{
        \context PianoStaff <
	    \property PianoStaff.followVoice = ##t	    
                \context Staff=one \notes\relative c''{
		    a1 \break
		    \translator Staff=two
		    a,
		}
        \context Staff=two { \clef bass \skip 1*2 }
    >
    \paper{
	raggedright = ##t
    }
}
