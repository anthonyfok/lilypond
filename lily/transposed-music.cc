/*   
  transposed-music.cc --  implement Transposed_music
  
  source file of the GNU LilyPond music typesetter
  
  (c) 1998--2000 Han-Wen Nienhuys <hanwen@cs.uu.nl>
  
 */

#include "transposed-music.hh"
#include "debug.hh"

Transposed_music::Transposed_music (Music *p, Musical_pitch pit)
  : Music_wrapper (p)
{
  transpose_to_pitch_ = pit;
  p->transpose (pit);
}


Musical_pitch
Transposed_music::to_relative_octave (Musical_pitch p)
{

  return p;
}



