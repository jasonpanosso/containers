target "docker-metadata-action" {}

variable "APP" {
  default = "simple-voice-chat"
}

variable "VERSION" {
  // renovate: datasource=custom.modrinth-velocity depName=simple-voice-chat versioning=regex:^velocity-(?<major>\d+)\.(?<minor>\d+)\.(?<patch>\d+)$
  default = "velocity-2.6.18"
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
