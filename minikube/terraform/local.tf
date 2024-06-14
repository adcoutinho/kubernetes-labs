locals {
  vpc_id = "vpc-094a57f57552467cf"
  subnet_id = "subnet-08fc821134583eed0"
  region = "us-east-1"
  project = "lab-minikube"
  associate_public_ip_address = true
  instance_type = "t3.medium"
  spot = true
  block_device = {
    volume_size = 30
    volume_type = "gp3"
  }
  ports = {
    port_443 = { port = 443, protocol = "tcp", cidrs = ["186.194.105.13/32"]}
    port_8443 = { port = 8443, protocol = "tcp", cidrs = ["186.194.105.13/32"]}
    port_8080 = { port = 8080, protocol = "tcp", cidrs = ["186.194.105.13/32"]}
  }

  tags = {
    project = local.project
  }
}
