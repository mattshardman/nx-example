# zip file for lambda
data "archive_file" "nx_apollo_lambda" {
  type        = "zip"
  output_path = "${path.module}/../apps/api/dist/nx_apollo_lambda.zip"
  source_dir  = "${path.module}/../apps/api/dist/lambda"
}

# zip file for lambda layer
data "archive_file" "nx_apollo_lambda_layer" {
  type        = "zip"
  output_path = "${path.module}/../apps/api/dist/nx_apollo_lambda_layer.zip"
  source_dir  = "${path.module}/../apps/api/dist/layer"
}

// layer creation
resource "aws_lambda_layer_version" "nx_apollo_lambda_layer" {
  filename   = data.archive_file.nx_apollo_lambda_layer.output_path
  layer_name = "nx-apollo-lambda-layer" 
  source_code_hash = data.archive_file.nx_apollo_lambda_layer.output_base64sha256
  compatible_runtimes = [ "nodejs14.x" ]
}

# add iam role
resource "aws_iam_role" "nx_iam_for_lambda" {
  name = "nx_iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# function
resource "aws_lambda_function" "nx_apollo_lambda" {
  function_name = "nx-apollo-lambda"
  filename      = data.archive_file.nx_apollo_lambda.output_path
  role          = aws_iam_role.nx_iam_for_lambda.arn
  handler       = "index.handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.nx_apollo_lambda.output_base64sha256

  runtime = "nodejs14.x"

  # link layer
  layers = [ aws_lambda_layer_version.nx_apollo_lambda_layer.arn ]

  environment {
    variables = {
      foo = "bar"
    }
  }
}

// all invoming requests will match this resporse (both path and method)
resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.nx_api.id
   parent_id   = aws_api_gateway_rest_api.nx_api.root_resource_id
   path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
   rest_api_id   = aws_api_gateway_rest_api.nx_api.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

# api gateway permission to invoke lambda
resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.nx_apollo_lambda.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.nx_api.execution_arn}/*/*"
}