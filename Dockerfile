FROM golang:1.16-alpine AS build
WORKDIR /src

RUN apk add --no-cache git
RUN git clone https://github.com/microsoft/go-sqlcmd.git
WORKDIR /src/go-sqlcmd/cmd/sqlcmd
RUN go build -o /bin/sqlcmd

FROM mcr.microsoft.com/azure-sql-edge:latest
COPY --from=build /bin/sqlcmd /opt/go-sqlcmd/sqlcmd

# COPY ./install_sqlcmd.sh /etc
# RUN chmod +x /etc/install_sqlcmd.sh
# RUN /etc/install_sqlcmd.sh

# Environment variables
ENV ACCEPT_EULA=1
ENV MSSQL_SA_PASSWORD=yourStrong(!)Password
ENV MSSQL_PID=Developer

ENTRYPOINT ["/opt/mssql/bin/sqlservr"]
