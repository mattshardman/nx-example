# root rest api
resource "aws_api_gateway_rest_api" "nx_api" {
  name = "nx_apollo"
}

# lambda integration
resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.nx_api.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method

   integration_http_method = "POST"
   # causes api gateway to call the AWS lambda api to invoke the lambda
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.nx_apollo_lambda.invoke_arn
}

# allows api gatway to match an empty path at the root of the api
resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.nx_api.id
   resource_id   = aws_api_gateway_rest_api.nx_api.root_resource_id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = aws_api_gateway_rest_api.nx_api.id
   resource_id = aws_api_gateway_method.proxy_root.resource_id
   http_method = aws_api_gateway_method.proxy_root.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.nx_apollo_lambda.invoke_arn
}

# activate deployment and expose api to a url
resource "aws_api_gateway_deployment" "nx_apollo" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.nx_api.id
   stage_name  = "test"
}

# prints api url
output "base_url" {
  value = aws_api_gateway_deployment.nx_apollo.invoke_url
}