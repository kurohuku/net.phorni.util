;;;; packages.lisp

(defpackage net.phorni.util
  (:use :cl)
  (:nicknames :util)
  (:export
   ;; anaphora
   aif
   awhen
   aunless
   awhile
   ;; control
   while
   until
   cond-1
   case+
   ;; function
   compose
   chain
   cut
   ;; generic
   defmethods
   ;; hashtable
   with-ht-values
   ;; list
   mklist
   iota
   enumrate
   flatten
   group
   mapcar-1
   with-assoc-values
   ;; named-let
   named-let
   ;; sequence
   doseq
   ;; short-ht-reader
   enable-ht-reader
   disable-ht-reader
   ;; short-lambda-reader
   enable-lambda-reader
   disable-lambda-reader
   ;; shorthand
   ->
   ->>
   ;; string
   mkstr
   split-string
   ;; symbol
   symb
   make-keyword
   collect-symbol
   with-gensyms
   make-gensyms
   ;; with-collects
   with-collects
   ;; with-default-values
   with-default-values))