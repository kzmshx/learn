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
