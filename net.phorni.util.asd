;;; -*- Mode: LISP; Syntax: COMMON-LISP; -*-

(asdf:defsystem #:net.phonrni.util
  :version "0.0.1"
  :components ((:file "packages")
;;	       (:file "sharp-backquote-reader" :depends-on ("packages"))
	       (:file "anaphora" :depends-on ("packages"))
	       (:file "control" :depends-on ("packages"))
	       (:file "function" :depends-on ("packages"))
	       (:file "hashtable" :depends-on ("packages"))
	       (:file "list" :depends-on ("packages"))
	       (:file "named-let" :depends-on ("packages"))
	       (:file "short-ht-reader" :depends-on ("packages"))
	       (:file "short-lambda-reader" :depends-on ("packages" "list" "symbol"))q
	       (:file "shorthand" :depends-on ("packages"))
	       (:file "string" :depends-on ("packages"))
	       (:file "symbol" :depends-on ("packages"))
	       (:file "test-tool" :depends-on ("packages"))
	       (:file "with-collects" :depends-on ("packages"))
	       (:file "with-default-values" :depends-on ("packages"))))
