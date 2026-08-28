package main

import (
	"encoding/json"
	"io"
	"net/http"
	"time"

	"github.com/labstack/echo/v5"
)

type GithubUser struct {
	Login     string `json:"username"`
	ID        int    `json:"id"`
	Name      string `json:"name"`
	Email     string `json:"email"`
	AvatarURL string `json:"avatar_url"`
}

/*
* gh loginHandler
*
* browser's GET routed here.
* need to redirect browser to the url with proper query params & state Cookie
*
*
 */

func (a *app) loginHandler(c *echo.Context) error {
	state := generateRandomString()

	c.SetCookie(&http.Cookie{
		Name:     "oauth_state",
		Value:    state,
		Path:     "/",
		MaxAge:   600, // 10 min
		SameSite: http.SameSiteLaxMode,
	})

	url := a.OAuthConfig.AuthCodeURL(state)
	return c.Redirect(http.StatusFound, url)
}

/*
* GH callbackHandler
*
* need to verify state from query param matches state stored in Cookie
*
* exchange code from query param for access token.
*
* GET req to github user api with access token to get the sub(to be stored in provider_user_id)
*
* verify response is 200
* verify json decodes
*
 */
func (a *app) callbackHandler(c *echo.Context) error {
	state := c.QueryParam("state")

	cookie, err := c.Cookie("oauth_state")
	if err != nil {
		return c.String(http.StatusBadRequest, "Oauth cookie not found")
	}

	if state != cookie.Value {
		return c.String(http.StatusBadRequest, "Invalid oauth state")
	}

	code := c.QueryParam("code")

	token, err := a.OAuthConfig.Exchange(c.Request().Context(), code)
	if err != nil {
		return c.String(http.StatusInternalServerError, "Failed to exchange code for token")
	}

	req, err := http.NewRequest("GET", "https://api.github.com/user", nil)
	if err != nil {
		return c.String(http.StatusInternalServerError, "Failed to create request")
	}

	token.SetAuthHeader(req)

	// http.DefaultClient has no timeout set so making own is safer
	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return c.String(http.StatusInternalServerError, "Failed to make request")
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return c.String(http.StatusInternalServerError, "Failed to get user info")
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return c.String(http.StatusInternalServerError, "Failed to read response body")
	}

	var user GithubUser
	if err := json.Unmarshal(body, &user); err != nil {
		return c.String(http.StatusInternalServerError, "Failed to unmarshal user info")
	}

	if



}
