;;;; string.lisp
(in-package :net.phorni.util)

(defun mkstr (&rest args)
  (with-output-to-string (s)
    (dolist (a args)
      (princ a s))))
  
(defun split-string (str seps)
  (let ((len (length str)))
    (labels
	((recur (curr last acc)
	   (if (= len curr)
	       (nreverse (if (= curr last)
			     acc
			     (cons (subseq str last curr) acc)))
	       (if (find (char str cur) seps)
		   (if (= curr last)
		       (recur (1+ curr) curr acc)
		       (recur (1+ curr) curr
			      (cons (subseq str last curr) acc)))))))
      (recur 0 0 nil))))