\version "1.7.26"

\paper { raggedright = ##t }

topVoice = \notes \relative c'
{
	\key d\major
	es8-(-[ g-] a-[ fis-]-)
	b4
	b16-[-. b-. b-. cis-.-]
	d4->
}



botVoice = \notes \relative c'
{
    \key d\major
    c8-[-( f-] b-[ a-)-]
    es4
    es16-[-. es-. es-. fis-.-]
    b4->
}


hoom = \notes \relative c {
    \key d \major
    \clef bass
    
    g8-. r
    r4 
    fis8-.
    r8
    r4
    b'4->
}

pah = \notes \relative c'
{
    r8 b-.
    r4
    r8 g8-.
    r16 g-. r8
    \clef treble
    fis'4->
}

%
% setup for Request->Element conversion. Guru-only
%

MyStaffContext=\translator {
	\type "Engraver_group_engraver"
	\name Staff

	\description "Handles clefs, bar lines, keys, accidentals.  It can contain
@code{Voice} contexts."

	
	\consists "Output_property_engraver"	
	
	\consists "Font_size_engraver"

	\consists "Volta_engraver"
	\consists "Separating_line_group_engraver"	
	SeparatingGroupSpanner \override #'spacing-procedure
	  =  #Separating_group_spanner::set_spacing_rods_and_seqs
	\consists "Dot_column_engraver"

	\consists "Ottava_spanner_engraver"
	\consists "Rest_collision_engraver"
	\consists "Piano_pedal_engraver"
	\consists "Instrument_name_engraver"
	\consists "Grob_pq_engraver"
	\consists "Forbid_line_break_engraver"
	\consistsend "Axis_group_engraver"
\consists "Pitch_squash_engraver"

	minimumVerticalExtent = #'(-6 . 6)
	extraVerticalExtent = ##f
	verticalExtent = ##f 
	localKeySignature = #'()

	% explicitly set instrument, so we don't get 
	% weird effects when doing instrument names for
	% piano staves

	instrument = #'()
	instr = #'()
	  
	\accepts "Voice"
}


MyVoiceContext = \translator {
	\type "Engraver_group_engraver"
	\name Voice

\description "
    Corresponds to a voice on a staff.  This context handles the
    conversion of dynamic signs, stems, beams, super- and subscripts,
    slurs, ties, and rests.

    You have to instantiate this explicitly if you want to have
    multiple voices on the same staff."

	localKeySignature = #'()
	\consists "Font_size_engraver"
	
	% must come before all
	\consists "Voice_devnull_engraver"
	\consists "Output_property_engraver"	
	\consists "Arpeggio_engraver"
	\consists "Multi_measure_rest_engraver"
	\consists "Text_spanner_engraver"
	\consists "Grob_pq_engraver"
	\consists "Note_head_line_engraver"
	\consists "Glissando_engraver"
	\consists "Ligature_bracket_engraver"
	\consists "Breathing_sign_engraver"
 	% \consists "Rest_engraver"
	\consists "Grace_beam_engraver"
	\consists "New_fingering_engraver"
	\consists "Chord_tremolo_engraver"
	\consists "Percent_repeat_engraver"
	\consists "Slash_repeat_engraver"
	\consists "Melisma_engraver"

%{
 Must come before text_engraver, but after note_column engraver.

%}
	\consists "Text_engraver"
	\consists "Dynamic_engraver"
	\consists "Fingering_engraver"

	\consists "Script_column_engraver"
	\consists "Rhythmic_column_engraver"
	\consists "Cluster_spanner_engraver"
	\consists "Tie_engraver"
	\consists "New_tie_engraver"
	\consists "Tuplet_engraver"
	\consists "A2_engraver"

	\consists "Skip_event_swallow_translator"
	\accepts Thread % bug if you leave out this!
}

MyThreadContext = \translator{
	\type Engraver_group_engraver
	\name Thread
	localKeySignature = #'()
\description "
    Handles note heads, and is contained in the Voice context.  You
    have to instantiate this explicitly if you want to adjust the
    style of individual note heads.
"
	\consists "Font_size_engraver"	
	\consists "Thread_devnull_engraver"
	\consists "Note_heads_engraver"
	\consists "Rest_engraver"

	% why here ? 
	\consists "Output_property_engraver"	

}




\score {
  \topVoice
  \paper {
      \translator { \MyStaffContext }
      \translator { \MyVoiceContext }
      \translator { \MyThreadContext }
      }
}


MyStaffContext = \translator {
    \MyStaffContext
    \consists "Staff_symbol_engraver"
}

\score {
  \topVoice
  \paper {
      \translator { \MyStaffContext }
      \translator { \MyVoiceContext }
      \translator { \MyThreadContext }
      }
}

MyStaffContext = \translator {
    \MyStaffContext
      \consists "Clef_engraver"
    \remove "Pitch_squash_engraver"
}

\score {
  \topVoice
  \paper {
      \translator { \MyStaffContext }
      \translator { \MyVoiceContext }
      \translator { \MyThreadContext }
      }
}

MyVoiceContext = \translator {
    \MyVoiceContext
    \consists "Stem_engraver"
    }

\score {
  \topVoice
  \paper {
      \translator { \MyStaffContext }
      \translator { \MyVoiceContext }
      \translator { \MyThreadContext }
      }
}

MyVoiceContext = \translator {
    \MyVoiceContext
    	\consists "Beam_engraver"
}

\score {
  \topVoice
  \paper {
      \translator { \MyStaffContext }
      \translator { \MyVoiceContext }
      \translator { \MyThreadContext }
      }
}

MyVoiceContext= \translator {
    \MyVoiceContext
    \consists "Phrasing_slur_engraver"
    \consists "Slur_engraver"
    \consists "Script_engraver"
}


\score {
  \topVoice
  \paper {
      \translator { \MyStaffContext }
      \translator { \MyVoiceContext }
      \translator { \MyThreadContext }
      }
}

MyStaffContext = \translator {
    \MyStaffContext
 \consists "Bar_engraver"
    \consists "Time_signature_engraver"
      
}

\score {
  \topVoice
  \paper {
      \translator { \MyStaffContext }
      \translator { \MyVoiceContext }
      \translator { \MyThreadContext }
      }
}

MyStaffContext = \translator
 { \MyStaffContext
 \consists "Accidental_engraver"    
     \consists "Key_engraver"
}
\score {
  \topVoice
  \paper {
      \translator { \MyStaffContext }
      \translator { \MyVoiceContext }
      \translator { \MyThreadContext }
      }
}

\score {
\context Staff < \topVoice \\ \botVoice >
  \paper {
      \translator { \MyStaffContext }
      \translator { \MyVoiceContext }
      \translator { \MyThreadContext }
      }
}


MyStaffContext = \translator {
    \MyStaffContext
    
    \consists "Collision_engraver"
}

\score {
\context Staff < \topVoice \\ \botVoice >
  \paper {
      \translator { \MyStaffContext }
      \translator { \MyVoiceContext }
      \translator { \MyThreadContext }
      }
}


\score {
< \context Staff < \topVoice \\ \botVoice >
\context Staff = SB < \pah \\ \hoom >
  >
  \paper {
      \translator { \MyStaffContext }
      \translator { \MyVoiceContext }
      \translator { \MyThreadContext }
      }
}



