# ぼっちGit
### 作業の流れ  
1. [subブランチを切る](#subブランチを切る)
2. [前回コミットからの差分確認](#前回コミットからの差分確認)
3. [更新の切りのいいところでstaging](#更新の切りのいいところでstaging)
4. [前回コミットからの差分確認2](#前回コミットからの差分確認2)
5. [コミット(記録)する](#コミット(記録)する)
6. [mainブランチとの差分を確認](#mainブランチとの差分を確認)
7. [mainブランチとmerge](#mainブランチとmerge)
8. 2に戻る

## subブランチを切る
作業を開始する前にsubブランチを切ることで、mainのファイルとは別の履歴として残すことができる。  
まずはbranchを確認する。
```sh
git branch
# * main
#   test
```
必要のないものは削除できる。
```sh
git branch -d `target branch`
```
branchを移動する。
```sh
git checkout test
git branch
#   main
# * test
```
branchを新規に作成して移動する場合はcheckoutに`-b`オプション
```sh
git checkout -b sub
git branch
#   main
#   test
# * sub
```
[Top](#作業の流れ)
## 前回コミットからの差分確認 
`git status`で前回コミットからの変更点やstaging状況を確認できる。   
```sh
git status
# stagingされていない更新状況は下記のイメージ
# On branch sub
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#         git.md

# nothing added to commit but untracked files present (use "git add" to track)
```
`git diff`でbranchの変更点や差分を確認できる。
```sh
git diff
# 前回コミットと変更なければ出力されない
```
[Top](#作業の流れ)

## 更新の切りのいいところでstaging 
まずは確認。`git diff`はコミットの差分を確認するので、stagin前は何も出力されない。  
`git status`はトラックしているファイルの状況がわかる。
```sh
git diff
#

git status
# On branch sub
# Untracked files:
#   (use "git add <file>..." to include in what will be committed)
#         git.md

# nothing added to commit but untracked files present (use "git add" to track)
```
`git add . (target file)`でコミットしたいファイルをstagingしておく。


staging後は`git diff HEAD~`で直前のコミットとの差分を確認できる。
```sh
git add .
```
stagingを取り消したい時は`git reset`
```zsh
git reset (target file)
```
[Top](#作業の流れ)
## 前回コミットからの差分確認2

コミット前に`git status`と`git diff`でステータスと差分を確認する。
```sh
git status
# On branch sub
# Changes to be committed:
#   (use "git restore --staged <file>..." to unstage)
#         new file:   git.md

git diff
#

git diff HEAD~
# +# ぼっちGit
# +### 作業の流れ  

```
この段階まででコミットせずにブランチを抜けると、更新が削除されてしまうので注意。  
[Top](#作業の流れ)

## コミット(記録)する
```sh
git commit -m 'git.md was updated'
# [sub 2e1fbf2] git.md was updated
#  1 file changed, 59 insertions(+)
#  create mode 100644 git.md
```


[Top](#作業の流れ)

## mainブランチとの差分を確認
`git diff target_branch (updated_branch)`が基本の形。  
`git diff`は差分を取りたいbranchを第一引数に取る。  
特に指定しない場合は現在のbranchが第二引数。
```sh
git diff main (sub)
```


```sh
git init --bare --shared ./repository_name    # https://qiita.com/masatomix/items/19f4604c939567929ee8
git clone repository_name
git pull
git branch 
git checkout -b sub
git status
git add . (or target file)
git diff
git diff --staged
git diff main 
git diff --stat
git diff --name-only
git reset .
git commit -m 'comment'
git checkout main
git merge
git branch -d
git push