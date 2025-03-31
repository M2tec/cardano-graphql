# Dockerfile to install these extensions to PostgresDB
# Extensions: pg_curl,

FROM postgres:14.10-alpine

COPY postgresql.conf /etc/postgresql/postgresql.conf
RUN chown 70:70 /etc/postgresql/postgresql.conf
RUN chmod 600 /etc/postgresql/postgresql.conf

# Extensions should be managed with private schemas, out from untrusted user's scope. Uncomment if you know what you are doing:to allow pg_curl for everybody.
# RUN echo "CREATE EXTENSION IF NOT EXISTS pg_curl ;" >> /docker-entrypoint-initdb.d/10_extensions.sql
# CMD ["bash"]
CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]