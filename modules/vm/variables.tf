variable "ami" {
  type        = string
  description = "The ami ID to use for the instance"
}

variable "instance_type" {
  type        = string
  description = "The type of instance to start"
}

variable "network_interface_id" {
  type        = string
  description = "The ID of the network interface to attach to the instance"
}