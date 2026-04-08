package srp6

import (
	"crypto/rand"
	"crypto/sha1"
	"math/big"
	"strings"
)

var (
	srpG    = big.NewInt(7)
	srpN, _ = new(big.Int).SetString(
		"894B645E89E1535BBDAD5B8B290650530801B18EBFBF5E8FAB3C82872A3E9BB7",
		16,
	)
)

func leToBI(b []byte) *big.Int {
	rev := make([]byte, len(b))
	for i, v := range b {
		rev[len(b)-1-i] = v
	}
	return new(big.Int).SetBytes(rev)
}

func biToLE(n *big.Int, size int) []byte {
	be := n.Bytes()
	le := make([]byte, size)
	for i, v := range be {
		le[len(be)-1-i] = v
	}
	return le
}

func MakeRegistrationData(username, password string) (salt []byte, verifier []byte, err error) {
	u := strings.ToUpper(username)
	p := strings.ToUpper(password)

	salt = make([]byte, 32)
	if _, err = rand.Read(salt); err != nil {
		return
	}

	h1 := sha1.Sum([]byte(u + ":" + p))
	h2h := sha1.New()
	h2h.Write(salt)
	h2h.Write(h1[:])
	h2 := h2h.Sum(nil)

	x := leToBI(h2)
	v := new(big.Int).Exp(srpG, x, srpN)
	verifier = biToLE(v, 32)

	return salt, verifier, nil
}

func CalculateVerifier(username, password string, salt []byte) ([]byte, error) {
	u := strings.ToUpper(username)
	p := strings.ToUpper(password)

	h1 := sha1.Sum([]byte(u + ":" + p))
	h2h := sha1.New()
	h2h.Write(salt)
	h2h.Write(h1[:])
	h2 := h2h.Sum(nil)

	x := leToBI(h2)
	v := new(big.Int).Exp(srpG, x, srpN)
	verifier := biToLE(v, 32)

	return verifier, nil
}
