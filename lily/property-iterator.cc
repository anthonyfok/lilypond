/*
  property-iterator.cc -- implement Property_iterator

  source file of the GNU LilyPond music typesetter

  (c)  1997--2000 Han-Wen Nienhuys <hanwen@cs.uu.nl>
*/

#include "property-iterator.hh"
#include "music.hh"
#include "translator-def.hh"
#include "translator-group.hh"

/**
  There is no real processing to a property: just lookup the
  translation unit, and set the property.
  */
void
Property_iterator::process (Moment m)
{
  SCM sym = music_l_->get_mus_property ("symbol");
  if (gh_symbol_p(sym))
    report_to_l ()->set_property (sym, music_l_->get_mus_property ("value"));
  Simple_music_iterator::process (m);
}

void
Push_property_iterator::process (Moment m)
{
  SCM syms = music_l_->get_mus_property ("symbols");
  SCM eprop = music_l_->get_mus_property ("element-property");
  SCM val = music_l_->get_mus_property ("element-value");

  Translator_def::apply_pushpop_property (report_to_l (), syms, eprop, val);
  
  Simple_music_iterator::process (m);
}

void
Pop_property_iterator::process (Moment m)
{
  SCM syms = music_l_->get_mus_property ("symbols");
  SCM eprop = music_l_->get_mus_property ("element-property");
  Translator_def::apply_pushpop_property (report_to_l (), syms, eprop, SCM_UNDEFINED);
  
  Simple_music_iterator::process (m);
}
