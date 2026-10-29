target "docker-metadata-action" {}

variable "APP" {
  default = "ambassador"
}

variable "VERSION" {
  // renovate: datasource=custom.modrinth-velocity depName=ambassador
  default = "1.4.5"
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
