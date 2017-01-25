# SearchBM

[Boyer-Moore String Search Algorithm](https://www.wikiwand.com/ja/%E3%83%9C%E3%82%A4%E3%83%A4%E3%83%BC-%E3%83%A0%E3%83%BC%E3%82%A2%E6%96%87%E5%AD%97%E5%88%97%E6%A4%9C%E7%B4%A2%E3%82%A2%E3%83%AB%E3%82%B4%E3%83%AA%E3%82%BA%E3%83%A0) を用いて、任意パターンの配列を高速に検索する方法。

![](https://media.githubusercontent.com/media/LUXOPHIA/SearchBM/0d4ffe8e2b5802edfe62a0b19dde8f3fe60ca023/--------/_SCREENSHOT/SearchBM.png)

ジェネリクス化```TSearchBM<*>```されているので、どんな変数型の配列でも扱えます。

```Pascal
var
   Ws :TArray<Word>;
   S  :TSearchBM<Word>;
   M  :Integer;
   Ms :TArray<Integer>;

      {  00     01     02     03     04     05     06     07     08     09   }
Ws := [ $79FE, $BA26, $7B88, $BA26, $4F60, $A2A6, $7B15, $395C, $79FE, $7B88,
        $3B5B, $B6F6, $4F60, $A2A6, $7B15, $395C, $8F63, $176C, $3E7E, $2E6E ];
      {  10     11     12     13     14     15     16     17     18     19   }

S := TSearchBM<Word>.Create;

S.Pattern := [ $4F60, $A2A6, $7B15, $395C ];  //検索パターンの設定

///// 最短検索
{ 04 =} M := S.Match( Ws );
{ 12 =} M := S.Match( Ws, 10 );        //検索開始位置の指定
{ 04 =} M := S.Match( Ws, 00, 09+1 );  //検索終了位置の指定

///// 複数検索
{ [ 04, 12 ] =} Ms := S.Matches( Ws );
{ [     12 ] =} Ms := S.Matches( Ws, 10 );        //検索開始位置の指定
{ [ 04     ] =} Ms := S.Matches( Ws, 00, 09+1 );  //検索終了位置の指定

S.Free;
```

----

* [Boyer-Moore algorithm](http://www-igm.univ-mlv.fr/~lecroq/string/node14.html)
* [「データ構造」第13回 資料（Jul. 10, 2002, 奥乃）](http://winnie.kuis.kyoto-u.ac.jp/members/okuno/Lecture/02/DataStructure/ds-02-13.pdf)
* [Algorytm BM (Boyer-Moore'a) - Implementacja w Delphi/Pascal - Algorytmy i Struktury Danych](http://www.algorytm.org/przetwarzanie-tekstu/algorytm-bm-boyer-moorea/bm-d.html)
* [Computer Algorithms: Boyer-Moore String Searching](http://www.stoimen.com/blog/2012/04/17/computer-algorithms-boyer-moore-string-search-and-matching/)
* [Boyer-Moore algorithm - コードの恵み](http://d.hatena.ne.jp/deve68/20120205/1328454937)

[![Delphi Starter](http://img.en25.com/EloquaImages/clients/Embarcadero/%7B063f1eec-64a6-4c19-840f-9b59d407c914%7D_dx-starter-bn159.png)](https://www.embarcadero.com/jp/products/delphi/starter)
