resource "google_compute_address" "harbor_lb" {
  name = "${var.env_name}-harbor-lb"
}

resource "google_compute_forwarding_rule" "harbor_lb_80" {
  name        = "${var.env_name}-harbor-lb-80"
  ip_address  = google_compute_address.harbor_lb.address
  target      = google_compute_target_pool.harbor_lb.self_link
  port_range  = "80"
  ip_protocol = "TCP"
}

resource "google_compute_forwarding_rule" "harbor_lb_443" {
  name        = "${var.env_name}-harbor-lb-443"
  ip_address  = google_compute_address.harbor_lb.address
  target      = google_compute_target_pool.harbor_lb.self_link
  port_range  = "443"
  ip_protocol = "TCP"
}

resource "google_compute_target_pool" "harbor_lb" {
  name = "${var.env_name}-harbor-lb"
}

resource "google_dns_record_set" "harbor_dns" {
  name = "harbor.${module.pave.base_domain}."
  type = "A"
  ttl  = 300

  managed_zone = module.pave.dns_zone_name

  rrdatas = [google_compute_address.harbor_lb.address]
}