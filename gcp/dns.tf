resource "google_dns_record_set" "pks_api_dns" {
  name = "api.pks.${module.pave.base_domain}."
  type = "A"
  ttl  = 300

  managed_zone = module.pave.dns_zone_name

  rrdatas = [google_compute_address.pks_api_lb.address]
}