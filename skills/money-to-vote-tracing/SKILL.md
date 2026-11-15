---
name: money-to-vote-tracing
description: Trace campaign contributions, 2-hop Super PAC independent expenditures, lobbying disclosures, STOCK Act trades, and 56-initiative policy stances to congressional votes and committee actions using StringTheory MCP tools (trace_connections, trace_politician_accountability, inspect_race_and_outside_spending, get_politician_initiatives).
---

# Money-to-Vote Tracing (`money-to-vote-tracing`)

Use this skill when the user asks who funds a politician or race, how Super PAC outside spending compares to campaign fundraising, whether a lawmaker traded stocks before a committee or floor action, or how donor sectors align with a member's voting record and policy initiatives.

## Core StringTheory MCP Tools

| Tool | Primary Use | Key Parameters |
| :--- | :--- | :--- |
| `trace_connections` | Bounded 2-to-4 hop Cloud Spanner `PoliticalGraph` path traversal (`from` + `to`) OR single-entity STOCK Act PTR (`t_trade < t_action`) & 2-hop Donor -> PAC -> Candidate trace (`entity`) | Path mode: `from` + `to`, `max_hops` (`2..4`, default `3`), `source_type`, `target_type`. Entity mode: `entity` (`bioguide_id` or `bill_id`), `target_kind` (`all` \| `stock_trades` \| `pac_flows`). Shared: `cycle` (default `2026`), `congress` (default `119`), `limit` (`1..25`) |
| `trace_politician_accountability` | Retrieve Model 4 (6-driver vote prediction waterfall) and Model 5 accountability signals (`donor_votes_delta`, `donor_bills_delta`, 2-hop Super PAC attribution, and pre-vote STOCK Act PTR receipts) | `bioguide_id` (required), `sector` (optional, e.g., `Health & Pharma`, `Defense & Aerospace`), `congress` (default `119`) |
| `inspect_race_and_outside_spending` | Reconcile candidate Form 3/3P fundraising with Super PAC Schedule E independent expenditures (periodic + 24/48-hour notices), Support vs. Oppose targeting, attack share, and outside-to-campaign ratio | `race_id` (e.g., `2026-S-MI-00`, `2026-H-NY-17`) OR `state` + `chamber` (`senate` \| `house` \| `president`) + `district`, `cycle` (default `2026`) |
| `get_politician_initiatives` | Inspect a lawmaker's pre-materialized convictions across 56 policy initiatives, directional stance polarity (`-1.0` to `+1.0`), Effort/Effectiveness/Bipartisanship grades, and peer lift | `bioguide_id` (or `initiative_id` such as `init_ai_governance` for chamber leaderboards), `window_key` (`CONGRESS_119` \| `CONGRESS_118` \| `ROLLING_90D` \| `ROLLING_365D` \| `CAREER`), `limit` (`1..56`) |

## Step-by-Step Workflow

### 1. Resolve Entities First
If you do not have exact canonical IDs (`bioguide_id`, `race_id`, `committee_id`, or `bill_id`), call `resolve_entities` first so every downstream graph query hits the exact Cloud Spanner node.

### 2. Trace Direct, Outside, and Multi-Hop Money Flows
- **Race-wide money & outside spending**: Call `inspect_race_and_outside_spending` (`race_id` or `state` + `chamber` + `cycle`) to separate candidate campaign committee receipts (FEC Form 3/3P) from outside independent expenditures (FEC Schedule E `support` vs. `oppose`). Always report **For** vs. **Against** independent expenditures separately — opposing spending paid *against* an opponent is not money given *to* a candidate's campaign.
- **2-hop Super PAC attribution & STOCK Act conflicts**: Call `trace_connections` with `entity=<bioguide_id>` and `target_kind="all"` (or `"pac_flows"` / `"stock_trades"`), or call `trace_politician_accountability` with `bioguide_id` and an optional `sector` filter.
- **Specific entity-to-entity paths**: Call `trace_connections` with `from` (e.g., donor/PAC `C00835959`, ticker `NVDA`, or lawmaker `L000599`) and `to` (e.g., `119-hr-3633` or `C00799031`) with `max_hops=3` or `4` to retrieve verified hop edges and filing references.

### 3. Connect Financial Context to Legislative Record
- Pair `trace_politician_accountability` (which provides the Model 4 6-driver vote forecast waterfall showing party baseline vs. constituency vs. donor-sector residuals) with `get_politician_initiatives` (`window_key="CONGRESS_119"` or `"CAREER"`) to check whether a single roll-call vote matches or diverges from the lawmaker's broader legislative record.

## Mandatory Methodological & Causation Guardrails

1. **Correlation and sequence — NEVER unproven quid-pro-quo causation**:
   - `trace_connections` explicitly sets `statistical_association_not_causation: true`.
   - Report campaign contributions, employee-donor totals, Super PAC independent expenditures, lobbying filings, and roll-call votes as **verified chronological sequence, co-occurrence, or statistical alignment** — never assert bribery, corruption, or quid-pro-quo causation.
2. **Distinguish PAC vs. individual employee contributions**:
   - In FEC data (`pac_total_usd` vs. `employee_total_usd`), individuals listing an employer on Schedule A are employees donating personal funds, not corporate treasury contributions. Always keep corporate/trade PAC contributions distinct from individual employee donations.
3. **Enforce strict temporal ordering (`t_trade < t_action`) on STOCK Act trades**:
   - Only cite Congressional Periodic Transaction Reports (PTRs) as pre-vote trades when `transaction_date` strictly precedes the committee action or floor vote (`days_before_vote > 0`, `point_in_time_valid: true`), and report the statutory disclosure range alongside `amount_midpoint_usd`.
4. **Respect `finance_coverage_status`**:
   - Distinguish `legislative_only` coverage (e.g., historical or unindexed cycles) from `$0` raised. Read `ontology://fec_rules/...` (`0` quota cost) whenever explaining FEC attribution or STOCK Act rules.
5. **Cite every hop's filing receipt**:
   - Include `DonorHopFilingRef`, `PACHopFilingRef`, `PTRTradeID` / `FilingID`, `receipt_ids`, and `share_receipt_url` (`https://theory.pqlabs.org/r/...`) for every path you present.
