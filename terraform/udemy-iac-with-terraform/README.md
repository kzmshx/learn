# terraform/udemy-iac-with-terraform

https://www.udemy.com/course/iac-with-terraform/

## 知識メモ

### Terraform CLI

| コマンド                    | 概要                                                                   |
|-------------------------|----------------------------------------------------------------------|
| init                    | 初期化<br>`.terraform` ディレクトリが作成される<br>`.terraform.lock.hcl` ファイルが作成される |
| plan                    | インフラ構築の実行計画                                                          |
| apply                   | インフラ構築の適用                                                            |
| destroy                 | インフラ環境の削除                                                            |
| refresh                 | tfstateの更新                                                           |
| state list              | tfstateのリソース一覧                                                       |
| state show              | tfstateのリソース詳細                                                       |
| state mv                | tfstateのリソースの移動                                                      |
| state rm                | tfstateのリソースの削除                                                      |
| fmt                     | コードのフォーマット                                                           |
| graph                   | インフラ構築の依存関係グラフの出力                                                    |
| -install-autocomplete   | オートコンプリートのインストール                                                     |
| -uninstall-autocomplete | オートコンプリートのアンインストール                                                   |

### HCL2 ブロックタイプ

| ブロックタイプ   | 概要                                    |
|-----------|---------------------------------------|
| locals    | 外部から変更不能なローカル変数。プライベートな変数。            |
| variable  | 外部から変更可能な変数。コマンドオプションやファイル指定により上書きできる |
| terraform | Terraformの設定                          |
| provider  | プロバイダ                                 |
| data      | Terraform管理対象外のリソース                   |
| resource  | Terraformの管理対象のリソース                   |
| output    | 外部から参照できるようにする値                       |

### HCL2 変数の上書き

環境変数 < 変数ファイル < コマンドライン引数

コマンドライン引数が最優先。

### HCL2 リソースの参照

リソース参照の記述

```text
<BLOCK_TYPE>.<LABEL_1>.<LABEL_2>
```

```terraform
resource "aws_vpc" "vpc" {
  # ...
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "192.168.1.0/24"
  map_public_ip_on_launch = true
}
```

### HCL2 組み込み関数

