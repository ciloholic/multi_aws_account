# AWS OrganizationsのOU構成

## 参考にしたOU構成

[Production starter organization](https://docs.aws.amazon.com/whitepapers/latest/organizing-your-aws-environment/production-starter-organization.html)

## 基本構成

- Root
  - [Account]Management
  - [OU]Core
    - [Account]Log-Archive(省略)
    - [Account]Security
    - [Account]Jump
  - [OU]Workloads
    - [Account]Workload-a
    - [Account]Workload-b
    - [Account]Workload-c

# tfstate

各AWSアカウントのS3にtfstate用のバケットを用意する。  
S3バケット名の末尾にランダム文字列を追加して重複しないようにしている。

## AWSアカウント(Management)

```
$ aws-vault exec management -- aws s3api create-bucket \
  --bucket tfstate-me8aelie \
  --region ap-northeast-1 \
  --create-bucket-configuration \
  LocationConstraint=ap-northeast-1
```

## AWSアカウント(Jump)

```
$ aws-vault exec jump -- aws s3api create-bucket \
  --bucket tfstate-chiehia3 \
  --region ap-northeast-1 \
  --create-bucket-configuration \
  LocationConstraint=ap-northeast-1
```

## AWSアカウント(Security)

```
$ aws-vault exec security -- aws s3api create-bucket \
  --bucket tfstate-vue7roht \
  --region ap-northeast-1 \
  --create-bucket-configuration \
  LocationConstraint=ap-northeast-1
```

## AWSアカウント(Workload-a)

```
$ aws-vault exec workload-a -- aws s3api create-bucket \
  --bucket tfstate-ahno1ded \
  --region ap-northeast-1 \
  --create-bucket-configuration \
  LocationConstraint=ap-northeast-1
```

# AWSアカウント作成後の対応

## rootアカウントのMFA有効化

初期パスワードが発行されてない為、パスワードをリセットしてからMFAを有効化する。

## 不要なリソースの削除

下記URLのスクリプトを参考にデフォルトVPC、サブネット、IGWを削除する。

https://dev.classmethod.jp/articles/delete-default-vpcs-by-cloudshell/

```zsh
aws-vault exec *** -- aws --output text ec2 describe-regions --query "Regions[].[RegionName]" | while read region; do
  aws-vault exec *** -- aws --region ${region} --output text ec2 describe-vpcs --query "Vpcs[?IsDefault].[VpcId]" | while read vpc; do
    echo "# deleting vpc: ${vpc} in ${region}"
   
    ### IGW
    aws-vault exec *** -- aws --region ${region} --output text ec2 describe-internet-gateways --filters Name=attachment.vpc-id,Values=${vpc} --query "InternetGateways[].[InternetGatewayId]" | while read igw; do
      echo "## deleting igw: ${igw} in ${vpc}, ${region}"
      echo "--> detatching"
      aws-vault exec *** -- aws --region ${region} --output json ec2 detach-internet-gateway --internet-gateway-id ${igw} --vpc-id ${vpc}
      echo "--> deleteing"
      aws-vault exec *** -- aws --region ${region} --output json ec2 delete-internet-gateway --internet-gateway-id ${igw}
    done
   
    ### Subnet
    aws-vault exec *** -- aws --region ${region} --output text ec2 describe-subnets  --filters Name=vpc-id,Values=${vpc} --query "Subnets[].[SubnetId]" | while read subnet; do
      echo "## deleting subnet: ${subnet} in ${vpc}, ${region}"
      aws-vault exec *** -- aws --region ${region} --output json ec2 delete-subnet --subnet-id ${subnet}
    done
   
    ### VPC
    echo "## finally, deleting vpc: ${vpc} in ${region}"
    aws-vault exec *** -- aws --region ${region} --output json ec2 delete-vpc --vpc-id ${vpc}
  done
done
```
