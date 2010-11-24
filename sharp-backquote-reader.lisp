(asdf:oos 'asdf:load-op :kmrcl)

(defun |#`-reader| (stream ch numarg)
  (declare (ignore ch numarg))
  (let (acc-fmt acc-args)
    (loop
       :for curr = (read-char stream)
       :until (char= curr #\`)
       :do
       (if (char= curr #\\)
	   (let ((c (read-char stream)))
	     (case c
	       ((#\n) (push #\Newline acc-fmt))
	       ((#\t) (push #\Tab acc-fmt))
	       ((#\{) (push #\{ acc-fmt))
	       ((#\`) (push #\` acc-fmt))
	       (T (error "#`-reader invalid escaped character"))))
	   (if (char= curr #\{)
	       (let ((s (read-delimited-list #\} stream)))
		 (push (car s) acc-args)
		 (push #\~ acc-fmt)
		 (push #\A acc-fmt))
	       (push curr acc-fmt))))
    `(kmrcl:command-output
      ,(coerce (nreverse acc-fmt) 'string)
      ,@(nreverse acc-args))))
    
(defun enable-sharp-backquote-reader ()
  (set-macro-character
   #\}
   (get-macro-character #\)))
  (set-dispatch-macro-character
   #\# #\`
   #'|#`-reader|))
   

;;; example
;;' #`ls -a {a}.lisp`
;;> (KMRCL:COMMAND-OUTPUT "ls -a ~A.lisp" A)
;;' #`ls -a {a b}.lisp`
;;> (KMRCL:COMMAND-OUTPUT "ls -a ~A.lisp" A)
