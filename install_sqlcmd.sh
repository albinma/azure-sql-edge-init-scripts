if [ ! -d "/opt/mssql-tools/bin" ]; then
  # Install go-sqlcmd
  echo "Installing go-sqlcmd"
  gvm install go1.1.1
  gvm use go1.1.1 --default
fi
