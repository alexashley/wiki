# General 
https://vimeo.com/171942749

https://auth0.com/docs/api-auth/grant/authorization-code-pkce

https://www.scottbrady91.com/OAuth/Why-the-Resource-Owner-Password-Credentials-Grant-Type-is-not-Authentication-nor-Suitable-for-Modern-Applications

https://auth0.com/docs/api-auth/which-oauth-flow-to-use

https://tools.ietf.org/html/rfc7636#section-1

# Mobile (React Native) 

https://github.com/oktadeveloper/okta-react-native-app-auth-example

https://github.com/FormidableLabs/react-native-app-auth

https://github.com/openid/AppAuth-Android


# Ramblings
why not use resource owner password credential flow?
- don't get single sign on or shared login sessions (get this with the authorization code flow from the browser session)
- encourages users to type their password into external applications
- no federation with external identity providers
- no mechanism to enforce two-factor authentication, forced password resets, etc

authorization code flow:
- get lastpass/whatever integration