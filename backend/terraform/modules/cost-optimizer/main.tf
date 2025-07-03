resource "aws_cloudwatch_event_rule" "stop_nonprod" {
  name                = "stop-nonprod-instances"
  schedule_expression = "cron(0 20 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_rule" "start_nonprod" {
  name                = "start-nonprod-instances"
  schedule_expression = "cron(0 4 ? * MON-FRI *)"
}

resource "aws_lambda_function" "manage_instances" {
  filename         = "manage_instances.zip"
  function_name    = "rcvo-manage-instances"
  handler          = "handler.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("manage_instances.zip")
}

resource "aws_cloudwatch_event_target" "stop_target" {
  rule      = aws_cloudwatch_event_rule.stop_nonprod.name
  target_id = "stopLambda"
  arn       = aws_lambda_function.manage_instances.arn
  input     = jsonencode({ action = "stop", tags = var.instance_tags_to_keep })
}

resource "aws_cloudwatch_event_target" "start_target" {
  rule      = aws_cloudwatch_event_rule.start_nonprod.name
  target_id = "startLambda"
  arn       = aws_lambda_function.manage_instances.arn
  input     = jsonencode({ action = "start", tags = var.instance_tags_to_keep })
}

resource "aws_iam_role" "lambda_exec" {
  name               = "rcvo-manage-instances-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "rcvo-manage-instances-policy"
  role   = aws_iam_role.lambda_exec.id
  policy = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_instance" "rcvo_nat" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = "t3.nano"
  subnet_id                   = var.private_subnet_id
  associate_public_ip_address = false
  source_dest_check           = false
  tags = { Name = "Rcvo-NAT-Instance" }
}

resource "aws_eip" "rcvo_nat_eip" {
  instance = aws_instance.rcvo_nat.id
  vpc      = true
}
