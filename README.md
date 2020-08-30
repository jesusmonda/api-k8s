# Deploy api on EKS
API built with Express and MongoDB. It's deployed on AWS(EKS, Secret Manager, Route53, ALB) with TK8s, Terraform, Helm and CI/CD on AWS with CodeBuild.

### Parameters
You have to modify variables.tf file to # Deploy api on EKS
API built with Express and MongoDB. It's deployed on AWS(EKS, Secret Manager, Route53, ALB) with TK8s, Terraform, Helm and CI/CD on AWS with CodeBuild.

### Parameters
You have to modify variables.tf file to specify project_name and domain values

### Deploy

You have to create a secret manager with var.project_name_credentials name and create 2 secret key/value: github_token	and docker_token. 
1. Install providers:

    ```sh
    (/api-k8s/infra/terraform) $ mkdir -p ~/.terraform.d/plugins && \
      curl -Ls https://api.github.com/repos/gavinbunney/terraform-provider-kubectl/releases/latest \
      | jq -r ".assets[] | select(.browser_download_url | contains(\"$(uname -s | tr A-Z a-z)\")) | select(.browser_download_url | contains(\"amd64\")) | .browser_download_url" \
      | xargs -n 1 curl -Lo ~/.terraform.d/plugins/terraform-provider-kubectl.zip && \
      pushd ~/.terraform.d/plugins/ && \
      unzip ~/.terraform.d/plugins/terraform-provider-kubectl.zip -d terraform-provider-kubectl-tmp && \
      mv terraform-provider-kubectl-tmp/terraform-provider-kubectl* . && \
      chmod +x terraform-provider-kubectl* && \
      rm -rf terraform-provider-kubectl-tmp && \
      rm -rf terraform-provider-kubectl.zip && \
      popd
    ```
    ```sh
    (/api-k8s/infra/terraform) $ terraform init
    ```

2. Deploy resources:

    ```sh
    (/api-k8s/infra/terraform) $ terraform apply
    ``` project_name and domain values

### Deploy

You have to create a secret manager with var.project_name_credentials name and create 2 secret key/value: github_token	and docker_token. 
1. Install providers:

    ```sh
    (/api-k8s/infra/terraform) $ mkdir -p ~/.terraform.d/plugins && \
      curl -Ls https://api.github.com/repos/gavinbunney/terraform-provider-kubectl/releases/latest \
      | jq -r ".assets[] | select(.browser_download_url | contains(\"$(uname -s | tr A-Z a-z)\")) | select(.browser_download_url | contains(\"amd64\")) | .browser_download_url" \
      | xargs -n 1 curl -Lo ~/.terraform.d/plugins/terraform-provider-kubectl.zip && \
      pushd ~/.terraform.d/plugins/ && \
      unzip ~/.terraform.d/plugins/terraform-provider-kubectl.zip -d terraform-provider-kubectl-tmp && \
      mv terraform-provider-kubectl-tmp/terraform-provider-kubectl* . && \
      chmod +x terraform-provider-kubectl* && \
      rm -rf terraform-provider-kubectl-tmp && \
      rm -rf terraform-provider-kubectl.zip && \
      popd
    ```
    ```sh
    (/api-k8s/infra/terraform) $ terraform init
    ```

2. Deploy resources:

    ```sh
    (/api-k8s/infra/terraform) $ terraform apply
    ```
