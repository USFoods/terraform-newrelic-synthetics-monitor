locals {
  private_location_ids = concat(
    [for loc in data.newrelic_synthetics_private_location.private_location : loc.id],
    coalesce(var.private_location_ids, [])
  )
}

data "newrelic_synthetics_private_location" "private_location" {
  for_each = toset(coalesce(var.private_locations, []))

  account_id = var.account_id
  name       = each.value
}

resource "newrelic_synthetics_monitor" "this" {
  account_id = var.account_id
  status     = var.enabled ? "ENABLED" : "DISABLED"
  name       = var.name
  type       = var.type
  period     = var.period
  uri        = var.uri

  locations_private = length(local.private_location_ids) == 0 ? null : local.private_location_ids
  locations_public  = toset(var.public_locations)

  enable_screenshot_on_failure_and_script = var.enable_screenshot_on_failure_and_script
  script_language                         = var.script_language
  runtime_type                            = var.runtime_type
  runtime_type_version                    = var.runtime_version

  treat_redirect_as_failure = var.treat_redirect_as_failure
  bypass_head_request       = var.bypass_head_request
  verify_ssl                = var.verify_ssl
  validation_string         = var.validation_string
}

resource "newrelic_entity_tags" "this" {
  guid = newrelic_synthetics_monitor.this.id

  tag {
    key    = "Origin"
    values = ["Terraform"]
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key    = tag.key
      values = tag.value
    }
  }
}

module "nrql_alert_condition" {
  source  = "usfoods/nrql-alert-condition/newrelic"
  version = "1.3.0"

  count = var.condition == null ? 0 : 1

  account_id         = var.account_id
  policy_id          = var.condition.policy_id
  enabled            = var.condition.enabled && var.enabled
  name               = coalesce(var.condition.name, var.name)
  description        = coalesce(var.condition.description, "NRQL Alert Condition for Monitor: ${newrelic_synthetics_monitor.this.name}")
  runbook_url        = var.condition.runbook_url
  aggregation_method = "EVENT_TIMER"
  aggregation_delay  = null
  aggregation_timer  = 10
  aggregation_window = 60
  slide_by           = 30

  query = "FROM SyntheticCheck SELECT latest(if(result = 'FAILED', 1, 0)) WHERE entityGuid = '${newrelic_synthetics_monitor.this.id}' FACET entityGuid, monitorName, location"

  tags = merge(var.condition.tags, var.tags)

  critical = {
    operator              = "ABOVE"
    threshold             = 0
    threshold_duration    = 60
    threshold_occurrences = "ALL"
  }
}
