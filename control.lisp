;;;; control.lisp
(in-package :net.phorni.util)

(defmacro while (test &body body)
  `(loop
      :until ,test
      :do ,@body))

(defmacro until (test &body body)
  `(loop
      :while ,test
      :do ,@body))

(defmacro cond-1 (val &rest clauses)
  (let ((sym (gensym)))
    `(let ((,sym ,val))
       (cond
	 ,@(mapcar
	    #'(lambda (clause)
		`(,(if (or (eq T (car clause))
			   (eq otherwise (car clause)))
		       T
		       `(funcall ,(car clause) ,sym))
		   ,@(cdr clause)))
	    clauses)))))