package main

import (
	"net/http"

	"github.com/goproxy/goproxy"
	"github.com/goproxy/goproxy/cacher"
)

func main() {
	s := goproxy.New()
	s.Cacher = &cacher.Disk{Root: "/cache"}
	http.ListenAndServe(":8080", s)
}
