/*   
  plet-engraver.cc --  implement Tuplet_engraver
  
  source file of the GNU LilyPond music typesetter
  
  (c) 1998--2001 Han-Wen Nienhuys <hanwen@cs.uu.nl>
  
 */


#include "command-request.hh"
#include "tuplet-spanner.hh"
#include "note-column.hh"
#include "time-scaled-music.hh"
#include "beam.hh"
#include "music-list.hh"
#include "engraver.hh"
#include "spanner.hh"

class Tuplet_engraver : public Engraver
{
public:
  VIRTUAL_COPY_CONS (Translator);

protected:
  Link_array<Time_scaled_music> time_scaled_music_arr_;
  /// when does the scaled music stop? Array order is synced with time_scaled_music_arr_
  Array<Moment> stop_moments_;
  /// when does the current spanner stop? Array order is synced with time_scaled_music_arr_
  Array<Moment> span_stop_moments_;
  
  /// The spanners. Array order is synced with time_scaled_music_arr_
  Link_array<Spanner> started_span_p_arr_;

  virtual void finalize ();
  virtual void acknowledge_grob (Grob_info);
  virtual bool try_music (Music*r);
  virtual void start_translation_timestep ();
  virtual void create_grobs ();
};

bool
Tuplet_engraver::try_music (Music *r)
{
  if (Time_scaled_music * c = dynamic_cast<Time_scaled_music *> (r))
    {
      Music *el = c->element ();
      if (!dynamic_cast<Request_chord*> (el))
	{
	  time_scaled_music_arr_.push (c);
	  Moment m = now_mom () + c->length_mom ();
	  stop_moments_.push (m);

	  SCM s = get_property ("tupletSpannerDuration");
	  if (unsmob_moment (s))
	    m = m <? (now_mom () + *unsmob_moment (s));
	  
	  span_stop_moments_.push (m);
	}
      return true;
    }
  return false;
}

void
Tuplet_engraver::create_grobs ()
{
  SCM v = get_property ("tupletInvisible");
  if (to_boolean (v))
    return;

  for (int i= 0; i < time_scaled_music_arr_.size (); i++)
    {
      if (i < started_span_p_arr_.size () && started_span_p_arr_[i])
	continue;

      Spanner* glep = new Spanner (get_property ("TupletBracket"));
      Tuplet_bracket::set_interface (glep);
      if (i >= started_span_p_arr_.size ())
	started_span_p_arr_.push (glep);
      else
	started_span_p_arr_[i] = glep;
      

      SCM proc = get_property ("tupletNumberFormatFunction");
      if (gh_procedure_p (proc))
	{
	  SCM t = gh_apply (proc, gh_list (time_scaled_music_arr_[i]->self_scm (), SCM_UNDEFINED));
	  glep->set_grob_property ("text", t);
	}
      
      announce_grob (glep, time_scaled_music_arr_ [i]);
    }
}

void
Tuplet_engraver::acknowledge_grob (Grob_info i)
{
  bool grace= to_boolean (i.elem_l_->get_grob_property ("grace"));
  SCM wg = get_property ("weAreGraceContext");
  bool wgb = to_boolean (wg);
  if (grace != wgb)
    return;
  
  if (Note_column::has_interface (i.elem_l_))
    {
      for (int j =0; j  <started_span_p_arr_.size (); j++)
	if (started_span_p_arr_[j]) 
	  Tuplet_bracket::add_column (started_span_p_arr_[j], dynamic_cast<Item*> (i.elem_l_));
    }
  else if (Beam::has_interface (i.elem_l_))
    {
      /*
	TODO:
	
	ugh, superfluous. Should look at

	tuplet -> note-column -> stem -> beam

	to find the beam(s) of a tuplet
       */
      
      for (int j = 0; j < started_span_p_arr_.size (); j++)
	if (started_span_p_arr_[j]) 
	  Tuplet_bracket::add_beam (started_span_p_arr_[j],i.elem_l_);
    }
}

void
Tuplet_engraver::start_translation_timestep ()
{
  Moment now = now_mom ();

  Moment tsd;
  SCM s = get_property ("tupletSpannerDuration");
  if (unsmob_moment (s))
    tsd = *unsmob_moment (s);

  for (int i= started_span_p_arr_.size (); i--;)
    {
      if (now >= span_stop_moments_[i])
	{
	  if (started_span_p_arr_[i])
	    {
	      typeset_grob (started_span_p_arr_[i]);
	      started_span_p_arr_[i] =0;
	    }
	  
	  if (tsd)
	    span_stop_moments_[i] += tsd;
	}

      if (now >= stop_moments_[i])
	{
	  started_span_p_arr_.del (i);
	  stop_moments_.del (i);
	  span_stop_moments_.del (i);
	  time_scaled_music_arr_.del (i);
	}
    }
}

void
Tuplet_engraver::finalize ()
{
  for (int i=0; i < started_span_p_arr_.size (); i++)
    {
      if (started_span_p_arr_[i])
	typeset_grob (started_span_p_arr_[i]);
    }  
}

ADD_THIS_TRANSLATOR (Tuplet_engraver);


