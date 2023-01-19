#lang racket

(require json)
(require net/url)

(define token "")

;; 從文件讀取 bot token
(with-input-from-file "./token"
  (lambda () (set! token (read-line))))

(if (not (string? token))
    (error 'TOKEN_WRONG)
    (void))

(define u-base (string->url (string-append "https://api.telegram.org/bot"
                                           token
                                           "/")))

;; 最後一次返回的 Update Result 的 ID
(define last-id 0)

(define (bot-get-updates)
  (let* [(u-1 (combine-url/relative u-base "getUpdates"))
         (u-final (struct-copy url u-1
                               [query `((offset . "-1"))])) ; 拼接 URL
         (res (read-json (get-pure-port u-final))) ; 請求最新一條 Update
         (result (car
                  (hash-ref res 'result)))
         (update-id (hash-ref result 'update_id))]

    (cond [(<= update-id last-id) (bot-get-updates)] ; 如果發現這條 Update 已處理過則重新嘗試
          [else
           (set! last-id update-id)
           result]) ; 更新 UpdateID 並返回 Update
    ))

(define (send-sticker chat-id sticker
                      #:reply-to [reply-to #f])
  (let* [(u-1 (combine-url/relative u-base "sendSticker"))
         (u-final (struct-copy url u-1
                               [query (append `((chat_id . ,(number->string chat-id))
                                                (sticker . ,sticker))
                                              (if reply-to `((reply_to_message_id . ,(number->string reply-to)))
                                                  '()
                                                  ))]))
         (res (read-json (get-pure-port u-final)))]

    (cond [(not (hash-ref res 'ok))
           (displayln (string-append "STICKER SEND ERROR: " (hash-ref res 'description)))
           #f]
          [(hash-ref res 'ok) #t]
          [else #f])
    
    ))
    

(provide bot-get-updates
         send-sticker)
