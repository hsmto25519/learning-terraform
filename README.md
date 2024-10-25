# learning-terraform

## 前提

* Terraformのstatefileを格納するS3がデプロイされていること
  * <your_s3_bucket>
* 排他制御を有効にするためのDynamoDBがデプロイされていること
  * <your_dynamodb_table>

## 使い方

### デプロイの準備

terraform.tf内のkey attributeを書き換える。
```
terraform {
  backend "s3" {
    bucket         = "<your_s3_bucket>"  <- これをS3の名前に書き換える
    key            = "terraform/tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
    dynamodb_table = "<your_dynamodb_table>"  <- これをDynamoDBの名前に書き換える
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

terraformでAWSリソースを作成後、EC2上にアプリをデプロイする。

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

# Connect to the ec2 we created.
vi private-key.pem
chmod 400 private-key.pem
publicip=<output ip>
ssh -i private-key.pem ec2-user@$publicip

# deploy an apps
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl status httpd

# create an html file that literally displays "hello".
sudo sh -c "echo 'hello' > /var/www/html/index.html"
# (to create the file and the ec2 target in the ALB will be 'Healthy')
```