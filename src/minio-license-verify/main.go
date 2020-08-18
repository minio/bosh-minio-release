package main

import (
	"fmt"
	"os"

	"github.com/minio/minio/pkg/licverifier"
)

var pubkey = []byte(`-----BEGIN PUBLIC KEY-----
MHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEaK31xujr6/rZ7ZfXZh3SlwovjC+X8wGq
qkltaKyTLRENd4w3IRktYYCRgzpDLPn/nrf7snV/ERO5qcI7fkEES34IVEr+2Uff
JkO2PfyyAYEO/5dBlPh1Undu9WQl6J7B
-----END PUBLIC KEY-----`)

func main() {
	if len(os.Args) != 2 {
		fmt.Println("USAGE: minio-license-verify <KEY>")
		os.Exit(1)
	}
	lic, err := licverifier.NewLicenseVerifier(pubkey)
	if err != nil {
		fmt.Println("Invalid public key")
		os.Exit(1)
	}
	_, err = lic.Verify(os.Args[1])
	if err != nil {
		fmt.Println("Invalid license key")
		os.Exit(1)
	}
	os.Exit(0)
}
