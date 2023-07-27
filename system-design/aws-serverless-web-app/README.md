# aws-serverless-web-app

## 資料

[AWS Lambda、Amazon API Gateway、AWS Amplify、Amazon DynamoDB、および Amazon Cognito を使用してサーバーレスウェブアプリケーションを構築する](https://aws.amazon.com/jp/getting-started/hands-on/build-serverless-web-app-lambda-apigateway-s3-dynamodb-cognito/)

## 要素

- AWS Amplifyによる静的ウェブホスティング
- Amazon Cognitoによるユーザー認証・管理
- Amazon API Gateway / AWS Lambda / Amazon DynamoDBによるサーバーレスなREST API

## ログ

### IAMユーザーとGit認証情報をセットアップ

[Step 3: Create Git credentials for HTTPS connections to CodeCommit | Setup for HTTPS users using Git credentials | AWS CodeCommit](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-gc.html#setting-up-gc-iam)

### 静的ウェブサイトをダウンロード

```shell
mkdir ./site
```

```shell
aws s3 cp s3://wildrydes-us-east-1/WebApplication/1_StaticWebHosting/website/ ./site --recursive
```

### 静的ウェブサイトをデプロイ

> 差分ベースのフロントエンドのビルドとデプロイを有効または無効にする
> https://docs.aws.amazon.com/ja_jp/amplify/latest/userguide/build-settings.html#enable-diff-deploy

差分ベースのデプロイをするための環境変数がデフォルトで `false` になっていたので `true` に変更。

### Amazon Cognitoのユーザープールをセットアップ

メッセージ配信設定で `FROM email address` に設定できるemail address identityがなかったので作成。

- [Creating and verifying identities in Amazon SES > Verifying an email address identity | Amazon SES](https://docs.aws.amazon.com/ses/latest/dg/creating-identities.html#just-verify-email-proc)
- [Creating and verifying identities in Amazon SES > Creating an email address identity | Amazon SES](https://docs.aws.amazon.com/ses/latest/dg/creating-identities.html#verify-email-addresses-procedure)
- [Using configuration sets in Amazon SES | Amazon SES](https://docs.aws.amazon.com/ses/latest/dg/using-configuration-sets.html)
  - デフォルトの設定で作成
- [Creating configuration sets in SES | Amazon SES](https://docs.aws.amazon.com/ses/latest/dg/creating-configuration-sets.html)
  - デフォルトの設定で作成

## 感想

- AWS Amplifyによる静的ウェブホスティング
  - ハンズオンの内容から外れてGitHubリポジトリからのデプロイとモノレポを試してみたが両方ともめっちゃ簡単
  - [Render](https://render.com/)のほうがデプロイは速い
  - コンソールでやったAmplifyの設定をコード化してリポジトリ内に置くにはどうすればいいんだろう
- Amazon Cognitoによるユーザー認証・管理
  - 前にやってみたときはユーザー登録の確認まで行けなかった気がするが今回は行けた
  - Verified IdentityのEmailでのサインイン、それ以外でのEmailでのサインインからのコンソールでの確認、両方できた
- このハンズオンのインフラ構築全体をコード化してコマンド操作でアプリケーションを再現できるようにしたい
