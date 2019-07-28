#lang racket

(require json
         simple-http)

(define handler (getenv "_HANDLER"))
(define task-root (getenv "LAMBDA_TASK_ROOT"))
(define runtime-url (getenv "AWS_LAMBDA_RUNTIME_API"))


(define get-file
  (lambda (handler)
    (car (string-split handler "."))))

(define get-method
  (lambda (handler)
    (string->symbol
      (car (cdr (string-split handler "."))))))

(define get-host
  (lambda (url)
    (car (string-split url ":"))))

(define get-port
  (lambda (url)
    (string->number (car (cdr (string-split url ":"))))))

(define file (get-file handler))
(define method (get-method handler))
(define host (get-host runtime-url))
(define port (get-port runtime-url))

(define main-function
  (dynamic-require
    (string->path
      (string-append task-root "/" file ".rkt"))
    method))

(define invocation-response
  (lambda (aws-request-id data)
    (put (update-host (update-port json-requester port) host)
         (string-append "/runtime/invocation/" aws-request-id "/response")
         #:data (jsexpr->string data))))

(define invocation-error
  (lambda (err)
    (display err)))

(define next-invocation
  (lambda ()
    (let ([res (get (update-host (update-port json-requester port) host)
                    "/runtime/invocation/next")])
      (let ([result (main-function
                      (json-response-body res)
                      (make-hasheq))])
        (invocation-response
          (car
            (hash-ref (json-response-headers res)
                      'Lambda-Runtime-Aws-Request-Id))
          result)))))

(define main
  (lambda ()
    (next-invocation)
    (main)))

(main)

