;;;; notes.asd

(asdf:defsystem #:notes
  :serial t
  :description "Public anon notes board"
  :author "Ruben Garcia Martin <ruben@finitud.org>"
  :license "MIT"
  :depends-on (#:restas
	       #:yaclml)
  :components ((:file "package")
	       (:file "post")
	       (:file "util")
               (:file "notes")))

