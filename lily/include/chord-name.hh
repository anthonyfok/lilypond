/*
  chord-name.hh -- declare Chord_name

  source file of the GNU LilyPond music typesetter

  (c)  1999--2003 Jan Nieuwenhuizen <janneke@gnu.org>
*/

#ifndef CHORD_NAME_HH
#define CHORD_NAME_HH

#include "lily-guile.hh"
#include "molecule.hh"


class Chord_name
{
public:
  DECLARE_SCHEME_CALLBACK (after_line_breaking, (SCM ));
  static  bool has_interface (Grob*);
};

#endif // CHORD_NAME_HH
