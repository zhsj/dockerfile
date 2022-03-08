variable "PREFIX" {
  default = "docker.io/zhusj"
}

variable "DATE" {
  # date -u '+%Y%m%d%H%M'
  default = ""
}

group "default" {
  targets = [
    "apt-cacher-ng",
    "bind9",
    "dind",
    "exim4",
    "gha",
    "goproxy",
    "redmine",
    "shadowsocks",
    "sshd",
  ]
}

target "apt-cacher-ng" {
  context = "./apt-cacher-ng"
  tags = [
    "${PREFIX}/apt-cacher-ng:latest",
    notequal("", DATE) ? "${PREFIX}/apt-cacher-ng:${DATE}" : "",
  ]
}

target "bind9" {
  context = "./bind9"
  tags = [
    "${PREFIX}/bind9:latest",
    notequal("", DATE) ? "${PREFIX}/bind9:${DATE}" : "",
  ]
}

target "dind" {
  context = "./dind"
  tags = [
    "${PREFIX}/dind:latest",
    notequal("", DATE) ? "${PREFIX}/dind:${DATE}" : "",
  ]
}

target "exim4" {
  context = "./exim4"
  tags = [
    "${PREFIX}/exim4:latest",
    notequal("", DATE) ? "${PREFIX}/exim4:${DATE}" : "",
  ]
}

target "gha" {
  context = "./gha"
  tags = [
    "${PREFIX}/gha:latest",
    notequal("", DATE) ? "${PREFIX}/gha:${DATE}" : "",
  ]
}

target "goproxy" {
  context = "./goproxy"
  tags = [
    "${PREFIX}/goproxy:latest",
    notequal("", DATE) ? "${PREFIX}/goproxy:${DATE}" : "",
  ]
}

target "redmine" {
  context = "./redmine"
  tags = [
    "${PREFIX}/redmine:latest",
  ]
}

target "shadowsocks" {
  context = "./shadowsocks"
  tags = [
    "${PREFIX}/shadowsocks:latest",
  ]
}

target "sshd" {
  context = "./sshd"
  tags = [
    "${PREFIX}/sshd:latest",
    notequal("", DATE) ? "${PREFIX}/sshd:${DATE}" : "",
  ]
}
