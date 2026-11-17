target "docker-metadata-action" {}

variable "APP" {
  default = "minimotd"
}

variable "VERSION" {
  // renovate-git-tag: depName=jpenilla/MiniMOTD
  default = "v2.2.5"
}

// commit of the VERSION tag
variable "VERSION_COMMIT" {
  default = "8703ac088f7dff99b2c5c462e4ef33688f9feb46"
}

group "default" {
  targets = ["image-local"]
}

target "image" {
  inherits = ["docker-metadata-action"]
  args = {
    VERSION = "${VERSION}"
    VERSION_COMMIT = "${VERSION_COMMIT}"
    SOURCE_DATE_EPOCH = "0"
  }
  labels = {
    "org.opencontainers.image.version" = "${VERSION}"
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
