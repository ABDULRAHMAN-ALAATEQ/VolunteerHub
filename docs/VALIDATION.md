# Validation record

Authoring environment checks: Ruby 3.3.8 syntax (`ruby -c`) on 27 Ruby files/entrypoints; JavaScript syntax (`node --check`); all 10 ERB templates passed adapted Ruby structure compilation (not Rails rendering). Rails gems unavailable; no runtime pass or browser-rendering result is claimed. See README for local setup.

| Acceptance check | Expected result | Runtime result/date |
| Anonymous dashboard, invalid password, role restriction | Redirect / rejected login / 403 | Pending |
| Organization creates, edits and filters opportunity | Saved own records; other owner denied | Pending |
| Register twice / full / past activity | No extra registrations | Pending |
| Student submits > duration / valid hours | Invalid rejected / submitted | Pending |
| Reject without reason / reject with reason / resubmit | No invalid transition; correction accepted | Pending |
| Certificate before approval / issue twice | No certificate before approval; one after | Pending |
| Access another student's certificate | 403 | Pending |
| Dashboard for each role | Successful response | Pending |
| Browser filter / mobile layout / print | Correct results, readable layout, printable certificate | Pending manual |

Run `bundle exec rails test` after setup. Record actual output and any fixes, commit the lockfile and review on a new GitHub PR.
