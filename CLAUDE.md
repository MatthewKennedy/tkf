# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Rails 8.1 e-commerce application for **Tongkat Fitness** (tongkat.fitness), built on top of [Spree Commerce 5.3](https://spreecommerce.org). The app is deployed as a Docker container via Kamal and uses PostgreSQL as the database.

## Commands

### Development

Start all development processes (server + Tailwind watchers):
```sh
bin/dev   # uses Procfile.dev
```

Or run individually:
```sh
bin/rails server -p 3000          # web server
bin/rails tailwindcss:watch       # storefront CSS
bin/rails spree:admin:tailwindcss:watch  # admin CSS
```

### Testing

```sh
bin/rails test                    # run all unit/integration tests
bin/rails test:system             # run system tests (requires Chrome)
bin/rails test test/models/spree/user_test.rb  # run a single test file
bin/rails test test/models/spree/user_test.rb:42  # run a single test by line
bin/rails db:test:prepare && bin/rails test test:system  # full CI-equivalent
```

### Linting & Security

```sh
bin/rubocop                       # lint Ruby (rails-omakase style)
bin/brakeman --no-pager           # Rails security scan
bin/importmap audit               # JS dependency security scan
```

## Architecture

### Spree-Based Structure

The app is a Spree host application — most business logic lives inside the Spree engine. Custom code is added by overriding/decorating Spree classes:

- **`app/models/spree/`** — model overrides (e.g., `user.rb`, `admin_user.rb`)
- **`app/controllers/spree/`** — controller overrides for Devise flows
- **`app/views/spree/`** and **`app/views/themes/`** — view overrides and theme customization
- **`lib/spree/`** — authentication helpers injected into `ApplicationController`

Spree is mounted at `/` in `config/routes.rb`. All storefront and admin routes flow through the Spree engine.

### Two User Classes

There are two separate Devise-managed user models:

| Class | Purpose | Route key |
|---|---|---|
| `Spree::User` | Storefront customers | `user` |
| `Spree::AdminUser` | Admin panel users | `admin_user` |

Both are configured in `config/initializers/spree.rb` and `config/initializers/devise.rb`. Auth helpers for both are in `lib/spree/authentication_helpers.rb` (included into `ApplicationController`).

### Custom Spree Extensions (Gems)

- `spree_shipstation` — ShipStation shipping integration (custom fork)
- `spree_paypal_checkout` — PayPal checkout (custom fork); view override at `app/views/spree/checkout/payment/_spree_paypal_checkout.html.erb`
- `spree_mydhl` — DHL shipping integration
- `spree_google_analytics` — GA tracking

### Frontend

- **Tailwind CSS** for both storefront and admin (separate watch processes)
- **Propshaft** for asset pipeline
- **Import maps** for JavaScript (no bundler/Node build step)
- **Hotwire** (Turbo + Stimulus) for interactivity
- Stimulus controllers in `app/javascript/controllers/`

### Background Jobs & Caching

- **Solid Queue** for background jobs (DB-backed)
- **Solid Cache** for Rails cache (DB-backed)
- **Solid Cable** for Action Cable (DB-backed)

### Observability

- **Sentry** for error tracking (`config/initializers/sentry.rb`)
- **Yabeda + Prometheus** for metrics (`lib/instrumentation/yabeda_metrics.rb`)
- **rails_semantic_logger** for structured logging
- CDN configured at `cdn.tongkat.fitness`

### Permissions

Defined in `config/initializers/spree.rb`:
- `:default` role → `Spree::PermissionSets::DefaultCustomer`
- `:admin` role → `Spree::PermissionSets::SuperUser`

## CI

GitHub Actions runs on PRs and pushes to `main`:
1. `scan_ruby` — Brakeman security scan
2. `scan_js` — importmap audit
3. `lint` — RuboCop
4. `test` — `db:test:prepare test test:system` against a Postgres service container

Ruby version is pinned in `.ruby-version` (currently 4.0.1).
