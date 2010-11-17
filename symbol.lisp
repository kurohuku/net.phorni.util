;;;; symbol.lisp
(in-package :net.phorni.util)

(defun symb (&rest args)
  (values (intern (format nil "~{~A~}" args))))

(defun make-keyword (&rest args)
  (values (intern (format nil "~{~A~}" args) :keyword)))

(defun collect-symbol (test lst)
  (loop :for sym :in (remove-duplicates (flatten lst))
     :when (and (symbolp sym) (funcall test sym))
     :collect sym))

(defmacro with-gensyms (gsyms &body body)
  `(let ,(mapcar
	  #'(lambda (s) `(,s (gensym)))
	  gsyms)
     ,@body))