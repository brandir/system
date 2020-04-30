// snippets.go, created 04/30/2020
// Various go code snippets.

// Cf. https://stackoverflow.com/questions/12122159/how-to-do-a-https-request-with-bad-certificate
// Handling bad certificates is apparently happening quite often.
// Update: 04/30/2020

import (
    "fmt"
    "net/http"
    "crypto/tls"
)

func main() {
    tr := &http.Transport{
        TLSClientConfig: &tls.Config{InsecureSkipVerify: true},
    }
    client := &http.Client{Transport: tr}
    _, err := client.Get("https://golang.org/")
    if err != nil {
        fmt.Println(err)
    }
}
