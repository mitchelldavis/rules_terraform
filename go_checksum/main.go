package main

import (
	"bufio"
	"flag"
	"log"
	"os"
	"io"
	"strings"
	"path/filepath"
	"crypto/sha256"
	"encoding/hex"
)

func main() {
	checksumPathPtr := flag.String("shasum", "", "The path to the shasum file")
	targetPathPtr := flag.String("target", "", "The path to the file to check")

	flag.Parse()

	filename := filepath.Base(*targetPathPtr)
	verifyFile(checksumPathPtr, targetPathPtr, &filename)
}

func verifyFile(checksumPathPtr *string, targetPathPtr *string, targetBasePtr *string) {
	checksums := make(map[string]string)

	checksumFile, err := os.Open(*checksumPathPtr)
	if err != nil {
		log.Fatalf("Error opening checksum file: %s", err)
	}
	defer checksumFile.Close()

	targetFile, err := os.Open(*targetPathPtr)
	if err != nil {
		log.Fatalf("Error opening target file: %s", err)
	}
	defer targetFile.Close()

	// parse out the checksum target
	scanner := bufio.NewScanner(checksumFile)
	for scanner.Scan() {
		kv := strings.Fields(scanner.Text())
		checksums[kv[1]] = kv[0]
	}

	// Generate Hash
	targetFile_hash := sha256.New()
	if _, err := io.Copy(targetFile_hash, targetFile); err != nil {
		log.Fatal(err)
	}

	// compare
	var checksumFile_checksum string
	var targetFile_checksum = hex.EncodeToString(targetFile_hash.Sum(nil))
	var key_exists bool
	if checksumFile_checksum, key_exists = checksums[*targetBasePtr]; !key_exists {
		log.Fatalf("The Checksum file does not contain a checksum for %s", *targetBasePtr)
	}
    if checksumFile_checksum != targetFile_checksum {
		log.Fatalf("The checksums do not match: %s != %s", checksumFile_checksum, targetFile_checksum)
	}
}
