  variable "instance_name_nginx" {
    description = "name for instance nginx"
    type        = string
    default     = "nginx"
}

  variable "instance_name_apache" {
    description = "name for instance apache2"
    type        = string
    default     = "apache"
}

variable "port_nginx" {
  description = "port of nginx"
  type        = number
  default     = 80
}

variable "port_apache2" {
  description = "port of apache2"
  type        = number
  default     = 80
}

variable "puerto_lb" {
  description = "port of LB"
  type        = number
  default     = 80
}

variable "instance_type" {
  description = "type of instances EC2"
  type        = string
  default     = "t2.micro"
}

variable "ami" {
  description = "image amazon linux"
  type = string
  default = "ami-0895310529c333a0c"
}
