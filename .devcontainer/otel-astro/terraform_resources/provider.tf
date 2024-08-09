terraform {
  required_providers {
    newrelic = {
      source = "newrelic/newrelic"
      version = "3.41.1"
    }
  }
}

provider "newrelic" {
  # Configuration options
}