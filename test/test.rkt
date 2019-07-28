#lang racket

(require "../index.rkt")

(define result
  (handler #hasheq((originalMessage . "Hello World!")) (make-hash)))

(displayln result)

