;;;; with-default-values.lisp
(in-package :net.phorni.util)

(defmacro with-default-values (binds &body body)
  "letとほぼ同じ動作をしますが、varシンボルがすでにnil以外の値に
束縛されている場合、その値を利用します。"
  (labels ((expand-bind (bind)
	     `(,(first bind)
		;; 'boundp' ignores any lexical environment.
		(restart-case
		    (handler-bind ((unbound-variable
				    #'(lambda (c)
					(declare (ignore c))
					(invoke-restart 'my-restart))))
		      (if ,(first bind) ,(first bind) ,(second bind)))
		  (my-restart () ,(second bind))))))
    `(let ,(mapcar #'expand-bind binds)
       ,@body)))

(defmacro with-default-values* (binds &body body)
  "with-default-valuesとほぼ同じですが、こちらはletではなく
let*に展開されます。"
  (labels ((expand-bind (bind)
	     `(,(first bind)
		;; 'boundp' ignores any lexical environment.
		(restart-case
		    (handler-bind ((unbound-variable
				    #'(lambda (c)
					(declare (ignore c))
					(invoke-restart 'my-restart))))
		      (if ,(first bind) ,(first bind) ,(second bind)))
		  (my-restart () ,(second bind))))))
    `(let* ,(mapcar #'expand-bind binds)
       ,@body)))