;;;; function.lisp
(in-package :net.phorni.util)

;;(compose a b) => (a (b args))
(defun compose (&rest fns)
  (if fns
      (let ((fn (car (last fns)))
	    (fn-rest (butlast fns)))
	#'(lambda (&rest args)
	    (reduce #'funcall fn-rest
		    :from-end t
		    :initial-value (apply fn args))))
      #'identity))

;;(chain a b) => (b (a args))
(defun chain (&rest fns)
  (let ((fns (reverse fns)))
    (apply #'compose fns)))