#lang racket

(require web-server/servlet
         web-server/servlet-env
         json)

(define app
  (lambda (req)
    (let ([event (bytes->jsexpr (request-post-data/raw req))])
      (response/xexpr
        (jsexpr->string
          (hasheq 'message "Succesfully running Scheme!"
                  'event event))))))

(serve/servlet app
               #:port 8080
               #:servlet-path "/"
               #:launch-browser? #f)

