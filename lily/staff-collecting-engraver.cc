/*   
staff-collecting-engraver.cc --  implement Staff_collecting_engraver

source file of the GNU LilyPond music typesetter

(c) 2001--2004  Han-Wen Nienhuys <hanwen@cs.uu.nl>

 */
#include "staff-symbol.hh"
#include "engraver.hh"
#include "grob.hh"
#include "context.hh"


class Staff_collecting_engraver : public Engraver
{
public:
  TRANSLATOR_DECLARATIONS (Staff_collecting_engraver);
  virtual void acknowledge_grob (Grob_info);
};

Staff_collecting_engraver::Staff_collecting_engraver ()
{
  
}

void
Staff_collecting_engraver::acknowledge_grob (Grob_info gi)
{
  if (Staff_symbol::has_interface (gi.grob_))
    {
      SCM staffs = get_property ("stavesFound");
      staffs = gh_cons (gi.grob_->self_scm (), staffs);

      daddy_context_->set_property ("stavesFound", staffs);
    }
}


ENTER_DESCRIPTION (Staff_collecting_engraver,
/* descr */       "Maintain the stavesFound variable",

/* creats*/       "",
/* accepts */     "",
/* acks  */      "staff-symbol-interface",
/* reads */       "stavesFound",
/* write */       "stavesFound");
