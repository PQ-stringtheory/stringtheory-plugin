---
name: civic-research
description: Conduct nonpartisan U.S. congressional, campaign finance, voting-record, career-trend, and presidential-action investigations using StringTheory MCP tools (resolve_entities, research_stringtheory, ask_stringtheory, compare_members, rank_and_trend_members, trace_presidential_actions) with primary-source receipts.
---

# Civic Research (`civic-research`)

Use this skill whenever the user asks about U.S. lawmakers, congressional voting records, bipartisan coalitions, career voting trajectories, presidential vetoes or executive orders, or multi-hop civic questions combining bills, votes, lobbying, and money.

## Core StringTheory MCP Tools

| Tool | Primary Use | Key Parameters |
| :--- | :--- | :--- |
| `resolve_entities` | Resolve free-text names or nicknames into canonical StringTheory IDs (`bioguide_id`, `bill_id`, `race_id`, `committee_id`, `initiative_slug`) and verified web links | `query` (required), `entity_type` (`all` \| `politician` \| `bill` \| `race` \| `committee` \| `initiative`), `state`, `congress` (default `119`), `limit` (`1..25`) |
| `research_stringtheory` | Run live multi-step civic research across legislation, roll-call votes, FEC Schedule A/B/E filings, lobbying, and STOCK Act disclosures (`1 call = 1 call`) | `query` (required), `congress` (default `119`), `conversation_id`, `export_format` (`none` \| `article` \| `policy_memo` \| `legislation` \| `report` \| `all`), `social_aspect_ratio` (`16:9` \| `4:5` \| `9:16`), `include_ui` |
| `ask_stringtheory` | Backward-compatible alias for `research_stringtheory` with identical live multi-step synthesis, citations, and Work Exports | Same as `research_stringtheory` (`query` or `question`, `congress`, `conversation_id`, `export_format`) |
| `compare_members` | Compare two lawmakers head-to-head on shared roll-call votes (`member_agreement` + exact disagreements) and surface `closest_allies` | `member_a` (required `bioguide_id`), `member_b` (optional `bioguide_id`), `scope` (`other_party` \| `all`), `subject` (e.g., `Health`, `Taxation`), `congress` (default `119`) |
| `rank_and_trend_members` | Inspect 107th–119th Congress career trends (`peer_median` reference), chamber/party leaderboards, 10% outlier flags (`unusual`), and `topic_breakers` | `bioguide_id` (optional), `metric` (`party_breaks` \| `party_loyalty` \| `bipartisan_reach` \| `missed_votes` \| `bills_sponsored` \| `became_law`), `peers` (`party_chamber` \| `chamber`), `chamber` (`house` \| `senate`), `party` (`R` \| `D` \| `I`), `subject`, `congress` |
| `trace_presidential_actions` | Track presidential vetoes, pocket vetoes, executive orders, signed laws, and a lawmaker's veto-override votes (`member_on_vetoes`) | `action_type` (`all` \| `vetoes` \| `executive_orders` \| `signed_laws`), `congress` (default `119`), `president`, `bioguide_id` |

## Step-by-Step Workflow

### 1. Resolve Canonical IDs Before Structured Lookups
Never guess a Bioguide ID, FEC committee ID, or bill number. Call `resolve_entities` first whenever you do not already hold an exact ID:
- Lawmakers resolve to uppercase Bioguide IDs (`B001288` for Cory Booker, `C001035` for Susan Collins, `L000599` for Mike Lawler).
- Bills resolve to `{congress}-{type}-{number}` (`119-hr-1`, `119-s-1582`).
- Federal races resolve to `{cycle}-{office}-{state}-{district}` (`2026-S-MI-00`, `2026-H-NY-17`).
- FEC committees resolve to `C...` (`C00835959`).

### 2. Route to Structured Tools vs. Multi-Step Research
- **Structured comparisons, rankings, or executive actions**: Call `compare_members`, `rank_and_trend_members`, or `trace_presidential_actions` directly with the resolved `bioguide_id` for deterministic metrics and peer baselines.
- **Broad or cross-domain investigations**: Call `research_stringtheory` with `query` and `congress`. Reuse the returned `conversation_id` on follow-up questions so multi-turn context stays intact. When the user wants a polished memo, briefing, or article draft, set `export_format` (`policy_memo`, `article`, `legislation`, or `report`).
- **Zero-quota context lookup**: Read `ontology://stringtheory/index` or `ontology://procedures/...` / `ontology://topics/...` via MCP resources (`0` quota cost) when explaining Senate cloture thresholds, House special rules, or CRS policy jurisdictions.

### 3. Enforce Strict Nonpartisan Primary-Source Citation Discipline
Every factual claim in your answer must carry verifiable primary-source provenance:
1. **Anchor every number and vote to its primary record**: Cite the official source domain alongside StringTheory's receipt — **FEC** (`committee_id`, filing reference, election cycle), **Congress.gov** (`bill_id`, statutory section, roll-call vote ID, date), or **Senate LDA** (lobbying registrant/client filing).
2. **Include StringTheory share receipts**: Surface the returned `share_receipt_url` (resolved against `https://theory.pqlabs.org`, e.g., `https://theory.pqlabs.org/r/...`) and canonical entity URLs (`/politician/{id}`, `/bills/{id}`) so readers can inspect the underlying records directly.
3. **Separate procedural votes from final passage**: Never claim a lawmaker "voted against a bill's policy" on a procedural gate (`is_final_passage=false` — cloture, rule adoption, motion to recommit, motion to table) without explicitly stating that the vote was procedural.
4. **Maintain strict nonpartisan framing**: Report identical metrics, peer medians (`party_chamber` vs. `chamber`), and verbatim statutory anchors across parties without editorializing.
5. **Capture user feedback for free**: If the user spots a data question or shares product feedback, call `submit_mcp_feedback` (`0` quota cost).
