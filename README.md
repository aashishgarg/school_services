# School Services

Multi-tenant school management on **Rails 8**, **PostgreSQL**, **Hotwire** (Turbo + Stimulus), **Tailwind CSS**, **Pundit**, and Rails 8 native authentication (`has_secure_password`).

## Getting started

### Prerequisites

- Ruby 3.4+ (see [`.ruby-version`](.ruby-version))
- PostgreSQL 14+ **or** Docker

### Environment variables (database)

[`config/database.yml`](config/database.yml) reads:

| Variable | Default | Purpose |
|----------|---------|---------|
| `DATABASE_HOST` | `localhost` | Set to `db` when using Docker Compose |
| `DATABASE_USER` | `postgres` | |
| `DATABASE_PASSWORD` | `password` | CI uses `postgres` / `postgres` via workflow `env` |

### Docker Compose (recommended)

```bash
docker compose build app   # after Gemfile / Gemfile.lock changes
docker compose up
```

Then open http://localhost:3000 — the app runs `bundle check || bundle install` on startup so new gems are picked up in dev.

Create and seed the database (first time):

```bash
docker compose run --rm -e DATABASE_HOST=db app bin/rails db:create db:migrate db:seed
```

Demo logins (from seeds):

- **Admin:** `admin@demo.test` / `password123`
- **Teacher:** `teacher@demo.test` / `password123`

### Local (without Docker)

```bash
bin/setup   # or: bundle install && bin/rails db:prepare db:seed
bin/dev     # Rails + Tailwind watcher (see Procfile.dev)
```

### Tests

```bash
bin/rails db:test:prepare
bin/rails test
bin/rails test:system
```

CI runs `bin/rails db:test:prepare test test:system` with PostgreSQL (see [`.github/workflows/ci.yml`](.github/workflows/ci.yml)).

## Features (by module)

| Area | Description |
|------|-------------|
| **Identity** | Sessions, password reset mailer, roles `admin` / `teacher` |
| **Tenancy** | `school_id` on tenant tables; [`SchoolScoped`](app/models/concerns/school_scoped.rb) + `Current.school` |
| **Admin** | Academic years, classes, sections, students (CSV import), users, buses/stops, attendance report, transport dashboard, audits, school settings |
| **Attendance** | First/second half sessions per section; mobile-friendly roster |
| **Transport** | Bus trips, per-stop progress (Reached / Skipped), Turbo Stream updates on admin transport page |

## Adding a new module (template)

Follow the same layout as **Transport** — copy and rename namespaces:

1. **Routes** — `namespace :your_module do ... end` in [`config/routes.rb`](config/routes.rb).
2. **Controllers** — `app/controllers/your_module/` inheriting from `ApplicationController`.
3. **Models** — `app/models/your_module/` (or top-level if single model); include `SchoolScoped` when the table has `school_id`.
4. **Policies** — `app/policies/your_module/` + register rules in [`ApplicationPolicy`](app/policies/application_policy.rb) patterns.
5. **Views** — `app/views/your_module/`.
6. **Tests** — request/system tests under `test/`; use fixtures scoped to `schools(:one)`.

Checklist for each new resource:

- [ ] `school_id` column + FK + index
- [ ] `include SchoolScoped` (except `User` / `School`)
- [ ] Pundit policy + `authorize` / `policy_scope` in controller
- [ ] Turbo streams only if real-time UI is required

## Production deploy (Kamal)

This app ships with Kamal configuration (see [`config/deploy.yml`](config/deploy.yml) and [`Dockerfile`](Dockerfile)).

1. Copy `config/master.key` (or `RAILS_MASTER_KEY`) to your deploy secrets.
2. Set `APP_DATABASE_PASSWORD` and other secrets referenced in `deploy.yml`.
3. Configure `.kamal/secrets` as documented in [Kamal](https://kamal-deploy.org).
4. Run `bin/kamal setup` then `bin/kamal deploy` from a machine with SSH access to the target host.

**Solid Queue** is included for Rails 8 defaults; run the queue worker process in production as documented for your Kamal accessory / host layout.

## Security notes

- Teachers may only take attendance for sections where they have a `class_teacher` assignment.
- Bus stop updates are allowed for the bus **in charge** teacher, or any teacher if `school.settings["any_teacher_can_mark_bus"]` is enabled (admin toggle on Settings).
