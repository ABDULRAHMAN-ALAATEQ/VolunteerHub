# VolunteerHub

SENG 361

VolunteerHub is a small Ruby on Rails SaaS application for publishing campus volunteering opportunities, student registrations, hour logs, deanship reviews and printable certificates.
All sample identities and activities aren't real data.
This is a local course demonstration, not a production university service.

## Run locally (Windows, macOS or Linux)

Requirements: 
- Ruby 3.2 or newer compatible with Rails 7.2 (Ruby 3.3 recommended)
- Bundler,
- SQLite support and an internet connection to install gems.
On Windows use RubyInstaller with Devkit or WSL.
On Linux a compiler and SQLite development headers may be needed if native gems must compile.

From the `VolunteerHub` folder, run:

```sh
ruby -v
gem install bundler
bundle install
bundle exec rails db:prepare
bundle exec rails db:seed
bundle exec rails server
```

Open http://localhost:3000. 
The first `db:prepare` creates and migrates the databases, the explicit seed command makes sample data available and is safe to rerun without duplicating the original records. 
Dates are relative to the initial seed date.
For a fresh demo, stop the server and run `bundle exec rails db:drop db:create db:migrate db:seed` (DELETES local data).
**Never run this on a real database.**

| Role | Email | Password |
| Student | student@demo.test | Volunteer123! |
| Organization | organization@demo.test | Volunteer123! |
| Deanship | deanship@demo.test | Volunteer123! |
| Second student | student2@demo.test | Volunteer123! |
| Second organization | green@demo.test | Volunteer123! |

## Demo sequence

1. Sign in as the organization. Create an upcoming opportunity with a valid schedule and capacity, edit it and inspect participant records.
2. Sign out, sign in as the student. Browse and filter opportunities, register for the newly created activity. Check the dashboard and prevent duplicate registration.
3. On the student dashboard use the already-completed **Community food drive** to log 3 hours and describe the activity (new future activities cannot be logged until their end time).
4. Sign in as the deanship. Reject the new log with a reason, then sign in as the student and correct/resubmit it. Return to the deanship and approve, issue the certificate.
5. Sign in as the student. Open the certificate and use Print / Save PDF. The pre-seeded certificate demonstrates the format even before the new workflow is complete.

## Tests

```sh
bundle exec rails db:migrate
bundle exec rails test
```

Integration tests cover authentication, authorisation, ownership, opportunity creation/edit/filter, duplicate and over-capacity registration, bounded hours, review/rejection/correction, idempotent issuance, certificate access and dashboard rendering.
runtime tests have been executed.

## Design decisions

- MVC, Rails sessions, bcrypt password hashing, CSRF protection, controller-level role checks and record-level ownership, no public sign-up or role switching. Separate demo accounts represent provisioned university identities.
- SQLite for single-instance classroom demonstration, use PostgreSQL and appropriate concurrency/load testing for production. Unique registration and certificate indexes and model transactions protect integrity, SQLite can reject concurrent writers, so the registration endpoint asks the user to retry on database-busy errors.
- An opportunity accepts registration only while open, before its start, and below capacity. Registered participants protect the schedule and minimum capacity from subsequent edits.
- Hours must be positive, at most the scheduled duration and submitted after completion. Deanship reviews submitted records only, rejection requires a reason. Certificates are issued once per approved log and snapshot names/title/hours. The PDF is browser-generated, no server-side PDF dependency.
- AJAX filtering is progressive enhancement using Fetch API, with normal GET fallback. Static CSS and JS are served directly, no Node build required. Responsive English UI, reduced-motion support and print stylesheet. Illustrations are CSS and text symbols, not external image assets.
- Demo seeds and demo login helper are disabled in production. Public deployment is not configured or claimed. Production configuration requires HTTPS and SECRET_KEY_BASE, real deployment would also need account provisioning, monitoring, backups, rate limiting, privacy review and a stronger concurrency strategy.

## Scrum / submission

Read `docs/` and the supplied charter/report. Backlog is proposed, not client-approved. Sprint documents reflect the actual implementation grouping, not historical meetings. Client approval, change and peer-evaluation alternative are pending instructor confirmation. The implementation history is supplied as a Git bundle, no GitHub repository or remote pull-request reviews have been created. Follow `docs/GITHUB.md` to publish authentic history and perform the remaining reviews.