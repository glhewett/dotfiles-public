ADD_POSTGRES_ALIASES=0

if [ -d "/usr/pgsql-9.6/bin" ]; then
  export PATH=/usr/pgsql-9.6/bin:$PATH
  ADD_POSTGRES_ALIASES=1
elif [ -d "/opt/homebrew/opt/postgresql@16/bin" ]; then
  export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"
  ADD_POSTGRES_ALIASES=1
fi

# Homebrew Message:
# libpq is keg-only, which means it was not symlinked into /opt/homebrew,
# because conflicts with postgres formula.
#
# If you need to have libpq first in your PATH, run:
#   echo 'export PATH="/opt/homebrew/opt/libpq/bin:$PATH"' >> ~/.zshrc
#
# For compilers to find libpq you may need to set:
#   export LDFLAGS="-L/opt/homebrew/opt/libpq/lib"
#   export CPPFLAGS="-I/opt/homebrew/opt/libpq/include"
#
# For pkg-config to find libpq you may need to set:
#   export PKG_CONFIG_PATH="/opt/homebrew/opt/libpq/lib/pkgconfig"
if [ -d "/opt/homebrew/opt/libpq/bin" ]; then
  export PATH=$PATH:/opt/homebrew/opt/libpq/bin
  ADD_POSTGRES_ALIASES=1
fi

if [ $ADD_POSTGRES_ALIASES -eq 1 ]
then
    alias stop-postgresql="pg_ctl -D /usr/local/var/postgres/ -m fast stop"
    alias start-postgresql="pg_ctl -D /usr/local/var/postgres/ -l /usr/local/var/postgres/server.log start"
    alias pg_restore='pg_restore -cOd'
    alias pg_dump='pg_dump -Fc --no-acl --no-owner'
fi
