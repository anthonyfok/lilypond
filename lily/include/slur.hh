/*
  slur.hh -- declare Slur

  (c) 1996--2000 Han-Wen Nienhuys
*/

#ifndef SLUR_HH
#define SLUR_HH

#include "spanner.hh"
#include "rod.hh"

/**
  A #Bow# which tries to drape itself around the stems too.
 */
class Slur : public Spanner
{
public:
  Slur (SCM);
  VIRTUAL_COPY_CONS(Score_element);

  void add_column (Note_column*);
 static SCM brew_molecule (SCM);
  
  SCM member_brew_molecule () const;
  virtual Array<Offset> get_encompass_offset_arr () const;
  Bezier get_curve () const;

  virtual Direction get_default_dir () const;
  SCM member_after_line_breaking ();
  static SCM after_line_breaking (SCM);
  virtual void do_add_processing ();
  Array<Rod> get_rods () const;
  Offset get_attachment (Direction dir) const;

private:  
  void de_uglyfy (Slur_bezier_bow* bb, Real default_height);
  void set_extremities ();
  void set_control_points ();
  Offset encompass_offset (Note_column const* )const;
};

#endif // SLUR_HH


