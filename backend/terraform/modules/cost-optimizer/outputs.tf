output "lambda_function_arn" {
  description = "ARN de la Lambda de gestion des instances"
  value       = aws_lambda_function.manage_instances.arn
}
