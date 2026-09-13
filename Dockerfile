# TODO This should be in its own place to reference for all projects,
#      built pre-project

FROM openresty/openresty:1.31.1.1-bookworm

LABEL maintainer = "Tangent/Rose <tangentfoxy@gmail.com>"
ENV RUN_ENV=development

RUN mkdir /app
VOLUME /app

EXPOSE 8080
WORKDIR /app
ENTRYPOINT ["sh", "-c", "sleep 5 && lapis migrate $RUN_ENV && lapis serve $RUN_ENV"]

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install libssl-dev git -y   # OpenSSL header dependency

RUN luarocks install lapis
RUN luarocks install luacrypto       # legacy requirement (lapis)
RUN luarocks install bcrypt
RUN luarocks install lapis-console
RUN luarocks install lua-cjson
# RUN luarocks install markdown        # legacy requirement; probably discardable

# clean up
RUN apt-get autoremove -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# legacy
# actually build stuff!
# RUN luarocks install moonscript
# COPY . .
# RUN moonc .
