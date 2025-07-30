variable "compute_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "data_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.103.0/24", "10.0.104.0/24"]
}
