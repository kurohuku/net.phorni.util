;;;; hashtable.lisp
(in-package :net.phorni.util)

(defmacro with-ht-values (binds hash-table &body body)
  (let ((ht (gensym "alist")))
    (flet ((expand-bind (bind)
	     `(,(first bind)
		(gethash ,(second bind) ,ht))))
      `(let ((,ht ,hash-table))
	 (let ,(mapcar #'expand-bind binds)
	   ,@body)))))