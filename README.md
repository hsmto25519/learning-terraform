# learning-terraform

## 前提

* 対象のS3がデプロイされていること
  * apc-tfstate-aws-0001
* 対象のDynamoDBがデプロイされていること
  * terraform-lock-table-01

## 使い方

### 自分用のstatefileを用意する場合

terraform.tf内のkey attributeを書き換える。
```
terraform {
  backend "s3" {
    bucket         = "apc-tfstate-aws-0001"
    key            = "terraform/tfstate"  <- これを任意の名前に書き換える
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table-01"
  }
}
```

### デプロイ例

terraformディレクトリ配下で以下コマンドを実施する。
```
# 初回/provider.tf変更時
terraform init

# AWSリソースのデプロイ
terraform plan
terraform apply

# Terraform検証後
terraform destroy
```

### CloudShellでの実行方法

```
### open cloudshell to execute commands

# install terraform
curl -O https://releases.hashicorp.com/terraform/1.9.6/terraform_1.9.6_linux_amd64.zip
unzip terraform_1.9.6_linux_amd64.zip 
sudo mv terraform /usr/local/bin/

# Clone my repository
git clone https://github.com/hsmto25519/learning-terraform.git

# Execute terraform
cd learning-terraform/terraform/
terraform init
terraform plan
terraform apply

# Check output values
terraform output -json

# Connect to the ec2 we created. (but we cant connect to it because we need an internet gateway too.)
vi private-key.pem
chmod 400 private-key.pem
publicip=<output ip>
ssh -i private-key.pem ec2-user@$publicip
```