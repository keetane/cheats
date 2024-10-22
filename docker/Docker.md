# Dockerの全体像  
![docker図解](https://penpen-dev.com/blog/wp-content/uploads/hsthbrt.png)  
https://penpen-dev.com/blog/docker-command/

出力される結果は各自の環境で異なるので参考程度にしてください。


# Contents
- [新しい環境を構築する](#新しい環境を構築する)
- [Containerで作業する](#Containerで作業する)
- [環境を破棄する](#環境を破棄する)
- [Dockerfile](#dockerfileからimageをbuild)
- [Reference](#reference)

# 新しい環境を構築する
## docker hubからimageをpull
```bash
docker pull `image:ver`

docker pull ubuntu      # ver.を指定しないとlatestがpullされる
```



## pullしたimageを参照
```bash
docker images

# REPOSITORY                      TAG       IMAGE ID       CREATED        SIZE
# ubuntu                          latest    4c2c87c6c36e   7 weeks ago    69.2MB
# python                          latest    9dda5bedc1c7   3 months ago   868MB
```

## imageからコンテナを作ってrun
enterはしない  
imageを持ってない場合はhubからpullしてくる

```bash
docker run `image_name` 
docker run --name `container_name` `image_name`  # --name ``でcontainer nameを指定できる
docker run --name test hello-world

# Hello from Docker!
# This message shows that your installation appears to be working correctly.
# ...
```

## imageからcontainerを作ってbashで作業する
```bash
docker run --name `container_name`　-it `image_name` bash # interact terminal

# root@container_id:/#     # containerのbash promptが返ってくる

root@container_id:/# exit  # containerを停止してexitする

# directory$            # hostのterminal promptに戻る
```

## imageからcontainerにlocal volumeをマウントしてbashで作業する
```bash
docker run --name `container_name` -v `host abs. path`:`container abs. path` `image_name` `command`

docker run --name `container_name` -v ~/Documents/Linux:/work -it ubuntu bash
```

## imageからcontainerにlocal volumeをマウントしてjupyterのポートを割り当ててbashで作業する
```bash
docker run -v ~/Documents/Linux:/work -p 8888:8888 --name test ubuntu
# container側にJupyterなどが入ってないとhostのブラウザで`localhost:8888` を入力してもjupyterは起動しない
```

[Contentsに戻る](#Contents)


# Containerで作業する

## containerのリストを表示
```bash
docker ps       # upのものだけ
docker ps -a    # 全て表示

# CONTAINER ID   IMAGE                          COMMAND                  CREATED        STATUS                      PORTS     NAMES
# 498900d17e03   hello-world                    "/hello"                 2 minutes ago   Exited (0) 2 minutes ago              test
# cdf417f58458   continuumio/anaconda3:latest   "/bin/bash"              3 months ago   Exited (137) 20 hours ago             anaconda3

# runしただけではcontainer statusはexited
```

## containerを起動する
```bash
docker restart `container_name`

docker restart test
# test

docker ps -a
CONTAINER ID   IMAGE                          COMMAND                  CREATED         STATUS                      PORTS     NAMES
498900d17e03   hello-world                    "/hello"                 7 minutes ago   Exited (0) 48 seconds ago             test
cdf417f58458   continuumio/anaconda3:latest   "/bin/bash"              3 months ago    Exited (137) 20 hours ago             anaconda3

# hello-worldにはOSとbashが入ってないので起動(=up)にならない
```

```bash
docker restart anaconda3
# anaconda3

docker ps # status == up のcontainerを表示

# CONTAINER ID   IMAGE                          COMMAND       CREATED        STATUS         PORTS     NAMES
# cdf417f58458   continuumio/anaconda3:latest   "/bin/bash"   3 months ago   Up 5 seconds             anaconda3
```


## 起動中のcontainerに入って新しいbashで作業する (execute)
```bash
docker exec -it `container_name` bash
# root@container_id:/#      # containerのbash promptが返ってくる
```

docker attachとの違いについて  
https://qiita.com/RyoMa_0923/items/9b5d2c4a97205692a560  
attach : container内の既に起動しているbashを使う  
exec -it : 新たにbashを立ち上げる


## 起動したままcontainerから抜ける (detach)
```bash
ctrl+p ctrl+q
```
VS codeではVS codeのショートカットが起動してしまうので変更する必要がある  
https://qiita.com/Statham/items/c204e85067ea4dca2724  

```bash
docker ps

# CONTAINER ID   IMAGE                          COMMAND       CREATED        STATUS          PORTS     NAMES
# cdf417f58458   continuumio/anaconda3:latest   "/bin/bash"   3 months ago   Up 10 minutes             anaconda3
```

## 起動中のcontainerのbashに入って作業する
```bash
docker attach `container_name`
# root@container_id:/#      # container/bashのpromptが返ってくる
```

## containerを停止して脱出する
```bash
root@container_id:/# exit

docker ps -a
STATUS          PORTS     NAMES
# cdf417f58458   continuumio/anaconda3:latest   "/bin/bash"   3 months ago   Exited 10 seconds             anaconda3

```




[Contentsに戻る][# Contents]


# 環境を破棄する
Containerはimageを基に動いているので、containerが存在するうちはimageを削除できない。  
手順としては
1. [containerをimageにcommit](#コンテナをimageにcommit)
2. [imageをdockerhubにpush](#docker_hubにログイン)
3. [containerを削除](#containerを削除)
4. [imageを削除](#imageを削除)

で環境を保存しながら適宜破棄する。  
もしくはDockerfileとして残す。

## コンテナをimageにcommit
```bash
docker commit `container_name` `image_name:ver`

docker images

# REPOSITORY                      TAG       IMAGE ID       CREATED         SIZE
# ubuntu                          latest    4c2c87c6c36e   7 weeks ago     69.2MB
# python                          latest    9dda5bedc1c7   3 months ago    868MB
# continuumio/anaconda3           latest    40d5cbe3a8cd   7 months ago    2.69GB

docker commit anaconda3 continuumio/anaconda3
# sha256:1b5cfa5999b6dceb07ddd5ebea6c7c24ec98d61a783fa719443a5adb2a4016b9

docker images

# REPOSITORY                      TAG       IMAGE ID       CREATED         SIZE
# continuumio/anaconda3           latest    1b5cfa5999b6   4 seconds ago   3.26GB
# ubuntu                          latest    4c2c87c6c36e   7 weeks ago     69.2MB
# python                          latest    9dda5bedc1c7   3 months ago    868MB
# continuumio/anaconda3           <none>    40d5cbe3a8cd   7 months ago    2.69GB
```



## docker_hubにログイン
```bash
docker login      # idとpwを入力
```

## imageをdocker hubのrepoにpush
```bash
docker push `user_id/image_name:ver`
```

## containerを削除
```bash
docker rm `container_name` # or `container_id`
```



## imageを削除
```bash
docker rmi `image_name`

docker rmi continuumio/anaconda3
docker images

# REPOSITORY                      TAG       IMAGE ID       CREATED         SIZE
# ubuntu                          latest    4c2c87c6c36e   7 weeks ago     69.2MB
# python                          latest    9dda5bedc1c7   3 months ago    868MB
# continuumio/anaconda3           <none>    40d5cbe3a8cd   7 months ago    2.69GB

# 指定しないとlatestが消えるっぽい
# latestがないimageは`:ver`でtagを指定しないと消えない
# containerで使用中だとreferenceになっているため削除できない
```


[Contentsに戻る][# Contents]



# dockerfileからimageをbuild
```bash
cd `working directory`
docker build -t `image_name` .

docker build -t `image_name` . --no-cache     # オプションないと前回の続きをbuildする

docker build -t 'image_name' -f 'dir/dockerfile_name' 'dir/'   # dir/にある任意のdockerfileからbuildする

```
[Contentsに戻る][# Contents]


# Reference
### Docker超入門
https://datawokagaku.com/category/%e8%ac%9b%e5%ba%a7%e4%b8%80%e8%a6%a7/docker%e8%b6%85%e5%85%a5%e9%96%80/

### ぷんたむの悟りの書
https://punhundon-lifeshift.com/dockerfile

### miniconda + conda-forgeで開発環境を揃える
https://qiita.com/kimisyo/items/66db9c9db94751b8572b    

[Contentsに戻る][# Contents]


[# Contents]: #Contents