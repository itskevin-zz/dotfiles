---
name: kanban-bet-slicing
description: "Turn a spec/plan into a product bet 1-pager, then Kanban-sized stories + vertical slices. Optimized for early-stage startup dev team."
---

# Kanban Bet Slicing

Convert a detailed spec plan into:
- a product-level 1-pager bet a lead can share with a Kanban team
- a small set of delivery-sized stories (2-3 day chunks)
- clear vertical slices (end-to-end user flows) with optionality to cut

## When To Use
- You have a spec/plan doc (often too detailed or phase-y)
- Team is early-stage, running Kanban, priorities shift with pilot learnings
- You need tickets that are shippable, end-to-end, and non-vague

## Output Bar
- No implementation details, file paths, or component names
- No vague acceptance criteria like "team has agreed", "defined", "documented"
- Each story is user-facing, testable, and sized for 2-3 dev days
- Slices are vertical flows, not architecture phases

## Slices live at the milestone level, not the issue level

A vertical slice is a **Milestone** (Linear-native, under the project) — not an ad hoc bucket of ticket IDs. Each milestone owns its own value statement, AC, and non-goals. Stories/issues are created *underneath* a milestone and attached to it via Linear's `milestone` field (`save_milestone` to create the milestone, `save_issue` with `milestone: <name>` to attach). An issue belongs to exactly the milestone whose AC it helps satisfy — see self-classification below. Don't group issues into a slice manually first; define the milestone's AC, then let issues map to it.

### The Milestone Template

Every milestone gets these four fields, always:

```
## Milestone: <slice name>

Value statement:
  When this ships, a <user> can <do what>, and we can learn <what>.

Acceptance criteria (what is true when done):
  - <observable outcome>
  - <observable outcome>

Deferred to a later slice (explicit non-goals):
  - <thing that sounds like it belongs but does not>

Observability (how we verify, if not user-facing):
  - <UI probe | API contract | visible side effect | passing test>
```

The **value statement** forces the vertical cut — it names a user and a learning. **Acceptance criteria** double as the sorting function for self-classification below. **Deferred** is not optional — it's what stops a thin slice quietly re-inflating into the whole feature.

### Observable ≠ user-facing

Every milestone needs an observable outcome, but "observable" isn't the same as "has a UI." Four modes, cheapest honest one wins:

| Mode | What it is | Proof |
| --- | --- | --- |
| UI probe | A crude, unstyled page or control | A person triggers it and sees the result |
| API contract | The deliverable is an endpoint | A call returns the right shape; consumer is the next system |
| Visible side effect | A job runs, something changes | A row appears, a card updates, an event lands on an admin page |
| Passing test | Internal logic (schema, scoring) | The test is the artifact, shipped behind the flag |

"No frontend" never blocks a milestone. "No observable outcome" always does.

## Workflow

### 1) Ingest The Plan (Spec -> Constraints)
Extract:
- Objective + non-goals
- Key decisions already made (treat as constraints)
- Open decisions (convert to explicit TODOs only if needed to ship a slice)
- Required user roles (student, counselor, admin)

Deliverable: 5-10 bullet "constraints" you will not violate.

### 2) Draft The Bet 1-Pager (Product Narrative)
Write a 1-pager with:
- Hypothesis
- Target users
- MVP definition (what must be true to call it shipped)
- Success signals (pilot metrics, not vanity)
- Kill/pivot criteria
- Non-goals

Keep it readable in 2 minutes.

### 3) Define Milestones (Vertical Slices, Before Stories)
Write each milestone using the template above, in shipping order.

Pattern for ordering:
- Milestone A: first usable flow (often no enrichment)
- Milestone B: "gets smarter" loop (enrichment, entity match)
- Milestone C: bring the second persona earlier if critical (e.g., counselor)
- Milestone D: trust/iteration (why shown, curation)
- Milestone E: measure/debug (metrics, change log)

Test for each: does the value statement name a user and a learning? Do the AC describe a user outcome, or a code layer? If an AC names a layer, re-cut the milestone.

### 4) Product Drafts Stories (Self-Classified)
For each milestone, product drafts the user-facing/value-bearing stories needed to satisfy its AC. Each story:
- Summary
- Scope
- Acceptance Criteria (Given/When/Then style where possible)

**Self-classification rule:** a candidate story attaches to the milestone whose AC it helps satisfy. Serves a later milestone's AC? It belongs there, not here. If a story is hard to place, the milestone's AC is too vague; fix the milestone, not the story.

Rule of thumb: if you can't imagine a demo in 2-3 minutes, it's not a good story.

**Enabler/technical work:** product doesn't own the how (see `issue_creation`'s ownership boundary), but flagging that enabler work is *needed* is still product's job — don't leave it implicit. Where it's tightly coupled to one story, note it as a sub-issue under that story. Where it spans multiple stories or is substantial on its own, flag it as a standalone issue, paired with the earliest milestone that consumes it (see enabler-pairing, step 7). Flag the need; leave the "how" for the refinement pass below.

