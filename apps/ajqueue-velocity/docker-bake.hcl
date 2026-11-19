variable "APP" {
  default = "ajqueue-velocity"
}

variable "VERSION" {
  // renovate-git-tag: depName=ajgeiss0702/ajQueue
  default = "2.9.1"
}

// commit of the VERSION tag
variable "VERSION_COMMIT" {
  default = "c0f7f521ff30406966d821493ae7d4778cd19dce"
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
    "org.opencontainers.image.licenses" = "GPL-3.0-only"
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
