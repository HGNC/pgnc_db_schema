FROM alpine:latest

VOLUME /var/lib/postgresql
# COPY ./docker-entrypoint-initdb.d/pgncdb.sql.gz /docker-entrypoint-initdb.d/pgncdb.sql.gz

CMD ["true"]
