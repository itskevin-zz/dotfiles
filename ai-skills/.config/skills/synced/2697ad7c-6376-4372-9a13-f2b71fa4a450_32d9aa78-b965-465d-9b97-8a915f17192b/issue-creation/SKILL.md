---
name: issue_creation
description: Create a detailed linear issue from a user prompt.
argument-hint: <ticket-description>
---

# Create a Ticket

Analyze the input and generate a structured ticket.

## Ownership boundary

Product owns the **what**, the **why**, and sometimes the **when**. Engineering owns the **how**. Do not prescribe file paths, function names, APIs, DB mechanics, or implementation approach — even if research surfaced the exact code path, that's context for discussion, not something to write into the issue.

Exception: it's fine to *ask* an open technical question or flag something to validate with engineering ("does this interact safely with the existing X system?") — that's surfacing a risk, not prescribing a solution. Never phrase it as an instruction ("use X to do Y").

## Acceptance Criteria
- [ ] Ticket includes a clear "When [desired action]... I want to... so I can..." job story.
- [ ] Acceptance Criteria are in "Given/When/Then" format, and describe a user-observable outcome — not a code layer. If an AC names a file, function, or layer, rewrite it.
- [ ] Open technical questions/risks are called out as questions for engineering, not prescribed answers. Omit this section if there are none — don't invent one.
- [ ] Avoid writing example code; stick to pseudo-code, logic statements, or mermaid diagrams only when describing application flow/state is unavoidable.
- [ ] Rollback path identified as a decision (flag flip vs. revision rollback — see `ship-with-flags`), not as an implementation plan.
- [ ] Flag needed? (yes/no) — if yes, note flag key. See `ship-with-flags` skill for the decision criteria.

## Example Output
**Title:** [Feature Name]
**Job Story:** [Description]
**AC:**
- Given [condition], when [action], then [result]
**Open Questions (optional, engineering-facing):**
- [Question about risk/interaction — not an instruction]
**Rollback:** [flag flip | revision rollback]
**Flag:** [yes, key: ... | no]
