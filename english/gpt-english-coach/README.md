# english/gpt-english-coach

## 機能

日本語文と英語文を入力すると、英作文のアドバイスを出力してくれる。

```text
$ gpt-english-coach
日本語: 渋谷駅まで30分程度ウォーキングした
英作文: I had a walking to Shibuya station approximately for 30 minutes.
アドバイス:
### 文法の間違い
- had a walking → walked

### 単語の意味やニュアンスの不適切な箇所
- approximately → about

### 修正例
I walked to Shibuya station for about 30 minutes.

### 他の表現例
- I strolled to Shibuya station for approximately 30 minutes.
- I took a leisurely walk to Shibuya station, which took about 30 minutes.
- It took me around 30 minutes to walk to Shibuya station.

### 長い日本語文
渋谷駅まで30分程度ウォーキングした後、友達と会ってランチを食べました。その後、ショッピングをして帰りました。

### 長い英作文
After walking to Shibuya station for about 30 minutes, I met up with a friend and had lunch. Then, we went shopping before heading back.
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
