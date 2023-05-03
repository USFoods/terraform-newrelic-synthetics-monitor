terraform {
  required_version = ">=1.3"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~>3.13.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "newrelic" {
  account_id = var.account_id
}

resource "newrelic_alert_policy" "main" {
  name                = "Browser Monitor Attributes Policy"
  incident_preference = "PER_CONDITION_AND_TARGET"
}

module "main" {
  source = "../.."

  account_id = var.account_id
  enabled    = var.enabled
  name       = "Browser Monitor Attributes"
  type       = "BROWSER"
  uri        = "https://www.one.newrelic.com"

  public_locations = ["US_WEST_1"]

  # Additional attributes supported by monitor
  validation_string = "New Relic"
  verify_ssl        = true

  # Additional attributes supported by the Browser monitor
  script_language                         = "JAVASCRIPT"
  runtime_type                            = "CHROME_BROWSER"
  runtime_version                         = "100"
  enable_screenshot_on_failure_and_script = true

  tags = {
    "App.Id"   = ["1234"]
    "App.Code" = ["EXAMPLE"]
  }
}
