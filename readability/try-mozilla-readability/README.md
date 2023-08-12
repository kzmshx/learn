# try-mozilla-readability

## モチベーション

ウェブサイトのコンテンツの音声化を自動化したい。

ネット記事や書籍を音声化して、読書のリズムを作ったり、通勤中や散歩中に耳から情報収集できるようにしたい。

## 実験

### 1. mozilla/readabilityでウェブサイトのメインコンテンツを抽出（リーダービューの生成）

- めちゃくちゃ簡単にメインコンテンツを抽出できる
- ライブラリのロジックは知らないが、広告とか不要な要素を消しているらしい
- 記事の内容を抽出して聞けるようにする、という目的に対しては十分な性能に感じた

### 2. VOICEVOXで音声合成をやってみたが、上手くいかない

- Docker Imageが提供されてるので使ってみたが、多分M1のせいで処理が失敗する

### 3. Amazon Pollyで音声合成をやってみた

#### mozilla/readabilityが抽出コンテンツのテキストをそのまま食わせる

- 音声合成自体はできた、Node.jsのSDKがv2/v3で結構書き方が違うのでところどころ詰まったけど
- 「ChatGPT」を「ちゃっぐぷと」と読むなど、特に固有名詞の音声化では精度に欠けた

#### テキストをChat-GPTで仮名読みに変換する

- Chat-GPT (GPT-4) はテキストの読み方もかなり正確に生成することができた
- Amazon Polly にこれを食わせたところ、固有名詞の読みは勿論いい感じになった
- このときはすべてを仮名に直したので Polly が逆に単語の区切りが分からなくなって、その他の部分のリズムやイントネーションが崩れた

#### テキストをChat-GPTでルビ付きSSMLに変換する

- Amazon Polly は読み方やイントネーションを細かく指示できる SSML 形式の入力をサポートしているのでそれを試した
- ここでも Chat-GPT (GPT-4) が大活躍、ルビの振り方の構文の例を一つ与えるだけでめっちゃ正確に SSML に変換できた
- 細かいイントネーションとかの崩れが気にはなるものの、もう記事を聴き読みして不快じゃない程度の精度にはなった、すげぇ

### 4. OpenAI APIでテキストのSSML化を自動化

1. src/templates/text_to_ssml.txt
   1. テキストをそのまま入力に渡して、SSML化（speakタグ付け）とルビの補完を両方やらせようとした
   2. `gpt-3.5-turbo` で試したが、文章本体が崩れたりしてあまり良くなかった
   3. `gpt-4` で試すと性能は良かったが、時間がかかり過ぎるのに加えて、502エラーが多発する問題が発生
   4. 長い文章をまるっと入力に与えるのは、性能面でもコスト面でもよくないと判断
2. src/templates/ssml_ruby_completion.txt
   1. 文章を予めSSMLに変換（speakタグで囲むだけ）ルビの補完だけをやらせるようにした
   2. `gpt-4` だと時間・費用面が厳しいので `gpt-3.5-turbo` でもどうにか性能を出したいのが動機
   3. `gpt-3.5-turbo` で試したがやはり文章ごと出力させると性能面が少し心許ない、加えてやはり出力トークン数がかさんでしまうのも速度・費用面の効率が悪いと判断
3. src/extract_ruby.txt
   1. 「ルビを補完する」という考え方をやめ「読みのマップを生成する」方針に変更
   2. これは `gpt-3.5-turbo` でも十分な性能を確保でき、かつ出力トークン数も少なくて済むので速度・費用面で効率が良かった
   3. `temparature=0` にすれば表現の揺れも抑えられた、多分これが一番良い方法

## 生成物

- data/article_all.txt
  - mozilla/readability を使ってウェブサイトから抽出したメインコンテンツのテキスト
  - 最近読んだ記事を使わせていただいた: https://www.watch.impress.co.jp/docs/topic/1520290.html
- data/article.txt
  - data/article_all.txt から一部を抜粋したテキスト
- data/article_all_ssml.txt
  - data/article_all.txt をSSML変換したテキスト
- data/article_ruby.txt
  - Chat-GPT に article.txt の一部を入力して仮名読みに変換させたテキスト
- data/article_ssml.txt
  - Chat-GPT に article.txt の一部を入力してSSMLに変換し固有名詞等にルビを振らせたテキスト
- data/speech_{i}.mp3
  - data/article.txt を Amazon Polly で音声合成したもの
- data/speech_ruby_{i}.mp3
  - data/article_ruby.txt を Amazon Polly で音声合成したもの
- data/speech_ssml_{i}.mp3
  - data/article_ssml.txt を Amazon Polly で音声合成したもの
