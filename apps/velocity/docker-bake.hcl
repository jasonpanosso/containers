target "docker-metadata-action" {}

variable "APP" {
  default = "velocity"
}

variable "VERSION" {
  // renovate: datasource=github-releases depName=PaperMC/Velocity
  default = "v4.3.1"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker"]
  tags = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
