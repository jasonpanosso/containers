target "docker-metadata-action" {}

variable "APP" {
  default = "hass-oidc-auth"
}

variable "VERSION" {
  // renovate-git-tag: depName=christiaangoossens/hass-oidc-auth
  default = "v1.2.1"
}

// commit of the VERSION tag
variable "VERSION_COMMIT" {
  default = "0699a6774340e1440e770690c8af922bd933a1e7"
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
