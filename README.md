# これは何？
neovimの開発環境をコンテナにパッケージしたものです。
各種プラグインを動かすためのミドルウェアも全て含んでいるためコンテナイメージのサイズはかなり大きいです。(3GB以上)

# 使い方
1. イメージをビルドします
```
$ make build
```

2. コンテナ内に持っていきたいプロジェクトを、READMEがあるディレクトリの一つ前のディレクトリ内に配置した"projects"フォルダに入れておきます

3. getBatteryStatus.sh.example をコピーしてgetBatteryStatus.shにリネーム
```
$ cp getBatteryStatus.sh.example getBatteryStatus.sh
```

5. getBatteryStatus.shの中身を開き、`/Users/yourname/nvim-docker/batteryStatus.txt` の部分をこのREADMEがあるディレクトリにbatteryStatus.txtが配置されるように修正する

6. cronでgetBatteryStatus.shを登録する
```
crontab -e
```
cronに登録するときにエラーが出た場合に確認できるようlogを出すように設定しておきます
```
* * * * * /Users/yourname/nvim-docker/getBatteryStatus.sh >> /Users/yourname/nvim-docker/batteryStatus.log 2>&1
```

7. コンテナを立ち上げます
```
$ make up
```

8. コンテナに入ります
```
make n
```

9. コンテナに入った直下にprojectsフォルダの中身が同期されているので、好きなプロジェクトに移動して開発を開始します

# 現在対応している言語
- php
- go
- typescript
- lua

# neovimの設定をいじりたい時
以下のディレクトリに設定があります。
```
$ cd ~/.config/nvim
```

