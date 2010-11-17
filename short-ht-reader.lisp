;;;; short-ht-reader.lisp

(in-package :net.phorni.util)

(let ((old-start (get-dispatch-macro-character #\# #\{))
      (old-end (get-macro-character #\}))
      (enable? nil))
  (defun enable-ht-reader ()
    (unless enable?
      (setf enable? T)
      (setf old-start (get-dispatch-macro-character #\# #\{))
      (setf old-end (get-macro-character #\}))
      (set-macro-character
       #\}
       (get-macro-character #\)))
      (set-dispatch-macro-character
       #\# #\{
       #'(lambda (s ch n)
	   (declare (ignore ch))
	   (let ((elems (read-delimited-list #\} s t))
		 (ht (if n
			 (make-hash-table :test #'equal :size n)
			 (make-hash-table :test #'equal))))
	     (loop :for rest = elems then (cddr rest)
		:for k = (first rest)
		:for v = (second rest)
		:while (and rest (cdr rest))
		:do (setf (gethash k ht) v))
	     ht)))))
  (defun disable-ht-reader ()
    (when enable?
      (setf enable? nil)
      (set-dispatch-macro-character #\# #\{ old-start)
      (set-macro-character #\} old-end))))