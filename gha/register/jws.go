// Copyright 2014 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// Package jws provides a partial implementation
// of JSON Web Signature encoding and decoding.
// It exists to support the golang.org/x/oauth2 package.
//
// See RFC 7515.

package main

import (
	"crypto"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"time"
)

// ClaimSet contains information about the JWT signature including the
// permissions being requested (scopes), the target of the token, the issuer,
// the time the token was issued, and the lifetime of the token.
type ClaimSet struct {
	Iss string `json:"iss"` // email address of the client_id of the application making the access token request
	Exp int64  `json:"exp"` // the expiration time of the assertion (seconds since Unix epoch)
	Iat int64  `json:"iat"` // the time the assertion was issued (seconds since Unix epoch)

}

func (c *ClaimSet) encode() (string, error) {
	// Reverting time back for machines whose time is not perfectly in sync.
	// If client machine's time is in the future according
	// to Google servers, an access token will not be issued.
	now := time.Now().Add(-10 * time.Second)
	if c.Iat == 0 {
		c.Iat = now.Unix()
	}
	if c.Exp == 0 {
		c.Exp = now.Add(time.Minute * 10).Unix()
	}
	if c.Exp < c.Iat {
		return "", fmt.Errorf("jws: invalid Exp = %v; must be later than Iat = %v", c.Exp, c.Iat)
	}

	b, err := json.Marshal(c)
	if err != nil {
		return "", err
	}

	return base64.RawURLEncoding.EncodeToString(b), nil
}

// Header represents the header for the signed JWS payloads.
type Header struct {
	// The algorithm used for signature.
	Algorithm string `json:"alg"`

	// Represents the token type.
	Typ string `json:"typ"`

	// The optional hint of which key is being used.
	KeyID string `json:"kid,omitempty"`
}

func (h *Header) encode() (string, error) {
	b, err := json.Marshal(h)
	if err != nil {
		return "", err
	}
	return base64.RawURLEncoding.EncodeToString(b), nil
}

// Signer returns a signature for the given data.
type Signer func(data []byte) (sig []byte, err error)

// EncodeWithSigner encodes a header and claim set with the provided signer.
func EncodeWithSigner(header *Header, c *ClaimSet, sg Signer) (string, error) {
	head, err := header.encode()
	if err != nil {
		return "", err
	}
	cs, err := c.encode()
	if err != nil {
		return "", err
	}
	ss := fmt.Sprintf("%s.%s", head, cs)
	sig, err := sg([]byte(ss))
	if err != nil {
		return "", err
	}
	return fmt.Sprintf("%s.%s", ss, base64.RawURLEncoding.EncodeToString(sig)), nil
}

// Encode encodes a signed JWS with provided header and claim set.
// This invokes EncodeWithSigner using crypto/rsa.SignPKCS1v15 with the given RSA private key.
func Encode(header *Header, c *ClaimSet, key *rsa.PrivateKey) (string, error) {
	sg := func(data []byte) (sig []byte, err error) {
		h := sha256.New()
		h.Write(data)
		return rsa.SignPKCS1v15(rand.Reader, key, crypto.SHA256, h.Sum(nil))
	}
	return EncodeWithSigner(header, c, sg)
}
