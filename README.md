# Ardisconnector

This gem dissconnect database connection on every request finished.  

Rails app process keeps connection to database when request finished.

## データベースコネクションの問題

ActiveRecord はコネクションプーリングにより、コネクションを維持し続けます。
これをプロセスベースの web サーバで運用すると

** (process count) x (web server count) **

分のコネクションをデータベースへ張り続けることになり  
サービスの規模によっては、コネクション数を食いつぶしてしまうので  
つくってみました。

スレッドベースの web サーバでは試してませんが
多分動くと思います。

This project rocks and uses MIT-LICENSE.
