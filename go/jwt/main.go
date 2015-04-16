package main

import (
	"errors"
	"fmt"
	"log"
	"time"

	"github.com/dgrijalva/jwt-go"
)

func main() {
	signingKey := []byte("hoyeahcheckitbaby")

	// create token
	token := jwt.New(jwt.SigningMethodHS256)

	token.Claims["foo"] = "bar"
	token.Claims["exp"] = time.Now().Add(time.Hour * 72).Unix()

	log.Printf("token: %v", token)

	// sign token
	tokenString, err := token.SignedString(signingKey)
	if err != nil {
		panic(err)
	}

	log.Printf("token signed: %s", tokenString)

	// verify token
	decToken, err := jwt.Parse(tokenString, func(t *jwt.Token) (interface{}, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New(fmt.Sprintf("Unexpected signing method: %v", t.Header["alg"]))
		}
		return signingKey, nil
	})

	if err != nil {
		panic(err)
	}

	log.Printf("Decoded token: %v", decToken)

	// validate token
	if decToken.Valid {
		log.Print("Token validated \\o/")
	} else {
		panic("OMG! An invalid token!")
	}

	// get token expiry
	expiryF, isFloat := decToken.Claims["exp"].(float64)
	if !isFloat {
		panic("Erroneous expiry value")
	}

	expiry := time.Unix(int64(expiryF), 0)

	log.Printf("Expiry: %v", expiry)
}
