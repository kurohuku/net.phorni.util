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

(defmacro cut (fn &rest args)
  (let ((cut-fn-args-count
	 (count (intern "<>") args))
	(rest-arg?
	 (find (intern "<...>") args)))
    (let ((gsyms (make-gensyms cut-fn-args-count))
	  (rest-gsym (if rest-arg? (gensym) nil)))
      (let ((inner-args
	     (loop
		:with grest = gsyms
		:for s in args
		:do (when (eq (intern "<>") s)
		      (setf s (car grest)
			    grest (cdr grest)))
		:unless (eq s (intern "<...>"))
		:collect s)))
      `(lambda ,(append gsyms (and rest-gsym (list 'cl:&rest rest-gsym)))
	 (apply ,fn ,@inner-args ,rest-gsym))))))

