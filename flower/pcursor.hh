
/*
  pcursor.hh -- part of flowerlib

  (c) 1996 Han-Wen Nienhuys&Jan Nieuwenhuizen
*/

#ifndef PCURSOR_HH
#define PCURSOR_HH


/// cursor to go with PointerList
template<class T>
struct PCursor : private Cursor<void *> {
    friend class IPointerList<T>;

    /// delete contents
    void junk();
public:
    Cursor<void*>::ok;
    Cursor<void*>::del;
    Cursor<void*>::backspace;
    T get() {
	T p = ptr();
	Cursor<void*>::del();
	return p;
    }
    T get_prev() {
	(*this)--;
	return get();
    }
    
    PointerList<T> &list() { return (PointerList<T>&)Cursor<void*>::list(); }
    PCursor<T> operator++(int) { return Cursor<void*>::operator++(0);}
    PCursor<T> operator--(int) { return Cursor<void*>::operator--(0); }
    PCursor<T> operator+=(int i) { return Cursor<void*>::operator+=(i);}
    PCursor<T> operator-=(int i) { return Cursor<void*>::operator-=(i); }    
    PCursor<T> operator -(int no) const { return Cursor<void*>::operator-(no);}
    int operator -(PCursor<T> op) const { return Cursor<void*>::operator-(op);}
    PCursor<T> operator +( int no) const {return Cursor<void*>::operator+(no);}    PCursor(const PointerList<T> & l) : Cursor<void*> (l) {}

    PCursor( const Cursor<void*>& cursor ) : Cursor<void*>(cursor) { }
    void* vptr() const { return  * ((Cursor<void*> &) *this); }

    // should return T& ?
    T ptr() const { return (T) vptr(); }
    T operator ->() const { return  ptr(); }
    operator T() { return ptr(); }
    T operator *() { return ptr(); }
    void add(const T& p ) { Cursor<void*>::add((void*) p); }
    void insert(const T& p ) { Cursor<void*>::insert((void*) p);}    
    static int compare(PCursor<T> a,PCursor<T>b) {
	return Cursor<void*>::compare(a,b);
    }
};
/**
  don't create PointerList<void*>'s.
  This cursor is just an interface class for Cursor. It takes care of the
  appropriate type casts
 */



#include "compare.hh"
template_instantiate_compare(PCursor<T>, PCursor<T>::compare, template<class T>);

#endif