### 5) Joint Refinement Pass (Product + Engineering)
Walk the drafted issues together with engineering before they're considered final. This is a checkpoint, not a one-way handoff:
- Engineering fills in / corrects technical issues product flagged but couldn't fully scope
- Engineering may split, merge, or add issues based on what they know about the system
- Product holds the line on value statements and AC staying outcome-level, not code-level, as issues get refined
- Disagreements get resolved here, not discovered mid-sprint

### 6) AC Quality Gate (Hard)
Scan stories and rewrite any AC that is:
- agreement-based: "team has agreed/defined"
- process-based: "documented"
- non-testable: "should be better"

Replace with observable behavior:
- user can do X
- system shows Y
- state persists across reload
- failure states are explicit

**Required AC on every story, and part of the definition of done:** "When this fails, an error is logged to Sentry (our observability platform) with enough ids to find the case, and no student data." A story without it fails the gate.

### 7) Enabler-Pairing Pass
Work with no user value of its own (a scoring engine, a schema) is not a milestone, it's an enabler. Don't let it float alone where it balloons into weeks of invisible work — pair it with the *first* milestone that consumes it, and let that milestone's outcome verify it. This is also where engineering-surfaced enablers from step 5 get placed if product didn't already flag them.

Exception: when the backend genuinely *is* the deliverable and another system is waiting (a partner integration), it can stand as its own milestone — verified by a call or test (see Observable ≠ user-facing above), not deferred.

### 8) Re-scope Based On Reality
If product already has a capability (e.g., "Why this match" for AI recs):
- do NOT create a net-new story
- re-scope to extend/unify coverage and prevent regressions

### 9) Iterate With The PM (Fast)
When PM changes priority:
- swap milestone order, not story semantics
- tighten one story, create a new story only if it protects the milestone's demo

## Templates

### Bet 1-Pager Template
```md
## <Initiative>: Bet <N> (Pilot)

### Hypothesis
If <capability>, then <measurable outcome> for <user>.

### Target Users
- <primary>
- <secondary>

### Milestones (Vertical Slices)
Milestone A: <name>
  Value statement: When this ships, a <user> can <do what>, and we can learn <what>.
  Acceptance criteria:
    - <observable outcome>
  Deferred:
    - <thing that sounds like it belongs but does not>
  Observability: <UI probe | API contract | visible side effect | passing test>
  Stories (attached in Linear via milestone field): <ticket ids, filled in after step 4>

Milestone B: <name>
...

### MVP Definition (exit)
- <bullet list of "must be true" behaviors>

### Success Signals (pilot)
- <metric + direction>

### Kill / Pivot Criteria
- <what would make us stop or change direction>

### Non-goals
- <explicit not doing>
```

## Example (Real)

### Bet 1-Pager Example: College Matching V2 (Pilot)
```md
## College Matching V2: Bet 1 (Pilot)

### Hypothesis
If we give students an ungated Explore list + a counselor-steerable shortlist (with clear likelihood tiers + enrichment for missing items), then students will build a usable shortlist faster and counselors will feel the list reflects their intent and guidance.

### Target Users
- Students actively building a college list
- Counselors shaping/validating that list with families

### Milestones (Vertical Slices)
Milestone A: Get list -> make shortlist (durable)
  Value statement: When this ships, a student can generate a list, shortlist it, manually add to it, and return later to find it still there — we learn whether the base flow holds attention without enrichment.
  Acceptance criteria:
    - Student can generate an Explore list, add items to a shortlist, manually add an unmatched item, and see it persist across a reload
  Deferred: enrichment lifecycle (Milestone B), counselor pin/note (Milestone C), Why-shown consistency (Milestone D)
  Observability: UI probe — student opens Explore, shortlists, reloads, sees persisted state
  Stories: GET-446, GET-445, GET-447, GET-451 (self-classified — each satisfies a piece of the AC above)

Milestone B: Manual add -> gets smarter (enrichment loop)
  Value statement: When this ships, a manually-added item that starts as Insufficient Data becomes populated with provenance and a retry path — we learn whether the enrichment loop is fast/reliable enough to trust.
  Acceptance criteria:
    - Unmatched entries progress from Insufficient Data to populated, with provenance and retry on failure
  Deferred: counselor workflow (Milestone C)
  Observability: visible side effect — item status transitions Pending -> Done with provenance links
  Stories: GET-448, GET-454, GET-455 (builds on Milestone A's shortlist, doesn't duplicate it)

Milestone C: Counselor workflow (priority)
  Value statement: When this ships, a counselor can add + pin an item with a required note, and student removal requires an explanation — we learn whether counselors trust and use the override.
  Acceptance criteria:
    - Counselor can add/pin up to 3 items with a required note; student removal requires explanation
  Deferred: trust/iteration polish (Milestone D)
  Observability: UI probe — counselor pins an item, student sees it pinned with note
  Stories: GET-456

Milestone D: Trust + iteration
  Value statement: When this ships, "Why this match" is consistent across sources and students can steer the list via curation — we learn whether trust signals change behavior.
  Acceptance criteria:
    - Why-shown explanation is consistent regardless of source; student curation actions are reflected in future recommendations
  Deferred: nothing further planned this bet
  Observability: UI probe
  Stories: GET-450, GET-452

Milestone E: Measure
  Value statement: When this ships, we can evaluate pilot outcomes and debug refresh behavior across all prior milestones — an enabler-turned-milestone because another system (the eval pipeline) depends on it directly.
  Acceptance criteria:
    - Pilot metrics are queryable; refresh behavior is debuggable from an admin view
  Deferred: n/a
  Observability: API contract / passing test
  Stories: GET-453

### MVP Definition (Bet 1 exit)
- Student can: generate Explore without Big Five, shortlist items, manually add, see likelihood tiers, return later with state preserved.
- Counselor can: add + pin up to 3 items with required note; student can remove but must give explanation.
- Manual/unmatched items: show Insufficient Data + enrichment lifecycle w retry; provenance when done; no guessing.

### Non-goals
- Probabilistic admissions “percent chance”
- Historical admissions ingestion + similarity matching
```

