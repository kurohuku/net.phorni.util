;;;; generic.lisp

(in-package :net.phorni.util)

(defun defmethods-args-expander (args specifiers)
  (when (< (length args) (length specifiers))
    (error "Too many specifiers"))
  (labels
      ((inner (ar sr acc)
	 (if (null ar)
	     (nreverse acc)
	     (inner (cdr ar)
		    (cdr sr)
		    (cons
		     (if (null sr)
			 (car ar)
			 (list (car ar) (car sr)))
		     acc)))))
    (inner args specifiers nil)))

(defun defmethods-clause-expander (name args clause)
  (destructuring-bind (specifiers &rest definition)
      clause
    (unless (listp specifiers)
      (setf specifiers (list specifiers)))
    `(defmethod ,name
	 ,(defmethods-args-expander args specifiers)
       ,@definition)))

(defmacro defmethods (name (&rest args) &body clauses)
  (when (null args)
    (error "There is no argument"))
  `(progn
     ,@(mapcar
	#'(lambda (clause)
	    (defmethods-clause-expander name args clause))
	clauses)))