;;;; notes.lisp

(in-package #:notes)

(defvar *posts* (make-array 0 :fill-pointer 0 :adjustable t)
  "This vector holds all the posts we have.
This is a rudimentary way of handling persistance and should work for a bit
(until we set up a proper database, that is)")

(load "post")
(load "util")
(load "routes")

;;;
;;; START THE SERVLET
;;;

(start '#:notes :port 4242)
