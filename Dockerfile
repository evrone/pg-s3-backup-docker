FROM alpine:3.8
LABEL maintainer="Antiarchitect <voronkovaa@gmail.com>"

ENV AWS_ACCESS_KEY_ID=key
ENV AWS_SECRET_ACCESS_KEY=secret
ENV BUCKET_KEY_PREFIX=pgbackup
ENV BUCKET_NAME=mybackup
ENV DATABASE_URL=postgres://user:password@somehost:5432/mydb

RUN apk add --no-cache \
  postgresql-client \
  py2-pip

RUN pip install --upgrade pip
RUN pip --no-cache-dir install awscli

CMD ["/bin/sh", "-c", "pg_dump ${DATABASE_URL} | gzip | aws s3 cp - s3://${BUCKET_NAME}/${BUCKET_KEY_PREFIX}_$(date -Iseconds --utc).sql.gz"]