// the breaking problem for a score.

#ifndef PSCORE_HH
#define PSCORE_HH

#include "break.hh"
#include "vray.hh"
#include "pcol.hh"
#include "pstaff.hh"

/// all stuff which goes onto paper
struct PScore {
    Paperdef *paper_;		// indirection.
    
    /// the columns, ordered left to right
    IPointerList<PCol *> cols;

    /// the idealspacings, no particular order
    IPointerList<Idealspacing*> suz;

    /// the staffs ordered top to bottom
    IPointerList<PStaff*> staffs;

    /// all symbols in score. No particular order.
    IPointerList<Item*> its;

    /// if broken, the different lines
    IPointerList<Line_of_score*> lines;

    /// crescs etc; no particular order
    IPointerList<Spanner *> spanners;

    /// broken spanners
    IPointerList<Spanner*> broken_spans;

    /****************/

    void add_broken(Spanner*);
    
    svec<Item*> select_items(PStaff*, PCol*);

    /// before calc_breaking
    void preprocess();
    
    void calc_breaking();
    /**
      calculate where the lines are to be broken.

      POST
    
      lines contain the broken lines.
     */

    /// after calc_breaking
    void postprocess();
    
    /// add a line to the broken stuff. Positions given in #config#
    void set_breaking(svec< Col_configuration> );

    void add(PStaff *);
    
    /// add item
    void typeset_item(Item *,  PCol *,PStaff*,int=1);

    /// add an Spanner
    void typeset_spanner(Spanner*, PStaff*);
 
    ///    add to bottom of pcols
    void add(PCol*);
    /**

    */
    void output(Tex_stream &ts);

    Idealspacing* get_spacing(PCol *, PCol *);
    /*
    get the spacing between c1 and c2, create one if necessary.
    */

    /// return argument as a cursor.
    PCursor<PCol *> find_col(PCol *)const;

    /// delete unused columns
    void clean_cols();

    /// invarinants
    void OK()const;

    PScore(Paperdef*);
    void print() const;

        /// which is first (left, higher)
    int compare_pcols( PCol*, PCol*)const;
};
/** notes, signs, symbols in a score can be grouped in two ways:
    horizontally (staffwise), and vertically (columns). #PScore#
    contains the items, the columns and the staffs.
 */
#endif
