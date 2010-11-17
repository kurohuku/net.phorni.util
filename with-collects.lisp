;;;; with-collects.lisp
(in-package :net.phorni.util)

(defmacro with-collects ((&rest syms) &body body)
  (labels
      ((collector-expander (sym gtail)
	 `(,sym (arg)
		(if (null ,sym)
		    (progn
		      (setf ,sym (cons arg nil))
		      (setf ,gtail ,sym)
		      arg)
		    (let ((last (cons arg nil)))
		      (setf (cdr ,gtail) last
			    ,gtail last)
		      arg)))))
    (let ((gtails (mapcar #'(lambda (s) (gensym "WITH-COLLECTS-TAIL")) syms)))
      `(let ,syms
	 (labels
	     (,@(mapcar #'collector-expander syms gtails))
	   ,@body)))))