/*
  extender-engraver.cc -- implement Extender_engraver

  (c) 1999 Glen Prideaux <glenprideaux@iname.com>,
  Han-Wen Nienhuys, Jan Nieuwenhuizen.
  
*/

#include "proto.hh"
#include "musical-request.hh"
#include "extender-spanner.hh"
#include "paper-column.hh"
#include "text-item.hh"
#include "engraver.hh"
#include "drul-array.hh"
#include "extender-spanner.hh"
#include "pqueue.hh"


/**
  Generate an centred extender.  Should make a Extender_spanner that
  typesets a nice centred extender of varying length depending on the
  gap between syllables.

  We remember the last Text_item that come across. When we get a
  request, we create the spanner, and attach the left point to the
  last lyrics, and the right point to any lyrics we receive by
  then.  */
class Extender_engraver : public Engraver
{
  Text_item *  last_lyric_l_;
  Text_item * current_lyric_l_;
  Extender_req* req_l_;
  Lyric_extender* extender_spanner_p_;
public:
  Extender_engraver ();
  VIRTUAL_COPY_CONS (Translator);

protected:
  virtual void acknowledge_element (Score_element_info);
  virtual void do_removal_processing();
  virtual void do_process_music();
  virtual bool do_try_music (Music*);
  virtual void do_pre_move_processing();
  virtual void do_post_move_processing ();
private:

};


ADD_THIS_TRANSLATOR (Extender_engraver);

Extender_engraver::Extender_engraver ()
{
  current_lyric_l_ = 0;
  last_lyric_l_ = 0;
  extender_spanner_p_ = 0;
  req_l_ = 0;
}

void
Extender_engraver::acknowledge_element (Score_element_info i)
{
  if (Text_item* t = dynamic_cast<Text_item*> (i.elem_l_))
    {
      current_lyric_l_ = t;
      if (extender_spanner_p_
	  && !extender_spanner_p_->get_bound (RIGHT)
	    )
	  {
	    extender_spanner_p_->set_textitem (RIGHT, t);
	  }
    }
}


bool
Extender_engraver::do_try_music (Music* r)
{
  if (Extender_req* p = dynamic_cast <Extender_req *> (r))
    {
      if (req_l_)
	return false;

      req_l_ = p;
      return true;
    }
  return false;
}

void
Extender_engraver::do_removal_processing ()
{
  if (extender_spanner_p_)
    {
      req_l_->warning (_ ("unterminated extender"));
      extender_spanner_p_->set_bound(RIGHT, get_staff_info ().command_pcol_l ());
    }
}

void
Extender_engraver::do_process_music ()
{
  if (req_l_)
    {
      if (!last_lyric_l_)
	{
	  req_l_->warning (_ ("Nothing to connect extender to on the left.  Ignoring extender request."));
	  return;
	}
      
      extender_spanner_p_ = new Lyric_extender (get_property ("basicLyricExtenderProperties"));
      extender_spanner_p_->set_textitem  (LEFT, last_lyric_l_);
      announce_element (Score_element_info (extender_spanner_p_, req_l_));
    }
}


void
Extender_engraver::do_pre_move_processing ()
{
  if (extender_spanner_p_)
    {
      typeset_element (extender_spanner_p_);
      extender_spanner_p_ = 0;
    }

  if (current_lyric_l_)
    {
      last_lyric_l_ = current_lyric_l_;
      current_lyric_l_ =0;
    }
}

void
Extender_engraver::do_post_move_processing ()
{
  req_l_ = 0;
}