### Story Examples (Fully Written)
These are written as portable examples. Replace nouns (e.g., "college") with your domain.

#### Story 1: Ungated Explore list generation + empty-state CTA
```md
## Summary
Students can generate an Explore recommendations list without completing optional surveys.

## Scope
- Generate recommendations using conversation/intent signals when surveys are missing
- Empty state when no recommendations are possible yet
- CTA that routes student toward the next best action to improve recommendations
- Out: changing the underlying matching model quality beyond removing the gate

## Acceptance Criteria
- Given a student who has not completed the optional survey, when they open Explore, then they still see a recommendations list.
- Given a student with too little context to generate any recommendations, when they open Explore, then they see an empty state (not an error) with a CTA to "complete more conversations" (or equivalent next step).
- The page never blocks list generation behind a required survey.
- The empty state does not imply blame or failure; it explains what to do next.
```

#### Story 2: Likelihood tiers shown in Explore + Shortlist (no probabilities)
```md
## Summary
Show a simple likelihood tier per item to help students balance their list without implying guaranteed outcomes.

## Scope
- Display tiers on both Explore and Shortlist
- Tiers: `Target`, `Reach`, `Unlikely`, `Insufficient Data`
- Manual-added items default to `Insufficient Data`
- Out: numeric probabilities

## Acceptance Criteria
- Each item in Explore and Shortlist shows exactly one tier.
- Manual-added items show `Insufficient Data` until enriched.
- `Insufficient Data` has an info affordance that explains: we need more program/institution data to generate likelihood and complete details.
- For non-`Insufficient Data` tiers, an explanation view shows 2-5 criteria used (plain language) and includes a short uncertainty note.
- UI copy does not use probability language or guarantee admissions outcomes.
```

#### Story 3: Shortlist workflow + manual add (always adds)
```md
## Summary
Students can create and manage a shortlist, including manually adding missing items.

## Scope
- Add to shortlist from Explore
- Shortlist view supports remove and reorder
- Manual add always creates an entry, even if unmatched
- Manual add requires minimum fields relevant to your domain (e.g., name + location + program)

## Acceptance Criteria
- Given an item in Explore, when a student shortlists it, then it appears in Shortlist immediately.
- Given a student manually adds an item, when they submit, then the item appears in Shortlist even if it does not match the database.
- Manually added items default to `Insufficient Data` likelihood.
- Manual add supports an optional note from the student that is visible later.
- Students can remove items from Shortlist.
```

#### Story 4: Enrichment status lifecycle + retry (no guessing)
```md
## Summary
Unmatched/manual items show enrichment progress and can be retried when enrichment fails.

## Scope
- Status states: `Pending`, `In progress`, `Done`, `Failed`
- Retry action for `Failed`
- Provenance links when `Done`
- Out: silently fabricating missing fields

## Acceptance Criteria
- Given an unmatched/manual item, when it is created, then it shows enrichment status `Pending`.
- Status transitions are visible to the user as enrichment runs.
- If enrichment fails, the item shows `Failed` and the user can trigger `Retry`.
- When enrichment succeeds, additional details populate and provenance/source links are visible.
- If a field cannot be verified, it remains explicitly missing (no guessing).
```

### Story Template (Kanban Sized)
```md
## Summary
<1-2 sentences>

## Scope
- <in>
- <in>
- <out>

## Acceptance Criteria
- Given <context>, when <action>, then <observable result>
- Failure states: <explicit states>
- No <forbidden behavior> (e.g., no admissions guarantees, no guessing)
```

## Common Mistakes
- Creating phase parent issues; they rot and don\'t ship
- ACs that only describe intent (agreement) instead of behavior
- Horizontal slices (backend-only) without a demoable user flow
- Mixing pilot bet scope with long-term platform investments

## Minimal Checklist (Before Sharing With Dev Team)
- 1-pager readable in 2 minutes
- Milestone A alone provides a real user win
- Every story is self-classified to a milestone, or flagged as an enabler paired to one
- Joint refinement pass with engineering has happened — not just a product handoff
- Each story has a crisp demo
- ACs are observable and regression-aware
- Non-goals explicitly prevent scope creep
