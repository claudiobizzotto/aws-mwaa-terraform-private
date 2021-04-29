# Terraform AWS MWAA Quick Start With Private Web Server

Quick start tutorial for Amazon Managed Workflows for Apache Airflow (MWAA) with Terraform. This is an adaptation of the official [AWS quick start](https://docs.aws.amazon.com/mwaa/latest/userguide/quick-start.html) (with CloudFormation), with the main difference that the Airflow web server sits in a private network (`webserver_access_mode = "PRIVATE_ONLY"`). A client VPN is added so that the Airflow web server can still be accessed by humans, as described in [_Tutorial: Configuring private network access using an AWS Client VPN_](https://docs.aws.amazon.com/mwaa/latest/userguide/tutorials-private-network-vpn-client.html).

For a vanilla MWAA deployment (with `webserver_access_mode = "PUBLIC_ONLY"`), which is quite simpler if you're just interested in playing around with Airflow on AWS, check [aws-mwaa-terraform](https://github.com/claudiobizzotto/aws-mwaa-terraform).

## Variables

Below is an example `terraform.tfvars` file that you can use in your deployments.

**Note on the VPC CIDR block**: AWS requires that the CIDR block for the VPN clients be at least `/22` in size, so your VPC CIDR block needs to be larger than that (`/21` or larger).

> The IP address range cannot overlap with the target network or any of the routes that will be associated with the Client VPN endpoint. The client CIDR range must have a block size that is between /12 and /22 and not overlap with VPC CIDR or any other route in the route table. (From [_Getting started with Client VPN_](https://docs.aws.amazon.com/vpn/latest/clientvpn-admin/cvpn-getting-started.html))

```ini
# terraform.tfvars

region   = "us-east-1"
prefix   = "my-mwaa"
vpc_cidr = "10.192.0.0/16"
public_subnet_cidrs = [
  "10.192.10.0/24",
  "10.192.11.0/24"
]
private_subnet_cidrs = [
  "10.192.20.0/24",
  "10.192.21.0/24"
]
mwaa_max_workers                = 2
client_vpn_cidr_block           = "10.192.0.0/22" # From 10.192.0.1 to 10.192.3.254
vpn_acm_validity_period_in_days = 1095 # 3 years
```

## DAGs

There's a test DAG file inside the local [`dags` directory](./dags), which was taken from the official tutorial for [Apache Airflow v1.10.12](https://airflow.apache.org/docs/apache-airflow/1.10.12/tutorial.html#example-pipeline-definition). You can place as many DAG files inside that directory as you want and Terraform will pick them up and upload them to S3.

## Deploy

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
```

## Access Airflow Web Server

In order to access the private Airflow web server, you need to generate a VPN config file for your VPN client. You can use the [`generate-ovpn.sh`](./generate-ovpn.sh) script for that:

```bash
./generate-ovpn.sh
```

That script should generate an `mwaa.ovpn` file that you can then use in your VPN client. If you use the OpenVPN CLI client, for example, you can start a session like this:

```bash
openvpn --config mwaa.ovpn
```

Once connected to the AWS client VPN, navigate to the MWAA web server URL from your browser and access the Airflow web UI from there.

## Destroy

```bash
terraform destroy
```
