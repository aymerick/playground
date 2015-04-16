package main

import (
	"fmt"
	"log"
	"net/smtp"
	"net/textproto"

	"github.com/jordan-wright/email"
)

const (
	SMTP_HOST = "smtp.gmail.com"
	SMTP_PORT = 587
	SMTP_USER = "mymail@gmail.com"
	SMTP_PASS = ""
)

func main() {
	mail := &email.Email{
		To:      []string{"mymail@gmail.com"},
		From:    "mymail@gmail.com",
		Subject: "Test",
		HTML:    []byte("<p>This is a test</p>"),
		Text:    []byte("This is a test yeah"),
		Headers: textproto.MIMEHeader{},
	}

	smtpAddr := fmt.Sprintf("%s:%d", SMTP_HOST, SMTP_PORT)
	smtpAuth := smtp.PlainAuth("", SMTP_USER, SMTP_PASS, SMTP_HOST)

	rawMail, _ := mail.Bytes()

	log.Printf("Sending mail:\n %s\n", string(rawMail))
	err := mail.Send(smtpAddr, smtpAuth)
	if err == nil {
		log.Print("Mail sent \\o/")
	} else {
		log.Fatal("Mail failed :(((")
	}
}
