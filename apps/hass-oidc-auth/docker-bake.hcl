variable "APP" {
  default = "hass-oidc-auth"
}

variable "VERSION" {
  // renovate-git-tag: depName=christiaangoossens/hass-oidc-auth
  default = "v1.3.0"
}

// commit of the VERSION tag
variable "VERSION_COMMIT" {
  default = "5749fcb135415dd8e2bf027f998ad407ece23447"
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
    "org.opencontainers.image.licenses" = "MIT"
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
