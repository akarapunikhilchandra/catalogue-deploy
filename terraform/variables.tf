variable "project_name" {
  default = "roboshop"
}
variable "common_tags" {
  default = {
    Project = "roboshop"
    component = "catalogue"
    Environment = "DEV"
    Terraform = "true"
  }
}

variable "env" {
  default = "dev"
}

variable "app_version" {
  default = "1.5.0"
}

variable "domain_name" {
  default = "joindevops.cloud"
}