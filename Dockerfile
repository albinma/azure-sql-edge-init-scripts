FROM golang:1.16-alpine AS build
WORKDIR /src

RUN apk add --no-cache git
RUN git clone https://github.com/microsoft/go-sqlcmd.git
WORKDIR /src/go-sqlcmd/cmd/sqlcmd
RUN go build -o /bin/sqlcmd
RUN /bin/sqlcmd -h

FROM mcr.microsoft.com/azure-sql-edge:latest
COPY --from=build /bin/sqlcmd /bin/sqlcmd

# Environment variables
ENV ACCEPT_EULA=1
ENV MSSQL_SA_PASSWORD=yourStrong(!)Password
ENV MSSQL_PID=Developer
ENV SQLCMDSERVER=localhost
ENV SQLCMDUSER=sa
ENV SQLCMDPASSWORD=yourStrong(!)Password

RUN sudo /bin/sqlcmd -h

RUN ( /opt/mssql/bin/sqlservr --accept-eula & ) | grep -q "Service Broker manager has started" \
  && echo "SQL Server is ready" \
  # && /opt/mssql/bin/sqlcmd -q "SELECT 1" \
  && echo "Stopping SQL Server" \
  && pkill sqlservr

ENTRYPOINT ["/opt/mssql/bin/sqlservr"]
