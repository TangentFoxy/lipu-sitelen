# lipu-sitelen
Small, simple, blog platform. Share writing easily, comment easily.

## Initial Thoughts
Critical features include
- [ ] Markdown support,
- [ ] import/export of all data through JSON,
- [ ] comment support
  - [ ] with captchas
  - [ ] and moderation features (not requiring an account).
- [ ] Backup feature.
- [ ] Automatic update feature.
- [ ] HTML in Markdown allowed without exception since it should ONLY be trusted content.
  - [ ] Gotta make it very clear that it assumes anyone with posting permission is trustworthy..
  - [ ] though maybe make HTML content a trust-level permissions thing.
  - [ ] NOT FOR COMMENTS, COMMENTS DO NOT GET HTML
    - [ ] comments should also probably be prevented from including headers? no, the site styling can make the difference clear

### other features
- [ ] Footer customization.
- [ ] Archives pages.
- [ ] Categories
- [ ] Tags
- [ ] Post / Page customization settings? Like wrapping things in an article tag or not.

---

I briefly thought about calling it lipu pona, but I'll reserve using that name for something better.

## Dev Environment
I ran into weird issues trying to get this started.. so in case I need to figure this out again:
```sh
luarocks install lapis --local OPENSSL_DIR="$(brew --prefix openssl@3)" CRYPTO_DIR="$(brew --prefix openssl@3)"
brew trust openresty/brew
brew install openresty/brew/openresty --without-geoip
```

Also had to add `export PATH=$PATH:/Users/tangent/.luarocks/bin` to `.zschrc` to deal with LuaRocks not handling things correctly. -.-

###### old projects of various quality to look at and remember how to use Lapis
- [ ] https://github.com/TangentFoxy/guard13007.com
- [ ] https://github.com/TangentFoxy/tangentfox-com
- [ ] https://github.com/TangentFoxy/Ellis
- [ ] https://github.com/TangentFoxy/GreyList
- [ ] https://github.com/TangentFoxy/Arcadia
- [ ] https://github.com/TangentFoxy/insecure-proxy
- [ ] https://github.com/TangentFoxy/Realms
- [ ] https://github.com/TangentFoxy/ClickMine
- [ ] https://github.com/TangentFoxy/F5-Podcast
- [ ] https://github.com/TangentFoxy/slackiver
- [ ] https://github.com/TangentFoxy/KSS
- [ ] https://github.com/TangentFoxy/Fake.Net
- [ ] https://github.com/TangentFoxy/F5-Podcast.old
- [ ] https://github.com/TangentFoxy/Lazucast
