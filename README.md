# Tongkat Fitness

E-commerce storefront and admin for [tongkat.fitness](https://tongkat.fitness), built on Rails 8.1 and Spree Commerce 5.3.

## Stack

| Layer | Technology |
|---|---|
| Framework | Ruby 4.0.1 / Rails 8.1 |
| E-commerce | Spree 5.3 |
| Database | PostgreSQL |
| Frontend | Hotwire (Turbo + Stimulus), TailwindCSS, Import Maps |
| Assets | Propshaft |
| Jobs | Solid Queue |
| Cache | Solid Cache |
| Action Cable | Solid Cable |
| Storage | AWS S3 (eu-west-2) |
| Email | Postmark |
| Error tracking | Sentry |
| Metrics | Yabeda + Prometheus |
| Deployment | Docker + Kamal |
| CDN | cdn.tongkat.fitness |

## Getting Started

### Prerequisites

- Ruby 4.0.1 (use `rbenv` or `asdf`)
- PostgreSQL
- Google Chrome (for system tests)

### Setup

```sh
bundle install
bin/rails db:create db:migrate db:seed
```

### Running locally

```sh
bin/dev
```

This starts three processes via `Procfile.dev`:
- Rails server on port 3000
- Tailwind CSS watcher (storefront)
- Tailwind CSS watcher (admin)

## Development

### Tests

```sh
bin/rails test                   # unit and integration tests
bin/rails test:system            # system tests (requires Chrome)

# Run a single file or test
bin/rails test test/models/spree/user_test.rb
bin/rails test test/models/spree/user_test.rb:42
```

### Linting & Security

```sh
bin/rubocop                      # Ruby style (rails-omakase)
bin/brakeman --no-pager          # Rails security scan
bin/importmap audit              # JS dependency audit
```

### Credentials

Sensitive config (database passwords, API keys, etc.) is stored in encrypted credentials:

```sh
bin/rails credentials:edit
```

Required credential keys: `database`, `aws`, `postmark`, `sentry`.

## Architecture

### Spree Customisation

The app is a Spree host application. Custom code is layered on top of the engine:

- `app/models/spree/` — model overrides (`User`, `AdminUser`)
- `app/controllers/spree/` — controller overrides for auth flows
- `app/views/spree/` — view overrides
- `app/views/themes/` — storefront theme templates
- `lib/spree/` — authentication helpers injected into `ApplicationController`

### Authentication

Two separate Devise-managed user classes:

- `Spree::User` — storefront customers
- `Spree::AdminUser` — admin panel users

### Integrations

| Integration | Gem |
|---|---|
| PayPal Checkout | `spree_paypal_checkout` (custom fork) |
| ShipStation | `spree_shipstation` (custom fork) |
| DHL | `spree_mydhl` |
| Google Analytics | `spree_google_analytics` |
| reCAPTCHA v3 | `recaptcha` |

### Databases (Production)

Production uses four separate PostgreSQL databases to isolate concerns:

| Database | Purpose |
|---|---|
| `tkf_production_primary` | Application data |
| `tkf_production_cache` | Solid Cache |
| `tkf_production_queue` | Solid Queue |
| `tkf_production_cable` | Solid Cable |

## Deployment

The app is containerised and deployed with [Kamal](https://kamal-deploy.org):

```sh
kamal deploy
```

The Docker image runs as a non-root user with jemalloc for reduced memory usage. Assets are precompiled at build time and served via Thruster + the CDN.

## CI

GitHub Actions runs on every PR and push to `main`:

1. **Brakeman** — Rails security scan
2. **importmap audit** — JS dependency security scan
3. **RuboCop** — code style
4. **Tests** — full test suite including system tests
