# 移動前のdirectoryに戻る
```bash
cd -
```


# 値を出力する (like print)
```
echo xxx
# xxx
```
変数(var)を出力する

```bash
# var=output
echo $var
# output
```

# ファイルを結合して表示する
```bash
cat `filename1` `filename2` ...
```

# ファイルを連結して新しいファイルを作る、上書きする、追加する
```bash
cat `filename1` `filename2` > `new_file`  # 上書き
cat `filename1` `filename2` >> `target_file`  # 追加
```

# 入力した内容で上書きする、追加する
```bash
cat > `filename` # 上書き
cat >> `filename` # 追加
```




# 先頭に移動
```
ctrl + a
```
# 末尾に移動
```
# ctrl + e
```

# 前方の単語をカット
```
ctrl + w
```

# 行頭までカット
```
ctrl + u
```

# 行末までカット
```
ctrl + k
```

# ペースト
```
ctrl + y
```

# コマンド履歴の表示
```bash
history
```

# 履歴からコマンドを使用
```bash
!x(数字)
```

# manualを表示
```bash
man `command`
# qで終了
```

# 中身の入ったdirectoryの削除
```bash
rm -r `directory name`
# -r `recursive` 再帰的な
```

# lessで中身を表示する
```bash
less `filename`
# spaceで1pageスクロール
# bで1pageスクロールバック
# hjkl ←↓↑→
# /`word`で検索 nで移動
```

# ファイルをコピー、移動
```bash
cp `target_file1` `new_file`
cp `target_file1` `target_file2` ... `directory_name`
cp -r `target_directory` `new directory`
mv `target_directory` `destination` # mvは-rがいらない
```

# brace展開 {x..y}
```bash
echo file{1..5}
# file1 file2 file3 file4 file5
echo file{11,13}
# file11 file13
```

# ワイルドカード
```bash
# file1 file2 file10
file* # file1 file2 file10 文字列
file? # file1 file2 一文字
file?? # file10 二文字
```

# ハードリンクとシンボリックリンク
- ハードリンク : ファイルの実体に名前を結びつける (not directory)
```bash
ls -F
#  SoundABC.ipynb games/ sound/

mkdir games/testdir testdir # 2つ指定すると2つできる
ls -F
#  SoundABC.ipynb games/(testdir) sound/ testdir/

cat >>games/testdir/test
test was created # terminated by ctrl +c
cd games/testdir/
ls -l
# -rw-r--r--  1 keetane  staff  0 Jan 16 04:37 test
cat test
# test was created


ln test test2 #ハードリンク設定
ls -s
# -rw-r--r--  2 keetane  staff  0 Jan 16 04:37 test
# -rw-r--r--  2 keetane  staff  0 Jan 16 04:37 test2

rm test # rmはハードリンクの削除でfile実体は残っている
ls -l
# -rw-r--r--  1 keetane  staff  0 Jan 16 04:37 test2
cat test2
# test was created

```

