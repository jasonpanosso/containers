variable "APP" {
  default = "velocity"
}

variable "VERSION" {
  // renovate-git-tag: depName=PaperMC/Velocity
  default = "v4.3.1"
}

// commit of the VERSION tag
variable "VERSION_COMMIT" {
  default = "300f5d0823691c8c8bace0c91714c63ab52e0b77"
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
    "org.opencontainers.image.licenses" = "GPL-3.0-or-later"
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
