;;;
;;; ROUTES
;;;

(in-package #:notes)

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
		    (<:as-is (new-post-form))
		    (<:as-is (print-all-posts))))))

(define-route all-posts/post ("posts" :method :post)
  (add-post (hunchentoot:post-parameter "text"))
  (redirect 'all-posts))
