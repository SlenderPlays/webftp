import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :web_ftp, WebFTPWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "+GELQMa5rG1Xm+u1SjYZzDsY5aBoS4tHOYA3e6r5DSmXocAgPIVESWcM/Ow5rhTQ",
  server: false

# In test we don't send emails.
config :web_ftp, WebFTP.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
