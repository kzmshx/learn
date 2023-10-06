# batch-with-sqs-and-lambda

## 概要

Amazon SQSとAWS Lambdaを使ったバッチ処理アーキテクチャのサンプルとして、簡単な画像加工処理アーキテクチャを構築する。

入力用のS3バケットに画像ファイルをアップロードすると、イベント通知によりSQSにメッセージが送信される。Lambdaのイベントソースマッピングにより、SQSからメッセージを受け取るとLambdaが起動し、画像を加工して出力用S3バケットに保存する。

## 技術スタック

- Amazon S3
- Amazon SQS
- AWS Lambda

## ディレクトリ構成

```text
.
├── lambda/
│   ├── function.py
│   ├── requirements.txt
│   └── package/
├── scripts/
│   ├── upload.sh         # 入力用S3バケットに画像をアップロードする
│   └── download.sh       # 出力用S3バケットから処理された画像をダウンロードする
├── terraform/
│   ├── main.tf           # リソース定義
│   ├── variables.tf      # 変数定義
│   └── outputs.tf        # 出力定義
└── Makefile
```
