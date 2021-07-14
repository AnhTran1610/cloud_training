variable "subnets_cidr" {
  type    = list(any)
  default = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}