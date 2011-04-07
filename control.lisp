;;;; control.lisp
(in-package :net.phorni.util)

(defmacro while (test &body body)
  `(loop
      :while ,test
      :do ,@body))

(defmacro until (test &body body)
  `(loop
      :until ,test
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

(defmacro case+ (form test &body clauses)
    (let ((gtest (gensym))
	  (gform (gensym)))
          (labels
	      ((clause->or (clause)
		 (if (listp (car clause))
		     `((or
			,@(mapcar
			   #'(lambda (x)
			       `(funcall ,gtest ,gform ,x))
			   (car clause)))
		       ,@(cdr clause))
		     (cond
		       ((eq (car clause) cl:T)
			`(cl:T ,@(cdr clause)))
		       ((and (symbolp (car clause))
			     (string-equal (symbol-name (car clause)) "otherwise"))
			`(cl:T ,@(cdr clause)))
		       (T `((funcall ,gtest ,gform ,(car clause))
			    ,@(cdr clause)))))))
	          `(let ((,gform ,form)
			 (,gtest ,test))
		     (cond
		       ,@(mapcar #'clause->or clauses))))))
