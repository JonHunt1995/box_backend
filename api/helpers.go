package main

import (
	"crypto/rand"
	"encoding/base64"
)

func generateRandomString() string {
	randomBytes := make([]byte, 32)
	rand.Read(randomBytes)
	randomString := base64.URLEncoding.EncodeToString(randomBytes)
	return randomString
}
