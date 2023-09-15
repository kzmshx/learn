# terraform/udemy-iac-with-terraform

https://www.udemy.com/course/iac-with-terraform/

## メモ

### Terraform CLI

- terraform init
  - 初期化
  - `.terraform` ディレクトリが作成される
  - `.terraform.lock.hcl` ファイルが作成される
- terraform plan
  - インフラ構築の実行計画
- terraform apply
  - インフラ構築の適用
- terraform destroy
  - インフラ環境の削除
- terraform refresh
  - tfstateの更新
- terraform state list
  - tfstateのリソース一覧
- terraform state show
  - tfstateのリソース詳細
- terraform state mv
  - tfstateのリソースの移動
- terraform state rm
  - tfstateのリソースの削除
- terraform fmt
  - コードのフォーマット
- terraform -install-autocomplete
  - オートコンプリートのインストール
- terraform -uninstall-autocomplete
  - オートコンプリートのアンインストール

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

### MacでZipをクリックで.zipを解凍したら、中身の.tarまで解凍されてしまう

- ZIPだけ解凍して解決
  ```text
  $ unzip foo.zip
  ```
