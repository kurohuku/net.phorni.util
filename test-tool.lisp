
(in-package :net.phorni.util)

(defvar *test-function-table* (make-hash-table))

;; clause -> ((arg1 arg2 ... ) result) = ((arg1 arg2 ... ) :eq result)
;; clause -> ((arg1 arg2 ... ) :not result)
;; clause -> ((arg1 arg2 ... ) :test test-fn)
(defparameter *test-report-function*
  #'(lambda (fn-name args expected actual)
      (format t "TEST FAILED. Form: (~A ~{~A~^ ~}), Expected: ~A, Actual: ~A~%"
	      fn-name args expected actual)))

(defmacro deftest (fn-name &body clauses)
  (let ((sym (gensym)))
    (labels
	((expander (clause)
	   (let ((result-spec (cdr clause))
		 (test-fn-form `(,fn-name ,@(car clause))))
	     (when (= (length result-spec) 1)
	       (setf result-spec (cons :eq result-spec)))
	     `(let ((,sym ,test-fn-form))
		,(let ((report-form `(funcall *test-report-function*
					      ',fn-name
					      ',(car clause)
					      ',result-spec
					      ,sym)))
		      (case (car result-spec)
			((:eq)
			 `(unless (eq ,sym ,(second result-spec))
			    ,report-form))
			((:eql)
			 `(unless (eql ,sym ,(second result-spec))
			    ,report-form))
			((:equal)
			 `(unless (equal ,sym ,(second result-spec))
			    ,report-form))
			((:not :not-eq)
			 `(when (eq ,sym ,(second result-spec))
			    ,report-form))
			((:not-eql)
			 `(when (eql ,sym ,(second result-spec))
			    ,report-form))
			((:not-equql)
			 `(when (equal ,sym ,(second result-spec))
			    ,report-form))
			((:test)
			 `(unless (funcall ,(second result-spec) ,sym)
			    ,report-form))
			(T (error "invalid test result keyword"))))))))
      `(setf (gethash ',fn-name *test-function-table*)
	     (lambda ()
	       ,@(mapcar #'expander clauses))))))

(defun run-test (fn-name)
  (multiple-value-bind (test-fn ?) (gethash fn-name *test-function-table*)
    (when ?
      (funcall test-fn))))

(defun run-test-all ()
  (maphash
   #'(lambda (key val)
       (when (functionp val)
	 (format t "TEST START : ~A~%" key)
	 (funcall val)))
   *test-function-table*))



