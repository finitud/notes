;;;; notes.lisp

(in-package #:notes)

(defvar *posts* (make-array 0 :fill-pointer 0 :adjustable t)
  "This vector holds all the posts we have.
This is a rudimentary way of handling persistance and should work for a bit
(until we set up a proper database, that is)")

;;;
;;; Utilities to print posts
;;;

(defmacro cat (varstr what)
  "Append the result of evaluating WHAT into VARSTR (destructive, expecting strings)"
  `(setf ,varstr (concatenate 'string ,varstr ,what)))

(defun print-single-post (item)
  (yaclml:with-yaclml-output-to-string
    (if (>= item (fill-pointer *posts*))
	(<:h2 (format nil "Post #~a does not exist" item))
	(<:div :class "post"
	       (<:h2 (<:format "~a" item))
	       (<:p (<:format "~a" (elt *posts* item)))))))

(defun print-all-posts ()
  (loop with output = ""
     for i from 0 to (- (fill-pointer *posts*) 1)
     do (cat output (print-single-post i))
     finally (return output)))

;;;
;;; ROUTES
;;;

(define-route home ("/" :content-type "text/html")
  (format nil "Hola mundo"))

(define-route single-post ("post/:item"
			   :content-type "text/html"
			   :parse-vars (list :item #'parse-integer))
  (yaclml:with-yaclml-output-to-string
    (<:html (<:head (<:title (<:format "Post ~a" item)))
	    (<:body (<:as-is (print-single-post item))))))

(define-route all-posts ("posts" :content-type "text/html")
  (yaclml:with-yaclml-output-to-string
    (<:html (<:head (<:title "All posts"))
	    (<:body (<:h1 "All posts")
		    (<:as-is (print-all-posts))))))

(define-route create-post-get ("create/:text" :method :get :content-type "text/html")
  (vector-push-extend text *posts*)
  (redirect 'single-post :item (- (fill-pointer *posts*) 1)))

(define-route create-post ("post" :method :get)
  (yaclml:with-yaclml-output-to-string
    (<:html (<:head (<:title "New post"))
	    (<:body (<:h1 "New post")
		    (<:form :method :post
			    (<:label :for "text" "Post something:")(<:br)
			    (<:textarea :name "text" :cols "80" :rows "10")(<:br)
			    (<:input :type :submit :value "Post!"))))))

(define-route new-post ("post" :method :post)
  (vector-push-extend (hunchentoot:post-parameter "text") *posts*)
  (redirect 'all-posts))

;;;
;;; START THE SERVLET
;;;

(start '#:notes :port 4242)
