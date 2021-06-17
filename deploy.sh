REALLY_LONG_SECRET=(mix phx.gen.secret)
export SECRET_KEY_BASE=REALLY_LONG_SECRET
mix deps.get --only prod
MIX_ENV=prod mix compile
mix phx.digest
PORT=4001 MIX_ENV=prod mix phx.server
