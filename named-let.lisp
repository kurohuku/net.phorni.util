;;;; named-let.lisp
(in-package :net.phorni.util)

(defmacro named-let (name binds &body body)
  `(labels
       ((,name ,(mapcar #'car binds)
	  ,@body))
     (,name ,@(mapcar #'second binds))))