\header {

    texidoc = "With the newaddlyrics mechanism, individual lyric lines
    can be associated with one melody line. For each lyric line, can
    be tuned whether to follow melismata or not."
    
}

\score {
<<
    \notes \context Voice = "bla" \relative c'' {
	\autoBeamOff
	c2( d4) e8[ c b c] f4
    }
    \newaddlyrics "bla" \lyrics \new LyricsVoice { bla ab blob blob }
    \newaddlyrics "bla" \lyrics \new LyricsVoice {
	bla 

	\property LyricsVoice . ignoreMelismata = ##t
	
	blob

	%% note: effect of ignoreMelismata delayed one time step.
	\property LyricsVoice . ignoreMelismata \unset
	blob
	
	blob
    }
    
    \new Lyrics <<  \newaddlyrics "bla" \lyrics \new LyricsVoice { nes ted lyrics voice with more words than no tes } >>
    >>

    }
