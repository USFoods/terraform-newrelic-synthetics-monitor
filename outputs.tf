output "id" {
  description = "The ID of the Synthetics script monitor"
  value       = newrelic_synthetics_monitor.this.id
}

output "status" {
  description = "The run state of the monitor"
  value       = newrelic_synthetics_monitor.this.status
}

output "name" {
  description = "The name for the monitor"
  value       = newrelic_synthetics_monitor.this.name
}

output "type" {
  description = "The plaintext representing the monitor script"
  value       = newrelic_synthetics_monitor.this.type
}

output "private_locations" {
  description = "The private locations the monitor is running from"
  value       = var.private_locations
}

output "public_locations" {
  description = "The public locations the monitor is running from"
  value       = newrelic_synthetics_monitor.this.locations_public
}

output "period" {
  description = "The interval at which this monitor is run"
  value       = newrelic_synthetics_monitor.this.period
}

output "script_language" {
  description = "The programing language that executes the script"
  value       = newrelic_synthetics_monitor.this.script_language
}

output "runtime_type" {
  description = "The runtime that the monitor uses to run jobs"
  value       = newrelic_synthetics_monitor.this.runtime_type
}

output "runtime_version" {
  description = "The specific version of the runtime type selected"
  value       = newrelic_synthetics_monitor.this.runtime_type_version
}

output "treat_redirect_as_failure" {
  description = "Categorize redirects during a monitor job as a failure"
  value       = newrelic_synthetics_monitor.this.treat_redirect_as_failure
}

output "bypass_head_request" {
  description = "Monitor should skip default HEAD request and instead use GET verb in check"
  value       = newrelic_synthetics_monitor.this.bypass_head_request
}

output "verify_ssl" {
  description = "Monitor should verify SSL certificates"
  value       = newrelic_synthetics_monitor.this.verify_ssl
}

output "validation_string" {
  description = "The string to validate the response"
  value       = newrelic_synthetics_monitor.this.validation_string
}

output "tags" {
  description = "The tags associated with the synthetics script monitor"
  value       = { for t in newrelic_entity_tags.this.tag : t.key => join(",", toset(t.values)) }
}

output "condition_policy_id" {
  description = "The ID of the policy where this condition is used"
  value       = try(module.nrql_alert_condition[0].policy_id, "")
}

output "condition_enabled" {
  description = "Whether the alert condition is enabled"
  value       = try(module.nrql_alert_condition[0].enabled, "")
}

output "condition_name" {
  description = "The title of the condition"
  value       = try(module.nrql_alert_condition[0].name, "")
}

output "condition_description" {
  description = "The description of the NRQL alert condition"
  value       = try(module.nrql_alert_condition[0].description, "")
}

output "condition_runbook_url" {
  description = "Runbook URL to display in notifications"
  value       = try(module.nrql_alert_condition[0].runbook_url, "")
}

output "condition_tags" {
  description = "The tags associated with the alert condition"
  value       = try(module.nrql_alert_condition[0].tags, "")
}

output "condition_critical_operator" {
  description = "The operator used when evaluating the critical threshold"
  value       = try(module.nrql_alert_condition[0].critical_operator, "")
}

output "condition_critical_threshold" {
  description = "The value which will trigger a critical incident"
  value       = try(module.nrql_alert_condition[0].critical_threshold, "")
}

output "condition_critical_threshold_duration" {
  description = "The duration, in seconds, that the threshold must violate in order to create an incident"
  value       = try(module.nrql_alert_condition[0].critical_threshold_duration, "")
}

output "condition_critical_threshold_occurrences" {
  description = "The criteria for how many data points must be in violation for the specified threshold duration"
  value       = try(module.nrql_alert_condition[0].critical_threshold_occurrences, "")
}
