# AWS Serverless React App

A reference project to deploy a serverless, full-stack React app onto AWS with Terraform. Inspired by [this](https://www.youtube.com/watch?v=Bro0uFVDrWY) YouTube tutorial by Code Engine

A to-do list app which allows users to create, and read to-do's from DynamoDB

App URL [here](http://matlau-aws-react-serverless2.s3-website-us-east-1.amazonaws.com/)

![AWS Architecture](images/aws_react_serverless2.JPG)

## Pre-requisite

Make sure you have installed [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli), [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html#cliv2-mac-prereq), and configured a `default` AWS CLI profile (see doc [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html#cli-configure-quickstart-profiles))

```bash
terraform -help # prints Terraform options
which aws # prints /usr/local/bin/aws
aws --version # prints aws-cli/2.0.36 Python/3.7.4 Darwin/18.7.0 botocore/2.0.0
aws configure # configure your AWS CLI profile
```

## Configuration

Create a Github project, and generate a personal access token (see doc [here](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token))

Populate `deploy/02-variables.tf`

```bash
variable "github_token" {}

variable "github_username" {
  default = "your_github_username"
}

variable "github_project_name" {
  default = "your_github_project_name"
}

variable "bucket_name" {
  default = "your_unique_s3_bucket_name"
}
```

## Deploy

```bash
cd deploy # change to deploy directory
terraform init # initialises Terraform
terraform apply # deploys AWS stack
terraform destroy # destroys AWS stack
```

When prompted for `github_token`, provide the value and hit Return

To add a new Lambda function i.e. `updateTodo.js`, navigate to `deploy/lambdas` and run `zip updateTodo.zip updateTodo.js` to generate the zip file for the Lambda function

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
