resource "hcloud_load_balancer" "lb" {
  name               = var.name
  load_balancer_type = var.type
  location           = var.location
  network_zone       = var.network_zone
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  for_each = { for target in var.targets : target.selector => target }

  type             = each.value.type
  load_balancer_id = hcloud_load_balancer.lb.id


  server_id        = each.value.type == "server_id" ? each.value.selector : null
  label_selector   = each.value.type == "label_selector" ? each.value.selector : null
  ip              = each.value.type == "ip" ? each.value.selector : null
}

resource "hcloud_load_balancer_service" "load_balancer_service" {
  for_each = { for service in var.services : service.listen_port => service}

  load_balancer_id   = hcloud_load_balancer.lb.id

  protocol           = each.value.protocol
  listen_port        = each.value.listen_port
  destination_port   = each.value.destination_port
  proxyprotocol      = each.value.proxy_protocol

  dynamic "http" {
    for_each = each.value.http == null ? toset([]) : toset([1])

    content {
      sticky_sessions = each.value.http.sticky_sessions
      cookie_name     = each.value.http.cookie_name
      cookie_lifetime = each.value.http.cookie_lifetime
      redirect_http   = each.value.http.redirect_http
    }
  }

  dynamic "health_check" {
    for_each = each.value.healthcheck == null ? toset([]) : toset([1])

    content {
      protocol                 = each.value.healthcheck.protocol
      port                     = each.value.healthcheck.port
      interval                 = each.value.healthcheck.interval
      timeout                  = each.value.healthcheck.timeout
      retries                  = each.value.healthcheck.retries

      dynamic "http" {
        for_each = each.value.healthcheck.http == null ? toset([]) : toset([1])

        content {
          domain       = each.value.healthcheck.http.domain
          path         = each.value.healthcheck.http.path
          response     = each.value.healthcheck.http.response
          tls          = each.value.healthcheck.http.tls
          status_codes = each.value.healthcheck.http.status_codes
        }
      }
    }
  }

}