;;;; sequence.lisp

(in-package :net.phorni.util)

(defmacro doseq (binds &body body)
  `(progn
     (loop :for ,(first binds) :across ,(second binds)
	:do
	,@body)
     ,(third binds)))