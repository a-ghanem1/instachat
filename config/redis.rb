default: &default
  url: redis://localhost:6379
  db: 0

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default
  url: redis://somelocalhosthost:6379