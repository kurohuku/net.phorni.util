;;;; short-lambda-reader.lisp
(in-package :net.phorni.util)

;;; lambdaの省略記法の定義
;; example
;; [list 1 2] => (lambda () (list 1 2))
;; [list $2 3] => (lambda ($1 $2) (list $2 3))
;; [list $1 $r] => (lambda ($1 &rest $r) (list $1 $r))
;; TODO : $1 - $r をそのまま使わずgensymでシンボルを作るべきか
(defun dollar-symbol-p (sym)
  (and (symbolp sym) (char= #\$ (char (symbol-name sym) 0))))

(defun dollar-symbol-index (sym)
  (and (dollar-symbol-p sym)
       (parse-integer
	(symbol-name sym)
	:start 1 :junk-allowed t)))

(defun short-lambda-reader (stream ch)
  (declare (ignore ch1))
  (let* ((body (read-delimited-list #\] stream t))
	 (dollars (remove-if-not #'dollar-symbol-p (flatten body)))
	 (rest-p (find "$R" dollars :test #'string= :key #'symbol-name))
	 (largest
	  (apply #'max (or (remove nil (mapcar #'dollar-symbol-index dollars))
			   '(0)))))
    (let ((args (loop :for i from 1 to largest
		   :collect (symb "$" i))))
      `(lambda ,(if rest-p
		    `(,@args &rest ,rest-p)
		    `(,@args))
	 ,body))))

(defun enable-lambda-reader ()
  (set-macro-character #\] (get-macro-character #\)))
  (set-macro-character #\[ #'short-lambda-reader))

(defmacro disable-lambda-reader ()
  (set-macro-character #\] nil)
  (set-dispatch-macro-character #\[ nil))