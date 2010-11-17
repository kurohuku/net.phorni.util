;;;; shorthand.lisp
(in-package :net.phorni.util)

(defmacro -> (exp &rest rest)
  (if rest
      (let ((fst (car rest))
            (rest (cdr rest)))
        (typecase fst
          (symbol `(-> (,fst ,exp) ,@rest))
          (atom `(-> (,fst ,exp) ,@rest))
          (list `(-> (,(car fst) ,exp ,@(cdr fst)) ,@rest))))
      exp))

(defmacro ->> (exp &rest rest)
  (if rest
      (let ((fst (car rest))
            (rest (cdr rest)))
        (typecase fst
          (symbol `(->> (,fst ,exp) ,@rest))
          (atom `(->> (,fst ,exp) ,@rest))
          (list `(->> (,(car fst) ,@(cdr fst) ,exp) ,@rest))))
      exp))
