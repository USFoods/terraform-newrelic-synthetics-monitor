provider "newrelic" {
  account_id = var.account_id
}

resource "newrelic_alert_policy" "main" {
  name                = "Browser Monitor Condition Policy"
  incident_preference = "PER_CONDITION_AND_TARGET"
}

module "main" {
  source = "../.."

  account_id = var.account_id
  enabled    = var.enabled
  name       = "Browser Monitor Condition"
  type       = "BROWSER"
  uri        = "https://www.one.newrelic.com"

  public_locations = ["US_WEST_1"]

  # Additional attributes supported by the Browser monitor
  script_language = "JAVASCRIPT"
  runtime_type    = "CHROME_BROWSER"
  runtime_version = "100"

  condition = {
    policy_id = newrelic_alert_policy.main.id
  }

  tags = {
    "App.Id"   = ["1234"]
    "App.Code" = ["EXAMPLE"]
  }
}
