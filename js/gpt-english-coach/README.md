# gpt-english-coach

## 機能

日本語文と英語文を入力すると、英作文のアドバイスを出力してくれる。

```text
$ gpt-english-coach -h
   ____ ____ _____   _____             _ _     _        ____                 _
  / ___|  _ \_   _| | ____|_ __   __ _| (_)___| |__    / ___|___   __ _  ___| |__
 | |  _| |_) || |   |  _| | '_ \ / _` | | / __| '_ \  | |   / _ \ / _` |/ __| '_ \
 | |_| |  __/ | |   | |___| | | | (_| | | \__ \ | | | | |__| (_) | (_| | (__| | | |
  \____|_|    |_|   |_____|_| |_|\__, |_|_|___/_| |_|  \____\___/ \__,_|\___|_| |_|
                                 |___/

Usage: gpt-english-coach [options] [japanese] [english]

Arguments:
  japanese       日本語文
  english        英作文

Options:
  -V, --version  output the version number
  -h, --help     display help for command
```

```text
$ gpt-english-coach
日本語: 渋谷駅まで30分程度ウォーキングした
英作文: I had a walking to Shibuya station approximately for 30 minutes.
アドバイス:
### 文法の間違い
- had a walking
  - 理由: "had"は"walk"という動詞とは合わない
  - 適切な表現: "walked"

### 単語の意味やニュアンスの不適切な箇所
- approximately
  - 理由: "approximately"は正確な時間を表すのには適切ではない
  - 適切な表現: "about" or "around"

### 修正例
I walked to Shibuya station for about 30 minutes.

### 他の表現例
- I took a 30-minute walk to Shibuya station.
- It took me approximately 30 minutes to walk to Shibuya station.
- I spent around 30 minutes walking to Shibuya station.

### 発展
日本語: 渋谷駅まで30分程度ウォーキングした。その後、友達と会ってランチを食べた。
英作文: I walked to Shibuya station for about 30 minutes. After that, I met up with a friend and had lunch.
```

## 開発

- インストール
  ```shell
  bun install
  ```
- 実行
  ```shell
  bun run index.ts
  ```
- ビルド
  ```shell
  bun run build
  ```
