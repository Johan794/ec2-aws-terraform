# EC2 aws with terraform 
In this repo you will see how to deploy an EC2 instance using terraform. <br>

## Configuration 👓

In order to use aws instead of azure you need to folow these steps: 
 - Install , if u dont have it yet,   aws CLI and run 
 ```bash
    aws configure
```
 then provide a new public and secret access key

- Set your provider to aws, and set your region, you can provide that configuration unsing your tfvars.

- Use this code to get the image of an ubuntu VM
 
 ```bash
   data "aws_ami" "ubuntu" {
        most_recent = true

        filter {
            name   = "name"
            values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
        }

        filter {
            name   = "virtualization-type"
            values = ["hvm"]
        }

        owners = ["099720109477"] # Canonical
}
```

## Run the terraform commads ⭐️

 ```bash
    terraform init
```

 ```bash
    terraform plan
```
 ```bash
    terraform apply 
```
