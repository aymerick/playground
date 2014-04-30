package main

import (
	"fmt"
	"net/url"
	"os"

	"github.com/ChimeraCoder/anaconda"
)

func main() {
	anaconda.SetConsumerKey(os.Getenv("PLG_TWITTER_CONSUMER_KEY"))
	anaconda.SetConsumerSecret(os.Getenv("PLG_TWITTER_CONSUMER_SECRET"))

	api := anaconda.NewTwitterApi(os.Getenv("PLG_TWITTER_ACCESS_TOKEN"), os.Getenv("PLG_TWITTER_ACCESS_TOKEN_SECRET"))

	text := "Ceci est un test"

	tweet, err := api.PostTweet(text, url.Values{})
	if err != nil {
		fmt.Printf("%v\n%v", "Failed to post tweet:", err)
	} else {
		fmt.Printf("Tweet posted: %v", tweet)
	}
}
