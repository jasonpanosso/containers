variable "APP" {
  default = "ambassador"
}

variable "VERSION" {
  // renovate-git-tag: depName=adde0109/Ambassador
  default = "v1.4.5"
}

// commit of the VERSION tag
variable "VERSION_COMMIT" {
  default = "349ce41f5fba50653d0aec8ebb7d77f68a5d00e1"
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
    "org.opencontainers.image.licenses" = "LGPL-2.1-only"
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
