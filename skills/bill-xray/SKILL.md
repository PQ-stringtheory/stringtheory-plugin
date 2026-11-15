---
name: bill-xray
description: Perform clause-level federal bill search, omnibus buried-rider detection, Before-vs-After floor amendment diffing, and steelman Pro/Con impact analysis using StringTheory MCP tools (xray_bill_and_amendments, search_bill_clauses, generate_arguments).
---

# Bill X-Ray (`bill-xray`)

Use this skill whenever the user asks what a federal bill or amendment actually changes in U.S. law, wants to search for specific provisions or U.S. Code sections across Congress, asks whether an omnibus package contains buried riders, or wants balanced Pro and Con arguments anchored to statutory text.

## Core StringTheory MCP Tools

| Tool | Primary Use | Key Parameters |
| :--- | :--- | :--- |
| `xray_bill_and_amendments` | Decompose a bill into division/section policy mechanisms, dollar amounts, mandates/prohibitions, buried omnibus riders (`rider_divergence_score`), and 4-pattern Before vs. After floor amendment diffs | `bill_id` (required, e.g., `119-hr-1`, `119-s-4668`), `section_number` (optional, e.g., `Sec. 43201`), `buried_riders_only` (boolean, default `false`) |
| `search_bill_clauses` | Hybrid lexical + vector Reciprocal Rank Fusion search across `bill_sections`, `committee_reports`, and Congressional Record `floor_speeches` (`CREC`) with `<DELETED>` GPO tags stripped | Provide at least one of `query`, `bill_id`, `bioguide_id`, `usc_target` (e.g., `42 U.S.C. 1396a`), or `riders_only=true`; plus `congress` (default `119`), `corpus` (`all` \| `bill_sections` \| `committee_reports` \| `floor_speeches`), `limit` (`1..50`) |
| `generate_arguments` | Generate steelman Pro and Con arguments anchored to statutory sections, verbatim quotes, dollar figures, roll-call votes, and swing-member coalition signals | `target_bill_or_topic` (required `bill_id` or topic string), `side` (`both` \| `pro` \| `con`, default `both`), `focus_section` (optional, e.g., `Sec. 44121`) |

## Step-by-Step Workflow

### 1. Resolve the Bill or Topic
- If the user refers to a bill by colloquial title (e.g., "One Big Beautiful Bill", "GENIUS Act", "CLARITY Act", "NDAA"), call `resolve_entities` (`entity_type="bill"`) first to obtain the canonical `{congress}-{type}-{number}` `bill_id` (e.g., `119-hr-1`).
- If searching for a provision across all bills in a Congress (e.g., "AI state preemption" or `42 U.S.C. 1396a`), start directly with `search_bill_clauses`.

### 2. X-Ray Structure, Amendments, and Riders
1. Call `xray_bill_and_amendments` with `bill_id` to map the overarching divisions, section headings, `policy_mechanism`, `affected_sectors`, `dollar_amounts`, `plain_mandates`, and `plain_prohibitions`.
2. To audit non-germane provisions tucked inside large packages, pass `buried_riders_only=true` (or `riders_only=true` in `search_bill_clauses`) and inspect `is_buried_rider` and `rider_divergence_score` / `rider_entropy_score`. Always summarize the bill's primary divisions and core purpose *before* highlighting buried riders so the reader has accurate structural context.
3. Review `amendment_diffs` (`strike_replace_section`, `insert_section`, `page_line_edit`, `substitute`): compare `before_text` vs. `after_text`, check `adoption_status` and `roll_call_vote_id`, and explain `plain_vote_meaning` (what voting Yea vs. Nay on the amendment actually changed).

### 3. Drill Into Verbatim Clauses, Sponsor Context, and Steelman Arguments
- Call `search_bill_clauses` with `bill_id` + `query` (or `corpus="committee_reports"` / `corpus="floor_speeches"` + `bioguide_id`) to pull verbatim statutory language, U.S.C. targets, committee report explanations, and sponsor/cosponsor floor statements.
- When sponsor/cosponsor breakdown or coalition dynamics matter, pair with `research_stringtheory` or `generate_arguments` (`side="both"`, optional `focus_section`). `generate_arguments` returns both `pro_arguments` and `con_arguments` alongside `coalition_signal` (`party_break_probability`, `predicted_yea_probability`, and `swing_members`).

## Statutory Accuracy Guardrails

1. **Never quote struck `<DELETED>` GPO text as active law**:
   - GPO engrossed/amendment XML wraps struck language in `<DELETED>...</DELETED>`. StringTheory's `xray_bill_and_amendments`, `search_bill_clauses`, and `generate_arguments` strip `<DELETED>` blocks automatically (`deleted_gpo_blocks_stripped`). Rely on `clean_provisions`, `after_text`, and `verbatim_quote`.
2. **Distinguish introduced bills, committee reports, floor amendments, and enacted statutes**:
   - State clearly whether a provision is in an introduced bill, an adopted or rejected amendment (`adoption_status`), a non-binding committee report (`corpus="committee_reports"`), or signed law.
3. **Cite section numbers, U.S.C. targets, and share receipts**:
   - Anchor every plain-English impact bullet to its exact `bill_id`, `section_number`, `usc_target` (when amending existing code), and `share_receipt_url` (`https://theory.pqlabs.org/r/...`).
