resource "google_compute_address" "pks_api_lb" {
  name = "${var.env_name}-pks-api-lb"
}

resource "google_compute_forwarding_rule" "pks_api_lb_9021" {
  name        = "${var.env_name}-pks-api-lb-9021"
  ip_address  = google_compute_address.pks_api_lb.address
  target      = google_compute_target_pool.pks_api_lb.self_link
  port_range  = "9021"
  ip_protocol = "TCP"
}

resource "google_compute_forwarding_rule" "pks_api_lb_8443" {
  name        = "${var.env_name}-pks-api-lb-8443"
  ip_address  = google_compute_address.pks_api_lb.address
  target      = google_compute_target_pool.pks_api_lb.self_link
  port_range  = "8443"
  ip_protocol = "TCP"
}

resource "google_compute_target_pool" "pks_api_lb" {
  name = "${var.env_name}-pks-api-lb"
}