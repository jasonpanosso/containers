variable "APP" {
  default = "velocity-scoreboard-api"
}

variable "VERSION" {
  // renovate-git-tag: depName=NEZNAMY/VelocityScoreboardAPI
  default = "2.1.1"
}

// commit of the VERSION tag
variable "VERSION_COMMIT" {
  default = "41397cd5a4ceaf0a2a14199acf477153ad127da8"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  args = {
    VERSION = "${VERSION}"
    VERSION_COMMIT = "${VERSION_COMMIT}"
    SOURCE_DATE_EPOCH = "0"
  }
  labels = {
    "org.opencontainers.image.version" = "${VERSION}"
    "org.opencontainers.image.revision" = "${VERSION_COMMIT}"
    "org.opencontainers.image.licenses" = "Apache-2.0"
  }
}

target "image-local" {
  inherits = ["image"]
  output = ["type=docker,rewrite-timestamp=true"]
  tags = ["${APP}:${VERSION}"]
}

target "image-all" {
  inherits = ["image"]
  output = ["type=image,rewrite-timestamp=true"]
  platforms = [
    "linux/amd64",
    "linux/arm64"
  ]
}
