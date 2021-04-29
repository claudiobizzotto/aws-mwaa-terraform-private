# Input variables

variable "region" {
  type        = string
  description = "AWS region where resources will be deployed."
}

variable "prefix" {
  type        = string
  description = "A prefix to use when naming resources."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public subnets' CIDR blocks."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private subnets' CIDR blocks."
}

variable "mwaa_max_workers" {
  type        = number
  description = "Maximum number of MWAA workers."
  default     = 2
}

variable "client_vpn_cidr_block" {
  type        = string
  description = "Client CIDR block for MWAA client VPN."
}

variable "vpn_acm_validity_period_in_days" {
  type        = number
  description = "Amount of days after which TLS certificates used for MWAA client VPN should expire."
  default     = 1095 # 3 years
}
