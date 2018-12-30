package main

import (
	"flag"
	"io"
	"log"
	"os"

	"golang.org/x/crypto/openpgp"
	"golang.org/x/crypto/openpgp/armor"
	"golang.org/x/crypto/openpgp/packet"
)

func main() {
	keyPathPtr := flag.String("key", "", "The path to the public key")
	sigPathPtr := flag.String("sig", "", "The path to the signature file")
	targetPathPtr := flag.String("target", "", "The path to the file to check")

	flag.Parse()

	verifyFile(keyPathPtr, sigPathPtr, targetPathPtr)
}

func decodePublicKey(filename string) *packet.PublicKey {

	// open ascii armored public key
	in, err := os.Open(filename)
	if err != nil {
		log.Fatalf("Error opening public key file: %s", err)
	}
	defer in.Close()

	block, err := armor.Decode(in)
	if err != nil {
		log.Fatalf("Error decoding public key OpenPGP Armor: %s", err)
	}

	if block.Type != openpgp.PublicKeyType {
		log.Fatal("Error decoding private key: Invalid private key file")
	}

	reader := packet.NewReader(block.Body)
	pkt, err := reader.Next()
	if err != nil {
		log.Fatalf("Error reading private key: %s", err)
	}

	key, ok := pkt.(*packet.PublicKey)
	if !ok {
		log.Fatal("Error parsing public key: Invalid public key")
	}
	return key
}

func decodeSignature(filename string) *packet.Signature {

	// open ascii armored signature
	in, err := os.Open(filename)
	if err != nil {
		log.Fatalf("Error opening signature file: %s", err)
	}
	defer in.Close()
	
	reader := packet.NewReader(in)
	pkt, err := reader.Next()
	if err != nil {
		log.Fatal("Error reading signature")
	}

	sig, ok := pkt.(*packet.Signature)
	if !ok {
		log.Fatal("Error parsing signature: Invalid Signature")
	}
	return sig
}

func verifyFile(keyPathFile *string, sigPathFile *string, targetPathFile *string) {
	pubKey := decodePublicKey(*keyPathFile)
	sig := decodeSignature(*sigPathFile)

	target, err := os.Open(*targetPathFile)
	if err != nil {
		log.Fatalf("Error opening signature file: %s", err)
	}
	defer target.Close()
	hash := sig.Hash.New()
	io.Copy(hash, target)

	sigerr := pubKey.VerifySignature(hash, sig)
	if sigerr != nil {
		log.Fatalf("Error verifying input: %s", sigerr)
	}
}