[Functions - Configuration Language | Terraform](https://developer.hashicorp.com/terraform/language/functions)

```
$ terraform console
> floor(3.14)
3
> substr("abcdef", 2, 3)
cde
> format("Hello %s", "Terraform")
Hello Terraform
```

### HCL2 ファイル分割

- `terraform apply` はカレントディレクトリ内の `.tf` ファイルをすべて読み込む。
- `terraform apply` はディレクトリを再帰的には読み込まない。
- 基本構成は `main.tf` と `terraform.tfvars` の2ファイル。
  ```text
  .
  ├── main.tf
  └── terraform.tfvars
  ```
- `main.tf` が大きくなったら、ファイルを分割する。
  ```text
  .
  ├── main.tf
  ├── terraform.tfvars
  ├── network.tf
  └── database.tf
  ```

### HCL2 メタ引数

#### depends_on

Terraformが自動的に依存関係を解決できない場合に明示的に依存関係を定義する。

#### count

指定した数の複数リソースを作成する。

- `count.index` でインデックスを参照できる。

#### for

リスト型（list, map, set）を異なるリスト型（list, map）に変換する。

PythonのList Comprehensionと同じようなもの。

- list to list: `[for s in var.list: upper(s)]`
- list to map: `{for s in var.list: s => upper(s)}`
- map to list: `[for k, v in var.map: upper(v)]`
- map to map: `{for k, v in var.map: k => upper(v)}`
- set to list: `[for s in var.set: upper(s)]`
- filtering: `[for s in var.list: s if s != "foo"]`
  - `else` や `elif` はない。
- etc.

#### for_each

指定したmapまたはsetを展開して、複数のリソースを作成する。

- listは展開できないため、mapまたはsetに変換する必要がある。（`toset()` または `tomap()`）
- `each.key` でキーを参照できる。
- `each.value` で値を参照できる。

#### lifecycle

リソースの作成や削除のタイミングを制御する。

- `create_before_destroy = true` でリソースの削除前に作成する。
- `prevent_destroy = true` でリソースの削除を禁止する。
- `ignore_changes = [ <ATTRIBUTE> ]` で指定した属性の変更を無視する。

Terraformのインフラ操作には以下の4つのタイミングがある。

- create: リソースの作成
- destroy: リソースの削除
- update: リソースの更新
- destroy & recreate: リソースの削除と再作成（リソースの更新ができない場合）

lifecycleメタ引数はこのライフサイクル管理をより細かく制御するためのもの。

### Terraform のドキュメント構造

- HCL2
  - 言語本体のドキュメント
  - → Docs > Language
- Provider
  - コードで利用するProviderのドキュメント
  - → Terraform Registry
- CLI
  - 実装したコードの実行方法のドキュメント
  - → Docs > CLI

### gitignore.io

https://www.toptal.com/developers/gitignore

色んなソフトウェアの開発向けに使える `.gitignore` を生成してくれるサイト。

### RDSのパスワード管理

- あとからパスワード変更
  - メリット
    - パスワードをS3に保存tfstateにパスワードが含まれない
  - デメリット
    - Terraformでパスワードを管理できない
- 運用回避（アクセス権限制御）
  - メリット
    - Terraformでパスワードを管理できる
  - デメリット
    - 人に対する権限管理の管理が必要

### AWS CLIでAMI検索

```text
$ aws ec2 describe-images
    [--image-ids <value>]
    [--owners <value>]
    [--filters <value>]
```

### OS選択、ミドルウェアの設定のコード化

- Packerを使って実現可能
  - https://www.packer.io/
  - https://www.udemy.com/course/iac-by-packer-aws/

### Providerを複数利用する

aliasを使うことで、複数のProviderを利用できる。

```terraform
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "tokyo"
  region = "ap-northeast-1"
}

resource "aws_instance" "web" {
  provider = aws.tokyo # aliasを指定して、ap-northeast-1のProviderを利用する

  # ...
}
```

### S3のパブリックアクセスブロックがデフォルトで有効になった（2023−04）件の対応

- https://blog.serverworks.co.jp/s3_bucket_public_access_block_202204
- https://zenn.dev/hige/articles/01b69444ccaa3d

## 作業メモ

### MacでZipをクリックで.zipを解凍したら、中身の.tarまで解凍されてしまう

→ ZIPだけ解凍して解決

```shell
unzip foo.zip
```

### EC2のAPサーバーのセットアップ

```shell
# ------------------------------
# In Local
# ------------------------------
IP_ADDRESS=<IP_ADDRESS>

scp -i ./src/tastylog-dev-keypair.pem ./src/tastylog-mw-all-1.0.0.tar.gz ec2-user@${IP_ADDRESS}:/home/ec2-user
scp -i ./src/tastylog-dev-keypair.pem ./src/tastylog-app-1.8.1.tar.gz ec2-user@${IP_ADDRESS}:/home/ec2-user
ssh -i ./src/tastylog-dev-keypair.pem ec2-user@${IP_ADDRESS}
```

```shell
# ------------------------------
# In App Server
# ------------------------------
pwd # /home/ec2-user
sudo yum update -y

# Setup middleware
mkdir middleware
tar -zxvf tastylog-mw-all-1.0.0.tar.gz -C middleware

cd middleware
sudo sh ./install.sh
cd ../

# Start web server
mkdir tastylog
tar -zxvf tastylog-app-1.8.1.tar.gz -C tastylog

sudo mv tastylog /opt
sudo systemctl enable tastylog
sudo systemctl start tastylog
sudo systemctl status tastylog

# Clean up
rm -rf \
  middleware \
  tastylog-mw-all-1.0.0.tar.gz \
  tastylog-app-1.8.1.tar.gz
```

## Terraformについてさらに学ぶ

- [Terraform面接質問集を作ってみた - Qiita](https://qiita.com/to-fmak/items/9f3c00d478296f1ed9d2)
