# learning

- system-design
  - [x] (2023-07-28) [aws-serverless-web-app](system-design/aws-serverless-web-app)

# 日記

## 2023-08-07

- ウェブサイトのメインコンテンツの抽出（リーダーモードのやつ）にはArc90というやつが使える
  - https://github.com/mozilla/readability
  - https://github.com/masukomi/arc90-readability
- テキストからの音声合成にVOICEVOXがなかなかよさそう
  - https://qiita.com/kunishou/items/814e837cf504ce287a13#%EF%BC%95whisperbertvoicevox%E3%82%92%E7%94%A8%E3%81%84%E3%81%9F%E5%AF%BE%E8%A9%B1%E3%83%AD%E3%83%9C%E3%83%83%E3%83%88
  - GCP、AWSにもText-to-Speechのサービスはある、有料だけど → https://qiita.com/Reng/items/f10265c0ee994a0b4f57

## 2023-08-04

- スプリントレビューに呼ぶ人は常に同じで良いわけじゃない、プランニング結果（＝そのスプリントの成果物の予定）に応じて必要な人間を招集する必要がある。例えば、今スプリントの開発内容に認証機能や課金機能などのユーザーの安全にとって重大な機能を開発するとしたらセキュリティの専門家を招集すべきだ。
- MySQLのv8.0からWITH句が使えるようになった。クエリの可読性を向上させたり、クエリの再利用性を高める上で、WITH句は非常に役に立つ。仕事でのテストデータ作成がめっちゃ快適になった
- PHPで配列シンタックスを利用しつつReadonlyにするためにはArrayAccessibleを実装しoffsetSet,offsetUnsetをできなくすればよい。OpenAIのPHPライブラリの中にArrayAccessibleを実装したTraitがあった。
- Shellで `COMMAND="$*"` みたいにやると、引数の文字列の中の `"` が消えてしまうことを認識した

## 2023-08-03

- 改善タスクで、まずコード整頓と自動テスト見直しをしてプルリクを作り、コードレビューを通す。その後、目的のコードを追加する、もし設計や実装が思いの外大変でスプリント内で目的を達成できそうにないなら、レビューを通したコード整頓とテストをリリースしてしまえば良い。コードベースに対して何の進歩ももたらさない期間を何週間も過ごすのは自他にとってよくない
- 大事なことはそういった「間に合わなさそうだから分ける」ということをいち早くチームに共有し、バックログを整理し直すこと、一人で抱え込むことは自分にとって非常に苦しく、他のメンバーにとって甚だ迷惑である

## 2023-08-02

- 回るスクラムには「透明性」が欠かせない
- 長期間保持されるREMEMBERMEは危険
  - https://chat.openai.com/share/21202e9c-e26d-4253-be7c-d39a35c4e873
