# Markdownのチートシート
https://qiita.com/shizuma/items/8616bbe3ebe8ab0b6ca1  
  
## 1.見出し
文頭に#をつけることで見出しにすることが出来ます。  
また、#の数で見出しに重みを下げることが出来ます。  
htmlでいうところのh◯の◯が#の数ということです。  
以下のように使います。


~~~python
# 大見出し
## 中見出し
### 小見出し
#### どこまで
##### 見出しに
###### できるのか
####### #7個は変換されないらしい
~~~
># 大見出し
>## 中見出し
>### 小見出し
>#### どこまで
>##### 見出しに
>###### できるのか
>####### #7個は変換されないらしい




## 2.コードの挿入
コードの挿入の基本は\`\`\`(バッククオート3つ)でコードをくくることです。  
\` はバッククオートです。クォーテーション '　ではありません。ご注意を。

~~~
```python  
def hello():  
    print("hello world!!")
```
~~~


> ~~~python
def hello():
    print("hello world!!")


## 3.リンクの挿入、画像の埋め込み
リンクの挿入は、[リンクテキスト](URL)と書きます。

~~~python
[Qiita](http://qiita.com/)
~~~
のように書くと  
> [Qiita](http://qiita.com/)

タイトル付きリンク（タグにtitleがつきます）は[リンクテキスト](URL "タイトル")と書きます。

~~~python
[Qiita](http://qiita.com/　"キータ")  
~~~
のように書くと  
> [Qiita](http://qiita.com/　"キータ")  


画像の挿入は、[代替テキスト](画像URL)と書きます。

~~~python
![Qiita](http://cdn.qiita.com/assets/siteid-reverse-6044901aace6435306ebd1fac6b7858c.png)  
~~~

のように書くと
> ![Qiita](http://cdn.qiita.com/assets/siteid-reverse-6044901aace6435306ebd1fac6b7858c.png)    
  
タイトル付きにするにはリンクと同様に![リンクテキスト](URL "タイトル")と書きます。

~~~python
![Qiita](http://cdn.qiita.com/assets/siteid-reverse-6044901aace6435306ebd1fac6b7858c.png　"キータ")  
~~~
のように書くと
> ![Qiita](http://cdn.qiita.com/assets/siteid-reverse-6044901aace6435306ebd1fac6b7858c.png)  


ただし、Qiitaでの編集の場合はドラック&ドロップで画像が挿入されるので、画像の挿入を手動で入力する必要はありません。

## 4.引用
\>を書くだけです。
ただし、改行するときはその度に>を書く必要があるので注意です。

~~~python
> ここに引用文を書きます。
~~~
>ここに引用文を書きます。  


引用の中で別のMarkdown記法を使うことが出来ます。

ちなみに、引用をネストするときは>を複数書くとネストされます。

~~~python
>引用文です  
>>ネストです
~~~
> >引用文です  
>>>ネストです


## 5.文字の修飾(イタリック、太字、打ち消し線)
- イタリック

「_」または「*」で文字をくくります。  
~~~python
_イタリック_   
*イタリック*
~~~
> _イタリック_  
> *イタリック*

- 太字

「__」または「**」で文字をくくります。
~~~python
__太字__
**太字**
~~~
>__太字__  
> **太字**

- 打ち消し線

「\~~」で文字を括ります。
~~~python
~~打ち消し線~~
~~~
> ~~打ち消し線~~



## 6.リスト
リストの上下に空白を入れないと正しく表示されないので注意。
また、記号と文の間に半角スペースを入れること。

- 順序なしリスト  

文頭に「*」「+」「-」のいずれかを入れる。

~~~python
* 順序なしリスト  
~~~
> * 順序なしリスト  

- 順序つきリスト  

文頭に「数字.」を入れる。  
見た目はほぼ変わりません。
~~~python
1. リスト1  
2. リスト2
~~~
>1. リスト1
>2. リスト2

ネストすると数字からアルファベットになります.
~~~python
1. リスト1  
2. リスト2
>1. リスト1  
>2. リスト2
~~~
>1. リスト1  
>2. リスト2
>> 1. リスト1  
>> 2. リスト2

## 7. 水平線
「*」か「-」を3つ以上一行に書く。
以下は全て水平線となる。
~~~python
***  
* * *  
---  
- - -  
~~~
>
>全部以下の水平線
>***
>


## 8. テーブル
以下のようにテーブルを組みます。  
基本は「|」でくくっていくことです。  
2行目がポイントで、2行目のコロンの位置によってセル内の文字の配置が変わります。  
~~~python
|左揃え|中央揃え|右揃え|  
|:---|:---:|--:|  
|align-left|align-center|align-right|  
セルの左揃えです|セルの中央揃えです|セルの右揃えです|  
~~~
>
>|左揃え|中央揃え|右揃え|
>|:---|:---:|--:|
>|align-left|align-center|align-right|
>|セルの左揃えです|セルの中央揃えです|セルの右揃えです|


## 9. マークダウンのエスケープ
「\」をMarkdownの前につけることでMarkdownを無効化出来ます。
この記事ではこれを多用しました。

## 10. 文字色
文字の色を指定します。
~~~python
<font color="Red">テキスト</font>
~~~
> <font color="Red">テキスト</font>

## 11. ページ内リンク
GitHubのMarkdownを利用すると、見出し記法を利用した際に
アンカーが自動的に作成されます。  
そのアンカーを利用したページ内リンクを簡単に作成できます。

~~~python
## menu
* [to header1](#header1)
* [to header2](#header2)

<!-- some long code -->

[return to menu](#menu)
### header1
### header2
~~~

## menu
* [to header1](#header1)
* [to header2](#header2)

<!-- some long code -->

[return to menu](#menu)
### header1
### header2