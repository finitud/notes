;;
;; POST class to store posts
;;

(in-package #:notes)

(defclass post ()
  ((text :accessor post-text
	 :initform ""
	 :initarg :text)
   (id :accessor post-id
       :initarg :id)
   (timestamp :accessor post-timestamp
	      :initform (get-universal-time)
	      :initarg :timestamp)))

(defgeneric print-post (post))

(defmethod print-post ((post post))
  (yaclml:with-yaclml-output-to-string
    (<:div :class "post"
	   (<:h3 (<:format "#~a" (post-id post)))
	   (<:p (<:format "~a" (post-text post)))
	   (<:h6 (<:format "Posted on ~a" (format-date (post-timestamp post)))))))

(defun add-post (text)
  (vector-push-extend (make-instance 'post
				     :text text
				     :id (fill-pointer *posts*))
		      *posts*))
