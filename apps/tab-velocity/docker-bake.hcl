target "docker-metadata-action" {}

variable "APP" {
  default = "tab-velocity"
}

variable "VERSION" {
  // renovate-git-tag: depName=NEZNAMY/TAB
  default = "6.2.1"
}

// commit of the VERSION tag
variable "VERSION_COMMIT" {
  default = "a748a6b2c0770347996b37aaf9f4f50d8cf9ee47"
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
