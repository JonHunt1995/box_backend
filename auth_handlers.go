package main

import (
	"net/http"

	"github.com/labstack/echo/v5"
)

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
func (a *app) callbackHandler(c *echo.Context) error {
}
*/
