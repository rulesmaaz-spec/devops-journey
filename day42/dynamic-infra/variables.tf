variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "my-app"

}

variable "instance_count" {
  default = 5
}

variable "instance_types" {
  description = "Maps of servers role to instance types"
  type        = map(string)
  default = {
    web = "t3.micro"
    #cache = "t3.micro"
  }
}

variable "ingress_rules" {
  type = list(object({
    port        = number
    cidr_blocks = list(string)
    description = string
  }))
  #default = [
  # { port = 22, cidr_blocks = ["0.0.0.0/0"], description = "SSH" },
  # { port = 80, cidr_blocks = ["0.0.0.0/0"], description = "HTTP" }
  #]
  default = [
    { port = 22, cidr_blocks = ["0.0.0.0/0"], description = "SSH" },
    { port = 80, cidr_blocks = ["0.0.0.0/0"], description = "HTTP" },
    { port = 443, cidr_blocks = ["0.0.0.0/0"], description = "HTTPS" } # New
  ]
}

