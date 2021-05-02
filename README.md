# Terraform AWS MWAA Quick Start With Private Web Server

Quick start tutorial for Amazon Managed Workflows for Apache Airflow (MWAA) with Terraform. This is an adaptation of the official [AWS quick start](https://docs.aws.amazon.com/mwaa/latest/userguide/quick-start.html) (with CloudFormation), with the main difference that the Airflow web server sits in a private network (`webserver_access_mode = "PRIVATE_ONLY"`) managed by AWS. A client VPN is added so that the Airflow web server can still be accessed by humans, as described in [_Tutorial: Configuring private network access using an AWS Client VPN_](https://docs.aws.amazon.com/mwaa/latest/userguide/tutorials-private-network-vpn-client.html).

For a vanilla MWAA deployment (with `webserver_access_mode = "PUBLIC_ONLY"`), which is quite simpler if you're just interested in playing around with Airflow on AWS, check [aws-mwaa-terraform](https://github.com/claudiobizzotto/aws-mwaa-terraform).

## Variables

Below is an example `terraform.tfvars` file that you can use in your deployments.

**About the client VPN CIDR block**: AWS requires that the CIDR block for the client VPN be at least `/22` in size, but that doesn't mean that the CIDR block for the client VPN needs to be carved out of the CIDR block for the VPC. (The CIDR block for the client VPN is just the DHCP range that will be given to the VPN clients coming in.)

```ini
# terraform.tfvars

region   = "us-east-1"
prefix   = "my-mwaa"
vpc_cidr = "10.44.22.0/24"
public_subnet_cidrs = [
  "10.44.22.0/28",
  "10.44.22.16/28",
]
private_subnet_cidrs = [
  "10.44.22.32/27",
  "10.44.22.64/27",
]
mwaa_max_workers                = 2
client_vpn_cidr_block           = "10.0.0.0/22"
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
