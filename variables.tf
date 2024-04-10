variable "name" {
  description = "Name of the LB"
  type        = string
}

variable "domain" {
  type    = string
  default = null
  nullable = true
}

variable "type" {
  description = "Type of LB to create"
  type        = string
  default     = "lb11"
  nullable = false
}

variable "location" {
  description = "Location for the LB"
  type        = string
  default     = null
  nullable = true
}

variable "network_zone" {
  description = "Network zone for the LB"
  type        = string
  default     = "eu-central"
  nullable = true
}

variable "targets" {
  description = "List of targets to add to the LB"
  type        = list(object({
    type = string
    selector   = string
  }))
}


variable "services" {
  description = "List of services to add to the LB"
  type        = list(object({
    protocol = string
    listen_port = number
    destination_port = number
    proxy_protocol = optional(bool)
    http = object({
      sticky_sessions = bool
      cookie_name     = optional(string)
      cookie_lifetime = optional(number)
      certficates     = optional(list(string))
      redirect_http   = optional(bool)
    })
    healthcheck = optional(object({
      protocol                 = optional(string)
      port                     = optional(number)
      interval                = optional(number)
      timeout                = optional(number)
      retries               = optional(number)
      http                   = optional(object({
        domain       = optional(string)
        path         = optional(string)
        response     = optional(string)
        tls          = optional(bool)
        status_codes = optional(list(string))
      }))
    }))
  }))
  default = [
    {
      protocol = "http"
      listen_port = 80
      destination_port = 80
      proxy_protocol = false
      http = {
        sticky_sessions = false
        cookie_name     = null
        cookie_lifetime = null
        certficates     = null
        redirect_http   = false
      }
      healthcheck = null
    },
    {
      protocol = "https"
      listen_port = 443
      destination_port = 443
      proxy_protocol = false
      http = {
        sticky_sessions = false
        cookie_name     = null
        cookie_lifetime = null
        certficates     = null
        redirect_http   = false
      }
      healthcheck = null
    }
  ]
  nullable = false
}