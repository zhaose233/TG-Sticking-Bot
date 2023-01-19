# 貼貼 Bot

把機器人加入到羣組中，如果消息內含有簡體或繁體的貼貼，則回復一個貼貼的表情包

## 使用方法

- 申請一個 Telegram Bot 皂 token，把 group privicy 設為能收到羣內所有消息
- 在 main.rkt 的同級目錄下新建一個名為 `token` 的文件
- 把 token 填到 `token` 文件裡
- ｀racket main.rkt` 運行 Bot

注意：在某些情況下運行它需要代理，可以設置 all_proxy 環璄變數來實現
