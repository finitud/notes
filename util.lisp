;;;
;;; Utilities to print posts
;;;

(in-package #:notes)

(defmacro cat (varstr what)
  "Append the result of evaluating WHAT into VARSTR (destructive, expecting strings)"
  `(setf ,varstr (concatenate 'string ,varstr ,what)))

(defun print-single-post (item)
  (yaclml:with-yaclml-output-to-string
    (if (>= item (fill-pointer *posts*))
	(<:h2 (format nil "Post #~a does not exist" item))
	(<:as-is (print-post (elt *posts* item))))))

(defun print-all-posts ()
  (loop with output = ""
     for i from (- (fill-pointer *posts*) 1) downto 0
     do (cat output (print-single-post i))
     finally (return output)))

(defun new-post-form ()
  (yaclml:with-yaclml-output-to-string
		    (<:form :method :post
			    (<:label :for "text" "Post something:")(<:br)
			    (<:textarea :name "text" :cols "80" :rows "5")(<:br)
			    (<:input :type :submit :value "Post!"))))

;;
;; Pretty date formatting - taken from the CL Cookbook
;;

(defvar *day-names* '("Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"))
(defvar time-format-string "~2,'0d:~2,'0d:~2,'0d")
(defvar date-format-string "")

(defun format-date (post-date)
  (multiple-value-bind (second minute hour date month year day-of-week dst-p tz)
      (decode-universal-time post-date)
    (format nil "~a ~2,'0d/~2,'0d/~d @@ ~2,'0d:~2,'0d:~2,'0d (GMT~@d)"
	    (nth day-of-week *day-names*)
	    date
	    month
	    year
	    hour
	    minute
	    second
	    (- tz))))
