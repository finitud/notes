;;;
;;; ROUTES
;;;

(in-package #:notes)

(define-route home ("")
  (redirect 'all-posts))

(define-route single-post ("post/:item" :parse-vars (list :item #'parse-integer))
  (yaclml:with-yaclml-output-to-string
    (<:html (<:head (<:title (<:format "Post ~a" item)))
	    (<:body (<:as-is (print-single-post item))))))

(define-route all-posts ("posts" :method :get)
  (yaclml:with-yaclml-output-to-string
    (<:html (<:head (<:title "All posts"))
	    (<:body (<:h1 "All posts")
		    (<:as-is (new-post-form))
		    (<:as-is (print-all-posts))))))

(define-route all-posts/post ("posts" :method :post)
  (add-post (hunchentoot:post-parameter "text"))
  (redirect 'all-posts))