- シンボリックリンク : 名前に名前を結びつける(?) (directory as well)
```bash
ls -F
#  SoundABC.ipynb games/ sound/

mkdir -p games/dir1/dir2/dir3 testdir # 2つ指定すると2つできる
ls -F
#  SoundABC.ipynb games/(dir1/dir2/dir3) sound/ testdir/

cat >>games/dir1/dir2/dir3/test
test was created # terminated by ctrl +c
ls -l games/dir1/dir2/dir3/
# -rw-r--r--  1 keetane  staff  0 Jan 16 04:37 test
cat games/dir1/dir2/dir3/test
# test was created

ln -s games/dir1/dir2/dir3/test games/testlink #　シンボリックリンクの作成
ls -l games/dir1/dir2/dir3/test
# -rw-r--r--  1 keetane  staff  17 Jan 16 04:52 test
ls -l games
# lrwxr-xr-x  1 keetane  staff    4 Jan 16 04:54 testlink -> test
cat games/testlink
# test was created

mv games/dir1/dir2/dir3/test games/dir1 # リンク先ファイルの移動
ls -F games/dir1
# dir2/ test
cat games/testlink
# cat: testlink: No such file or directory # 参照ファイルがないので見れない
mv games/dir1/test games/dir1/dir2/dir3/test
ls -l dir1/dir2/dir3/
# lrwxr-xr-x  1 keetane  staff  9 Jan 16 05:39 test -> dir1/test
cat games/dir1/dir2/dir3/test
# test was created # 参照ファイル復活で見える

mv games/dir1/dir2/dir3/test games/dir1 # リンク先ファイルの移動
ln -s games/dir1/test games/dir1/dir2/dir3/test # 移動先ファイルにシンボリックリンクを紐付け # 絶対パスじゃないとエラー出ることがある
cat games/
# test was created # 参照ファイル復活で見える

rm games/dir1/test # リンク先の削除
cat testlink
# cat: testlink: No such file or directory #リンク先のファイルは存在しない

cat >>dir1/dir2/dir3/test
test file was recreated # terminated by ctrl +c
cat testlink
# test file was recreated  #ファイル名が同じなのでアクティブ
```

# 探す  
```bash
find `directory` `search condition` `action`

find . -name "*.txt" #-print

find . -type d # d:directory, l:synbolic link, 
find . -type d -name `target_directory` # 条件を追加して検索
```

# 高速に探す (ファイルのDBから探す、作成されていないと検索できない)
```bash
locate --version
# ex.  mlocate 0.26 if installed

locate "keyword"

locate bash -A doc # and検索
locate bash doc # or検索

sudo updatedb
# user pw で実行
# locateのDBをアップデート

```

# ファイルの中の特定の行を検索する
```bash
grep "keyword" "file"
# global regular expression print: ファイル全体のうち、正規表現に一致する行を出力する
```

# permissionの変更 (change mode)
```bash
ls -l

-rwxr-xr-x owner group file
```

シンボルモードで変更
```bash
chmode a+x `file`

u = owner
g = group
o = other
a = all

# u-w
# g-x
# o=rw
```

数値モードで変更
```bash
chmod 664 `file`
r=4
w=2
x=1
足し算でそれぞれのユーザーのパーミッションを1~7で指定
```

# スーパーユーザーに変更する
```bash
su
# pw
# root@localhost directory # 
```

# 一般ユーザーに戻る
```bash
exit
# user@localhost directory $
```

# スーパーユーザーとして実行する
```bash
sudo command
# user pw
```

# 文字数や行数を数える
```bash
wc -w `file`
# 単語数

wc -l `file`
# 行数
```






# 並び替えて表示する
 ```bash
 sort `file`
 sort -r `file` # 逆順
 sort -n `file` # 数値順

 ls . | sort # パイプラインと組み合わせてdirectoryのリストをソート
 ```

 # 重複を取り除く
 ```bash
 unique `file` # 連続した重複を除く

sort `file` | unique # sortして全ての重複を取り除く
sort `file` | unique -c # 重複数をカウントする
sort `file` | unique -c | sort -nr # 重複回数順に表示
sort `file` | unique -c | sort -nr | head -n 3 # 重複回数順の先頭3行を表示
sort `file` | unique -c | sort -nr | tail -n 3 # 重複回数順の末尾3行を表示

```

# ファイルの変更を監視する
```bash
tail -f `file` # ctrl + cで監視モードを終了
```

# プロセスを表示する
```bash
ps
ps x # デーモンや別ターミナルを含めた全てのプロセス表示
ps a # 全てのユーザー
ps u # 詳細情報も含めてプロセス表示
ps ua
```

# x秒スリープする
```bash
sleep `x`
```

# ジョブを一覧する
```bash
ctrl + z # ジョブを一時停止する

sleep 10
ctrl + z
jobs # [1]  + suspended  sleep 10
jobs -l # [1]  + 93519 suspended  sleep 10
```

