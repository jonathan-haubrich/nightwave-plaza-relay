FROM linuxserver/ffmpeg

RUN apt update && apt install -y nginx

RUN rm /etc/nginx/sites-enabled/default
COPY ./stream.conf /etc/nginx/sites-available/stream
RUN ln -s /etc/nginx/sites-available/stream /etc/nginx/sites-enabled

COPY ./entrypoint.sh entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
