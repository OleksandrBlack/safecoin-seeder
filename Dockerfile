FROM zencash/gosu-base:1.11

# Install our build dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install apt-utils \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install git build-essential libboost-all-dev libssl-dev ca-certificates wget \

COPY . /usr/local/src

WORKDIR /usr/local/src
  
RUN make

FROM zencash/gosu-base:1.11

# Install our run dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install apt-utils \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install git build-essential libboost-all-dev libssl-dev ca-certificates wget \

WORKDIR /usr/local/bin

COPY --from=build /usr/local/src/dnsseed .

EXPOSE 53
EXPOSE 53/udp

ENTRYPOINT ["./dnsseed"]