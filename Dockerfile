FROM  elixir:1.14-alpine AS builder

ARG BUILD_ENV=prod
ARG BUILD_REL=worker

# Install system dependencies
RUN mix local.hex --force
RUN mix local.rebar --force

# Add sources
ADD . /workspace/
WORKDIR /workspace

ENV MIX_ENV=${BUILD_ENV}

# Fetch dependencies
RUN mix deps.get

# Build project
RUN mix compile
RUN mix release

FROM alpine:latest AS runner

ARG BUILD_ENV=prod
ARG BUILD_REL=worker

# Install system dependencies
RUN apk add --no-cache openssl ncurses-libs libgcc libstdc++

# Install release
COPY --from=builder /workspace/_build/${BUILD_ENV}/rel/${BUILD_REL} /opt/${BUILD_REL}

# We want a FQDN in the nodename
ENV RELEASE_DISTRIBUTION="name"

# This will be the basename of our node
ENV RELEASE_NAME="${BUILD_REL}"

# This will be the full nodename
ENV RELEASE_NODE="${RELEASE_NAME}@${RELEASE_IP}"
ENV RELEASE_COOKIE="asdf"

ENTRYPOINT ["/opt/worker/bin/worker"]