# フォアグラウンド実行に変更する
```bash
sleep 10
ctrl + z
jobs # [1]  + suspended  sleep 10
fg %1 # 1を指定すると1のjobが再開
jobs # (clear)
```

# バックグラウンド実行に変更する (実行中に別処理を行える)
```bash
sleep 60
ctrl + z
jobs # [1]  + suspended  sleep 60
fg %1 # 1を指定すると1のjobが再開
jobs # [1]  + running    sleep 60 >> [1]  + done       sleep 60
```


# 最初からバックグラウンド実行したい場合は末尾に＆をつける
```bash
sleep 10000 & 
```

# バックグラウンド処理を停止するにはkill
```bash
jobs # [1]  + running    sleep 10000
kill %1 # [1]  + terminated  sleep 10000  
```

# killコマンドの本質は停止ではなくシグナル送信  
kill -TERM が停止としてデフォルトで設定されているだけ
```bash
kill -l
# HUP INT QUIT ILL TRAP ABRT EMT FPE KILL BUS SEGV SYS PIPE ALRM TERM URG STOP TSTP CONT CHLD TTIN TTOU IO XCPU XFSZ VTALRM PROF WINCH INFO USR1 USR2

kill -l | wc -w # 31
```

# プロセスを強制終了
```bash
sleep 10000 & # [1] 95540
jobs # [1]  + running    sleep 10000
kill -KILL %1 # [1]  + killed     sleep 10000 
# or
kill -9 %1 # [1]  + killed     sleep 10000 
```

# HTTPやFTPでのダウンロードやアップロードする (client for URL)
```bash
curl `http://www.xxx/`
curl -O `http://www.xxx/` # ファイルへの保存
curl -O "http://www.hoge.com/[1-5].jpg" # 連番で保存
# curl -O "http://www.hoge.com/1.jpg"
# curl -O "http://www.hoge.com/2.jpg"
# curl -O "http://www.hoge.com/3.jpg"

curl -O "http://www.hoge.com/{1,3,5}.jpg" # 複数ファイルを指定
# curl -O "http://www.hoge.com/1.jpg"
# curl -O "http://www.hoge.com/3.jpg"
# curl -O "http://www.hoge.com/5.jpg"

curl -O "http://www.hoge.com/image{,_big,_small}.jpg" # 文字列で指定
# curl -O "http://www.hoge.com/image.jpg"
# curl -O "http://www.hoge.com/image_big.jpg"
# curl -O "http://www.hoge.com/image_small.jpg"

curl -o google.html http://www.google.com/ # 出力ファイルの指定
# google.html

curl http://www.google.com/ > google.html # 結果は上記と一緒
curl http://files.rcsb.org/download/3ERK.pdb | grep ATOM > test.pdb # パイプラインもできる
```

# プロセスを表示する
```bash
top # ctrl + cで終了
```

# 環境変数を一覧する
```bash
env
```

# PATHを通す
https://qiita.com/fuwamaki/items/3d8af42cf7abee760a81
```bash
export PATH=$PATH:`target_directory`
```

# コマンドの確認
```bash
which `command`
# /usr/bin
```

# apt (Advanced Package Tool)
インストールされているパッケージを表示
```bash
apt list --installed
```
アップデートできるパッケージを表示
```bash
apt list --upgradable
```
パッケージを検索する
```bash
apt search zsh
```
パッケージをインストール
```bash
sudo apt install xxx
```
パッケージを削除
```bash
sudo apt remove xxx
```
不要なパッケージを削除

```bash
sudo apt-get autoremove
```
パッケージのインデックスをアップデート

```bash
sudo apt update
```
パッケージをアップデート
```bash
sudo apt update
sudo apt upgrade
```
# 端末を閉じてログアウトしても処理を続ける

```bash
nohup `command` &
```