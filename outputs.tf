# Output variables and files

output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "ID of the VPC."
}

output "public_subnets_ids" {
  value       = aws_subnet.public_subnets.*.id
  description = "List with the IDs of the public subnets."
}

output "private_subnets_ids" {
  value       = aws_subnet.private_subnets.*.id
  description = "List with the IDs of the private subnets."
}

output "s3_bucket_id" {
  value       = aws_s3_bucket.s3_bucket.id
  description = "ID of S3 bucket."
}

output "mwaa_environment_arn" {
  value       = aws_mwaa_environment.mwaa_environment.arn
  description = "ARN of MWAA environment."
}

output "mwaa_webserver_url" {
  value       = "https://${aws_mwaa_environment.mwaa_environment.webserver_url}"
  description = "The webserver URL of the MWAA environment."
}

output "vpn_endpoint_id" {
  value       = aws_ec2_client_vpn_endpoint.ec2_client_vpn_endpoint.id
  description = "The ID of the MWAA client VPN endpoint."
}

# Client (root) certificate of the MWAA client VPN.
resource "local_file" "vpn_client_certificate" {
  sensitive_content = aws_acm_certificate.client.certificate_body
  filename          = "mwaa-vpn-client-dev.crt"
  file_permission   = "0440"
}

# Client (root) private key of the MWAA client VPN.
resource "local_file" "vpn_client_key" {
  sensitive_content = aws_acm_certificate.client.private_key
  filename          = "mwaa-vpn-client-dev.key"
  file_permission   = "0440"
}
