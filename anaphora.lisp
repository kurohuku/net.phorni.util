;;;; anaphora.lisp
(in-package :net.phorni.util)

(defmacro aif (test then &optional else)
  `(let ((it ,test))
     (if it ,then ,else)))

(defmacro awhen (test &rest body)
  `(let ((it ,test))
     (when it ,@body)))

(defmacro aunless (test &rest body)
  `(let ((it ,test))
     (unless it
       ,@body)))

(defmacro awhile (test &rest body)
  `(loop
      :for it = ,test then ,test
      :until it
      :do ,@body))