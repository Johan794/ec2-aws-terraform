resource "aws_instance" "ec2" {
  ami           = var.ami #Get the AMI ID
  instance_type = "${var.instance_type}"#"t2.micro" #Set the instance type
  #Assign the network interface
  network_interface {
    network_interface_id = var.network_interface_id #aws_network_interface.aws_nf.id
    device_index         = 0
  }
  #Tags
  tags = {
    Name = "ec2-VM"
  }
}
