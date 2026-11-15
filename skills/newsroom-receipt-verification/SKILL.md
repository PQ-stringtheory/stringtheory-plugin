---
name: newsroom-receipt-verification
description: Fact-check political claims, verify campaign finance arithmetic and roll-call vote records, and surface ranked investigative story leads using StringTheory MCP tools (verify_political_claim, find_story_leads).
---

# Newsroom Receipt Verification (`newsroom-receipt-verification`)

Use this skill whenever the user wants to fact-check a political speech, post, draft article, or talking point; verify exact dollar totals, roll-call vote counts, or bill provisions against primary records; or discover high-signal, receipt-backed investigative story leads.

## Core StringTheory MCP Tools

| Tool | Primary Use | Key Parameters |
| :--- | :--- | :--- |
| `verify_political_claim` | Fact-check a political, legislative, voting, or campaign finance claim against Cloud Spanner records using Model 7 (`ClaimVerifier` + arithmetic & record-identity checks), returning `SUPPORTED`, `CONTRADICTED`, or `UNVERIFIED` with exact `/r/...` receipts | `claim_text` (required — pass the exact claim, quote, or draft sentence to verify) |
| `find_story_leads` | Surface ranked investigative leads across 4 newsroom archetypes: party-line defectors, buried omnibus riders, pre-vote STOCK Act conflicts, and 2-hop dark-money/Super PAC surges | `window` (`24h` \| `7d` \| `30d` \| `119th`, default `7d`), `category` (`all` \| `defectors` \| `buried_riders` \| `stock_conflicts` \| `dark_money`, default `all`), `limit` (`1..50`, default `10`) |

## Step-by-Step Verification & Lead-Discovery Workflow

### A. Fact-Checking Claims & Draft Copy (`verify_political_claim`)
1. **Decompose compound claims into atomic checkable assertions**:
   - If a paragraph or post makes multiple distinct factual claims (e.g., a dollar figure from an industry + a roll-call vote + what a bill section mandates), run `verify_political_claim` on the core claim and cross-check any remaining clauses with `search_bill_clauses`, `trace_connections`, or `inspect_race_and_outside_spending`.
2. **Inspect all three verification layers in `VerifyClaimResponse`**:
   - `verdict` (`SUPPORTED`, `CONTRADICTED`, `UNVERIFIED`) + `granular_classification` + `confidence`.
   - `arithmetic_checks`: confirms whether summed contributions, percentages, ratios, or vote tallies match the underlying Spanner rows.
   - `record_identity_checks`: confirms whether the named lawmaker (`bioguide_id`), bill (`bill_id`), roll call (`vote_id`), or FEC committee (`committee_id`) actually matches the cited action (catching classic errors like confusing a procedural motion with final passage or mixing up PAC vs. employee donations).
   - `evidence_receipts`: exact `receipt_id`, `record_type`, `verified_fact`, `source_table`, `app_url`, and `share_receipt_url`.
3. **Report verdicts transparently**:
   - Lead with the verdict (`SUPPORTED`, `CONTRADICTED`, or `UNVERIFIED`), show the exact verified numbers vs. the claimed numbers, and link every `share_receipt_url` (`https://theory.pqlabs.org/r/...`). When a claim is `UNVERIFIED` due to disclosure lag or unindexed local/state records, state the exact coverage boundary rather than guessing.

### B. Discovering Evidence-Backed Story Leads (`find_story_leads`)
1. Call `find_story_leads` filtered by `window` (`24h`, `7d`, `30d`, `119th`) and `category`:
   - `defectors`: Unexpected cross-party votes flagged against Model 4's 6-driver vote prediction baseline.
   - `buried_riders`: High-divergence non-germane sections inside major bills (`Model 1` RiderEntropyDetector).
   - `stock_conflicts`: Pre-vote Congressional STOCK Act PTR disclosures where `t_trade < t_vote` (`Model 5`).
   - `dark_money`: 2-hop Donor -> Super PAC -> Race independent expenditure surges.
2. **Verify & deepen before publishing**:
   - Treat every lead from `find_story_leads` as a starting hypothesis backed by initial `evidence_metrics` and `share_receipt_url`.
   - Drill into top candidates using `xray_bill_and_amendments` (for `buried_riders`), `trace_politician_accountability` / `trace_connections` (for `defectors` and `stock_conflicts`), or `inspect_race_and_outside_spending` (for `dark_money`) so the final brief includes both sides' strongest context (`generate_arguments`) and complete primary-source citations.

## Editorial & Journalistic Guardrails

- **Receipts before rhetoric**: Never publish an unverified number, unnamed "top donor" claim, or paraphrased statutory clause without its `receipt_id` and `share_receipt_url`.
- **Steelman context**: When reporting a party defection, donor alignment delta, or amendment vote, check `compare_members` or `generate_arguments` so constituency drivers and statutory counter-arguments are represented fairly.
- **Zero-quota data notes**: If verification uncovers an upstream filing quirk or user correction, log it immediately via `submit_mcp_feedback` (`category="data"`, `0` quota cost).
