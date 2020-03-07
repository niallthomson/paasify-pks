resource "google_compute_firewall" "pks_api_lb" {
  name    = "${var.env_name}-pks-api-lb-firewall"
  network = module.pave.network_name

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["8443", "9021"]
  }

  target_tags = ["${var.env_name}-pks-api-lb"]
}