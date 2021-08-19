package main

import (
	"crypto/x509"
	"encoding/json"
	"encoding/pem"
	"fmt"
	"log"
	"net/http"
	"os"
	"strings"
)

var scope struct {
	user string
	repo string
}

func jwtEncode(iss, key string) (string, error) {
	k := []byte(key)
	block, _ := pem.Decode(k)
	if block != nil {
		k = block.Bytes
	}

	parsedKey, err := x509.ParsePKCS1PrivateKey(k)
	if err != nil {
		return "", err
	}

	return Encode(
		&Header{Algorithm: "RS256", Typ: "JWT"},
		&ClaimSet{Iss: iss},
		parsedKey,
	)
}

func accessToken(installationID, appToken string) (string, error) {
	addr := "https://api.github.com/app/installations/" + installationID + "/access_tokens"
	req, err := http.NewRequest("POST", addr, nil)
	if err != nil {
		return "", err
	}
	req.Header.Add("Accept", "application/vnd.github.v3+json")
	req.Header.Add("Authorization", "Bearer "+appToken)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusCreated {
		return "", fmt.Errorf("got %d from %s", resp.StatusCode, addr)
	}
	var result struct {
		Token string
	}
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return "", err
	}
	return result.Token, nil
}

func runnerToken(authToken, typ string) (string, error) {
	var scopePath string
	if scope.repo == "" {
		scopePath = "orgs/" + scope.user + "/actions/runners/registration-token"
	} else {
		scopePath = "repos/" + scope.user + "/" + scope.repo + "/actions/runners/" + typ + "-token"
	}
	addr := "https://api.github.com/" + scopePath
	req, err := http.NewRequest("POST", addr, nil)
	if err != nil {
		return "", err
	}
	req.Header.Add("Accept", "application/vnd.github.v3+json")
	req.Header.Add("Authorization", "token "+authToken)
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusCreated {
		return "", fmt.Errorf("got %d from %s", resp.StatusCode, addr)
	}
	var result struct {
		Token string
	}
	if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
		return "", err
	}
	return result.Token, nil
}

func main() {
	pat := os.Getenv("PAT")
	appID := os.Getenv("APP_ID")
	appKey := os.Getenv("APP_KEY")
	installationID := os.Getenv("INSTALLATION_ID")
	runnerTokenType := os.Args[1]

	runnerScope := strings.Split(os.Getenv("RUNNER_SCOPE"), "/")
	scope.user = runnerScope[0]
	if len(runnerScope) == 2 {
		scope.repo = runnerScope[1]
	}
	if scope.user == "" && scope.repo == "" {
		log.Fatal("invalid RUNNER_SCOPE")
	}

	var authToken string
	if pat != "" {
		authToken = pat
	} else if appID != "" && appKey != "" && installationID != "" {
		jwtToken, err := jwtEncode(appID, appKey)
		if err != nil {
			log.Fatal(err)
		}
		authToken, err = accessToken(installationID, jwtToken)
		if err != nil {
			log.Fatal(err)
		}
	} else {
		log.Fatal("missing PAT or APP_ID/APP_KEY/INSTALLATION_ID")
	}

	got, err := runnerToken(authToken, runnerTokenType)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(got)
}
