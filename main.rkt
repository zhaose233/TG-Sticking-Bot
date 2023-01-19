#lang racket

(require json)
(require net/url)

(require "lib.rkt")

(define (sticking-handler update)
  (displayln 'ON)
  (cond [(and (hash-has-key? update 'message)
              (hash-has-key? (hash-ref update 'message) 'text))

         (let* [(message (hash-ref update 'message))
                (chat-id (hash-ref (hash-ref message 'chat) 'id))
                (text (hash-ref message 'text))
                (message-id (hash-ref message 'message_id))]

           ;; (displayln (list chat-id text message-id))
           (if (or (string-contains? text "贴贴")
                   (string-contains? text "貼貼"))
               (send-sticker chat-id
                             "CAACAgUAAx0CZJmRBgABAV7RY8kEaZsPNWSat0aU9IqM_UIySJ0AAocIAAJX86lUETdZk75Oyn4tBA"
                             #:reply-to message-id)
               (void)))
           ]
        [else (void)]))


(let loop ()
  (let [(update (bot-get-updates))]
    (displayln update)
    (sticking-handler update))
  (loop))
  
