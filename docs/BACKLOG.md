# Proposed product backlog (client approval pending)

Story points are relative effort estimates, not elapsed hours. 
P1 = must-have; P2 = should-have.
This is a proposal of the order in the Product Owner role, client approval is pending.

| ID | Sprint | Priority | Points | SMART user story and acceptance criteria |
| 1  |   1    |    P1    |   3    | As a campus user, I want to sign in using my provisioned account by Sprint 1 so that 
                                    I reach my role dashboard. Valid credentials work; invalid credentials fail; anonymous users go to login; forbidden actions return 403.|
| 2  |   1    |    P1    |   5    | As an organization, I want to publish and edit an opportunity by Sprint 1 so students can
                                    participate. Required details, category, dates and positive capacity are validated; only the owning organization can edit. |
| 3  |   1    |    P1    |   3    | As a student, I want to find opportunities by search and category by Sprint 1. Matching titles/
                                    locations/descriptions are returned; an empty result is shown; filter works without JS and with AJAX. |
| 4  |   1    |    P1    |   5    | As a student, I want to register once for an open, upcoming activity by Sprint 1. Full,
                                    closed, started and duplicate registrations are rejected; my dashboard shows the registration. |
| 5  |   2    |    P1    |   5    | As a student, I want to log my contribution by Sprint 2. Completed activity only; hours are 
                                    positive and no greater than duration; a description is required; status becomes submitted. |
| 6  |   2    |    P1    |   5    | As deanship staff, I want to approve/reject a submitted log by Sprint 2. Only deanship can 
                                    review; rejection requires reason; student can correct and resubmit; approved hours appear in totals. |
| 7  |   2    |    P1    |   3    | As deanship staff, I want to issue one certificate per approved log by Sprint 2. Pending/
                                    rejected logs cannot be certified; repeated issuance preserves the certificate; only its student and deanship can view it. |
| 8  |   2    |    P2    |   3    | As an organization or deanship user, I want to see participation and verified totals by 
                                    Sprint 2. Organization sees its own opportunities and participants; deanship sees campus-wide records. |
| 9  |   2    |    P2    |   3    | As a student, I want to print my certificate by Sprint 2. It contains name, opportunity, 
                                    hours, issue date and unique code; print layout excludes navigation. |

Sprint 1: 16 points.
Sprint 2: 19 points. 
Total: 35 points. 
Implementation is present in source, acceptance and runtime verification are pending.