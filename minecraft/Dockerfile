FROM amazoncorretto:11-alpine

ARG mcsleepingversion=v1.0.0_1.16.5

WORKDIR /

COPY . .

# Add unrar for modpack downloading.
RUN apk add --no-cache unrar

RUN wget https://github.com/vincss/mcsleepingserverstarter/releases/download/$mcsleepingversion/sleepingServerStarter.run && chmod +x sleepingServerStarter.run && mv sleepingServerStarter.run /usr/bin

CMD ["/bin/bash", "/start.sh"]
