;;;; list.lisp
(in-package :net.phorni.util)

(defun mklist (obj)
  (if (listp obj) obj (list obj)))

;;SRFI-1 iota (base (1+ base) ... (+ base (1- n)))
(defun iota (n &optional (base 0))
  (loop :repeat n
     :for i from base :collect i))

;; (from (1+ from) ... (1- to) to)
(defun enumrate (from to)
  (loop :for i from from to to :collect i))

(defun flatten (x)
  (labels ((rec (x acc)
	     (cond ((null x) acc)
		   ((atom x) (cons x acc))
		   (T (rec (car x) (rec (cdr x) acc))))))
    (rec x nil)))

(defun group (lst n)
  (when (<= n 0) (error "Invalid number 'n'"))
  (labels ((rec (lst acc)
	     (let ((rest (nthcdr n lst)))
	       (if (consp rest)
		   (rec rest (cons (subseq lst 0 n) acc))
		   (nreverse (cons lst acc))))))
    (if lst (rec lst nil) nil)))

(defun mapcar-1 (fn fst &rest lsts)
  (apply
   #'mapcar
   #'(lambda (&rest args)
       (apply fn fst args))
   lsts))

(defmacro with-assoc-values (binds alist &body body)
  (let ((al (gensym "alist")))
    (flet ((expand-bind (bind)
	     `(,(first bind)
		(cdr (assoc ,(second bind) ,al)))))
      `(let ((,al ,alist))
	 (let ,(mapcar #'expand-bind binds)
	   ,@body)))))