---
name: ship-with-flags
description: "Addie's flag-gated, continuous-shipping model — feature flag decisions, trunk-based merging, ship cadence, safe migrations, and flag cleanup. Use when planning how a feature ships, deciding if something needs a flag, writing kickoff checklists, or reviewing a migration/rollback plan. Pairs with kanban-bet-slicing (which owns vertical slicing) — this skill owns everything downstream of the slice: flag it, merge it, ship it, keep it safe."
---

# Ship With Flags

Root problem this solves: large batches make releases scary and breakage hard to trace. Fix is small batches from the source — decompose (see `kanban-bet-slicing`), flag, merge continuously, ship on a cadence, keep it safe. This skill covers everything after decomposition.

## 1. Flag decision

| Flag it | Skip the flag |
| --- | --- |
| User-visible, lands over multiple days | Pure backend plumbing, harmless dormant |
| Want pilot-first / per-school rollout | Bug fix to something already live |
| Risky enough to want an instant off-switch | Small enough to finish + ship safely in one push |

Default: most work is multi-day today, so most gets flagged. Add to kickoff checklist for every issue: **flag needed? (yes/no)**, **flag key (if yes)**.

## 2. Flag design rules

- One flag per feature/slice-group. Not per line, not one global flag.
- Runtime toggle via admin UI — no redeploy to flip.
- **Global by default**, with a **per-school override**. Default-off + override = how you turn it on for a pilot. Default-on is the norm otherwise (paying schools expect the whole product day one).
- Named owner + retirement target date on every flag.
- Must resolve correctly in the async pipeline, where background workers may lack school/student context — check this explicitly, it's the one place flags break silently.
- Reference schools by id, never by typed name.

## 3. Merge continuously

- Short-lived branches, one per increment (not per feature).
- Merge into `main` within a day or two.
- Flag **on** in dev/staging (team sees/tests as it accumulates), **off** in prod (ships dormant).
- Flipping on in prod = a switch, not a push. Pilot school first when it matters.

## 4. Ship cadence

- Don't jump to daily. Sequence: big-bang → weekly → twice-weekly → daily/per-merge.
- Current: manual **Thursday-morning** prod push (not Friday — leaves 2 days to fix before the weekend).
- Signal to speed up: release engineer's job is just "push a button." Ask them what's still manual.
- Admin-only/low-impact work ships flagless, small-batch, no ceremony.

## 5. Keep it safe

**Recovery, two flavors:**
- Feature-gated breakage → flip the flag off. Instant, no deploy.
- Non-flagged breakage → roll back the Cloud Run revision. Seconds.
- Every deploy must be tagged for release tracking (Sentry attributes errors to the release).

**Migrations — expand and contract, always:**
1. Add the new thing, leave the old in place.
2. Switch over behind the flag once validated.
3. Clean up the old path only once *nothing* — including every async worker — still touches it.
- Hard rule: never ship a destructive schema change in the same deploy as the code depending on it.

**Flag cleanup:** when a flag flips fully on in prod, open a retirement issue within ~2 weeks — remove the flag, delete the off-path code. Tracked against the owner/retire-by date from step 2.

**Testing both states:** on and off are both real paths. Test the state before flipping it. During transition, cover both — old and new coexist.

## Mid-flight work (transition only)

Flags retrofit cheaply, slicing does not. In-flight features: add a flag before the next push, don't re-slice. Not-yet-started work: full model from kickoff. Don't pilot the new model on a large in-flight feature — use the next small greenfield one.

## Checklist (apply when scoping/reviewing an issue or PR)

- [ ] Flag needed? If yes, key assigned, owner named, retire-by date set
- [ ] Default is global-on or global-off decided; per-school override path clear
- [ ] Flag resolves correctly for async/background workers, not just request-time code
- [ ] Branch is short-lived, scoped to one increment
- [ ] Migration (if any) follows expand-and-contract; no destructive change ships with dependent code
- [ ] Rollback path identified: flag flip or Cloud Run revision rollback
- [ ] Both flag states have a test plan
