target "docker-metadata-action" {}

variable "APP" {
  default = "minecraft-rcon-console"
}

variable "VERSION" {
  // renovate-git-tag: depName=Rauks/Minecraft-RCON-Console
  default = "2.8.7"
}

// commit of the VERSION tag
variable "VERSION_COMMIT" {
  default = "ed3b35889d67ed0417aa46f4483bdcee05b46e65"
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
