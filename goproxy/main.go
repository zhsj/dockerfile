package main

import (
	"net/http"

	"github.com/goproxy/goproxy"
)

func main() {
	http.ListenAndServe(":8080", &goproxy.Goproxy{
		Cacher: goproxy.DirCacher("/cache"),
	})
}
