%% DO NOT EDIT this file manually; it is automatically
%% generated from LSR http://lsr.dsi.unimi.it
%% Make any changes in LSR itself, or in Documentation/snippets/new/ ,
%% and then run scripts/auxiliar/makelsr.py
%%
%% This file is in the public domain.
\version "2.14.2"

\header {
  lsrtags = "contemporary-notation, pitches, really-cool, staff-notation, version-specific"

  texidoc = "
The commonly used @code{\\key} command sets the @code{keySignature}
property, in the @code{Staff} context.

To create non-standard key signatures, set this property directly. The
format of this command is a list:

@code{ \\set Staff.keySignature = #`(((octave . step) . alter) ((octave
. step) . alter) ...) } where, for each element in the list,
@code{octave} specifies the octave (0 being the octave from middle C to
the B above), @code{step} specifies the note within the octave (0 means
C and 6 means B), and @code{alter} is @code{,SHARP ,FLAT ,DOUBLE-SHARP}
etc. (Note the leading comma.) The accidentals in the key signature
will appear in the reverse order to that in which they are specified.


Alternatively, for each item in the list, using the more concise format
@code{(step . alter)} specifies that the same alteration should hold in
all octaves.


For microtonal scales where a @qq{sharp} is not 100 cents, @code{alter}
refers to the alteration as a proportion of a 200-cent whole tone.


Here is an example of a possible key signature for generating a
whole-tone scale:

"
  doctitle = "Non-traditional key signatures"
} % begin verbatim


\relative c' {
  \set Staff.keySignature = #`(((0 . 6) . ,FLAT)
                               ((0 . 5) . ,FLAT)
                               ((0 . 3) . ,SHARP))
  c4 d e fis
  aes4 bes c2
}
