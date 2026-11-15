<p align="center">
  <img src="assets/logo.png" alt="StringTheory" width="96" height="96" />
</p>

<h1 align="center">StringTheory — Official MCP Server & Civic Research Skills</h1>

<p align="center">
  <strong>Connect the dots. Find the story.</strong><br/>
  Nonpartisan U.S. money-in-politics, congressional voting records, clause-by-clause bill text X-rays, lobbying disclosures, STOCK Act trades, and verifiable primary-source receipts for AI agents.
</p>

<p align="center">
  <a href="https://theory.pqlabs.org/developers">Developer Portal</a> ·
  <a href="https://theory.pqlabs.org">Web App</a> ·
  <a href="https://theory.pqlabs.org/privacy">Privacy Policy</a> ·
  <a href="https://theory.pqlabs.org/terms">Terms of Service</a>
</p>

---

## Overview

`PQ-stringtheory/stringtheory-plugin` is the official unified plugin and Model Context Protocol (MCP) package for **StringTheory** (`https://theory.pqlabs.org/api/mcp`).

A single repository powers seamless installation across **Google Antigravity**, **Gemini CLI**, **Anthropic Claude Code & Claude Connectors**, **Cursor**, **OpenAI ChatGPT & Codex**, and the **Official MCP Registry** (`org.pqlabs/stringtheory`) — bundling:

- **Remote Streamable HTTP MCP Server** (`https://theory.pqlabs.org/api/mcp`) with **16 civic intelligence tools**, **Open Knowledge Format (`ontology://`) Civic Dictionary resources**, and **Google A2UI 1.0 (`ui://stringtheory/*`) interactive exhibits**.
- **4 High-Signal Agent Skills** (`civic-research`, `money-to-vote-tracing`, `bill-xray`, `newsroom-receipt-verification`) teaching strict primary-source citation discipline (FEC, Congress.gov, Senate LDA, STOCK Act PTRs) and correlation-vs-causation guardrails.
- **Dual Authentication**:
  1. **1-Click OAuth 2.1 Sign-In (PKCE)** — sign in directly in your browser when prompted by your IDE or AI client (includes **Free `5 calls/day`** instantly, or inherits your paid plan).
  2. **Headless / CI API Keys (`Bearer st_live_...`)** — mint scoped keys at [theory.pqlabs.org/developers](https://theory.pqlabs.org/developers) for automated workflows, CLI agents, and team environments.

---

## Quick Install Across AI Tools

### 1. Google Antigravity

Install directly from GitHub or the Antigravity Agent Marketplace:

```bash
agy plugin install PQ-stringtheory/stringtheory-plugin
```

- **OAuth 2.1 Sign-In**: Click **Sign in** when prompted in Antigravity's Plugins Manager to connect your StringTheory account in one click.
- **Optional API Key (`Bearer st_live_...`)**: In `~/.gemini/config/mcp_config.json`:
  ```json
  {
    "mcpServers": {
      "stringtheory": {
        "serverUrl": "https://theory.pqlabs.org/api/mcp",
        "headers": {
          "Authorization": "Bearer st_live_YOUR_API_KEY"
        }
      }
    }
  }
  ```

---

### 2. Gemini CLI

Install as a Gemini CLI extension (bundles `gemini-extension.json`, `GEMINI.md`, and the remote MCP server):

```bash
gemini extensions install https://github.com/PQ-stringtheory/stringtheory-plugin
```

- On first tool invocation, Gemini CLI launches the OAuth 2.1 browser flow automatically, or you can pass an `Authorization: Bearer st_live_...` header in `~/.gemini/settings.json`.

---

### 3. Anthropic Claude (`Claude Code` & `Claude.ai Connectors`)

#### Claude Code (Full Plugin: MCP + 4 Skills)

```bash
claude plugin marketplace add PQ-stringtheory/stringtheory-plugin
claude plugin install stringtheory
```

#### Claude Code (Direct MCP Server Only)

```bash
# Interactive OAuth 2.1 Sign-In
claude mcp add --transport http stringtheory https://theory.pqlabs.org/api/mcp

# Or with a headless st_live_... API key
claude mcp add --transport http stringtheory https://theory.pqlabs.org/api/mcp \
  --header "Authorization: Bearer st_live_YOUR_API_KEY"
```

#### Claude.ai & Claude Desktop Connectors

1. Open **Settings -> Connectors -> Add Custom Connector**.
2. Enter URL: `https://theory.pqlabs.org/api/mcp`
3. Complete the **1-click OAuth 2.1 Sign-In** flow in your browser.

---

### 4. Cursor

Install **StringTheory** from the **Cursor Plugin Directory** (`.cursor-plugin/plugin.json`), or add to `.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "stringtheory": {
      "type": "http",
      "url": "https://theory.pqlabs.org/api/mcp"
    }
  }
}
```

- Cursor automatically discovers OAuth 2.1 on `https://theory.pqlabs.org/api/mcp` and prompts **Connect** in MCP Settings.
- For headless/key-based auth, add `"headers": { "Authorization": "Bearer st_live_YOUR_API_KEY" }`.

---

### 5. ChatGPT & OpenAI Codex

#### ChatGPT Connectors / Developer Mode

1. Open **Settings -> Connectors -> Create** (MCP Server).
2. Set MCP Server URL to `https://theory.pqlabs.org/api/mcp` and complete OAuth 2.1 sign-in.

#### OpenAI Codex CLI & Codex Plugin Directory (`.codex-plugin`)

Install from the Codex Plugin Directory (or download the `.zip` archive from GitHub Releases), or add directly to `~/.codex/config.toml`:

```toml
[mcp_servers.stringtheory]
url = "https://theory.pqlabs.org/api/mcp"
# Optional for headless API key auth (omit to use interactive OAuth 2.1):
bearer_token_env_var = "STRINGTHEORY_API_KEY"
```

---

## 16 StringTheory MCP Tools

Every billable tool call is metered flat at **`1 call = 1 call`** — even multi-step `research_stringtheory` investigations. Protocol handshakes (`initialize`, `tools/list`, `resources/list`, `resources/read`, `prompts/list`) and `submit_mcp_feedback` cost **`0` quota**.

| Tool | Category | What It Does |
| :--- | :--- | :--- |
| `research_stringtheory` | Deep Research | Primary multi-step civic research engine across bills, clauses, roll-call votes, FEC Schedule A/B/E filings, 2-to-4 hop graph paths, and STOCK Act PTR trades with verified Cloud Spanner receipts, A2UI 1.0 surfaces, Social Share Studio cards (`16:9` / `4:5` / `9:16`), and 4-format Work Exports (`article`, `policy_memo`, `legislation`, `report`). |
| `ask_stringtheory` | Deep Research | Backward-compatible alias for `research_stringtheory` with identical live synthesis, citations, and Work Exports. |
| `resolve_entities` | Entity Resolution | Fuzzy-search and resolve lawmakers (`bioguide_id`), bills (`bill_id`), federal races (`race_id`), PACs/committees (`committee_id`), and 56 policy initiatives (`initiative_slug`) with canonical deep links. |
| `trace_connections` | Money & Graph | Bounded 2-to-4 hop Cloud Spanner `PoliticalGraph` path traversal (`from` + `to`) plus single-entity pre-vote STOCK Act PTR conflict tracing (`t_trade < t_action`) and 2-hop Donor -> Super PAC -> Candidate attribution. |
| `search_bill_clauses` | Legislation | Hybrid full-text + vector Reciprocal Rank Fusion search across `bill_sections`, `committee_reports`, and Congressional Record `floor_speeches` (`CREC`) with `<DELETED>` GPO XML blocks stripped automatically. |
| `xray_bill_and_amendments` | Legislation | Clause-by-clause bill X-ray classifying division/section policy mechanisms, mandates/prohibitions, buried omnibus riders (`buried_riders_only`), and 4-pattern Before vs. After floor amendment diffs. |
| `generate_arguments` | Legislation | Steelman Pro and Con legislative arguments anchored to exact statutory clauses, dollar amounts, roll-call votes, and swing-member coalition signals. |
| `get_politician_initiatives` | Accountability | Pre-materialized convictions across 56 policy initiatives, directional stance polarity (`-1.0` to `+1.0`), Effort/Effectiveness/Bipartisanship grades, and peer lift (`CONGRESS_119`, `CONGRESS_118`, `ROLLING_90D`, `ROLLING_365D`, `CAREER`). |
| `inspect_race_and_outside_spending` | Campaign Finance | Reconciles candidate Form 3/3P fundraising with Super PAC Schedule E independent expenditures (periodic + 24/48-hour notices), Support vs. Oppose targeting, attack share, and outside-to-campaign ratios. |
| `trace_politician_accountability` | Accountability | Combines 6-driver roll-call vote forecast waterfalls with donor-vote deltas, donor-bill deltas, 2-hop Super PAC attribution, and pre-vote STOCK Act PTR conflict receipts (`t_trade < t_vote`). |
| `compare_members` | Voting Records | Head-to-head roll-call agreement rate, exact roll-call disagreements filtered by policy subject, and `closest_allies` (`other_party` bipartisan allies or `all` chamber peers). |
| `rank_and_trend_members` | Voting Records | Multi-Congress career trajectories (107th–119th Congress vs. `peer_median`), chamber/party leaderboards (`party_breaks`, `party_loyalty`, `bipartisan_reach`, `missed_votes`, `bills_sponsored`, `became_law`), and 10% outlier checks. |
| `trace_presidential_actions` | Executive Branch | Tracks presidential vetoes, pocket vetoes, executive orders, signed laws, and a lawmaker's veto-override roll-call votes (`member_on_vetoes`). |
| `verify_political_claim` | Fact-Checking | Audits political, voting, statutory, or campaign finance claims with arithmetic and record-identity checks, returning `SUPPORTED`, `CONTRADICTED`, or `UNVERIFIED` plus `/r/...` evidence receipts. |
| `find_story_leads` | Newsroom | Surfaces ranked investigative story leads across `defectors`, `buried_riders`, `stock_conflicts`, and `dark_money` over configurable time windows (`24h`, `7d`, `30d`, `119th`). |
| `submit_mcp_feedback` | Feedback (`Free`) | Sends bug reports, data quality notes, or feature requests directly to the StringTheory team at **`0` quota cost**. |

---

## 4 Bundled Agent Skills

| Skill | Directory | Focus |
| :--- | :--- | :--- |
| **`civic-research`** | `skills/civic-research/SKILL.md` | Entity resolution, multi-hop civic investigations, head-to-head member comparisons, multi-Congress career trends, presidential action tracking, and nonpartisan primary-source citation rules. |
| **`money-to-vote-tracing`** | `skills/money-to-vote-tracing/SKILL.md` | Following campaign contributions, 2-hop Super PAC independent expenditures, lobbying filings, and pre-vote STOCK Act trades (`t_trade < t_action`) to roll-call votes — strictly separating statistical association/sequence from unproven quid-pro-quo causation. |
| **`bill-xray`** | `skills/bill-xray/SKILL.md` | Clause-level statutory text search, `<DELETED>`-clean GPO parsing, buried omnibus rider detection, 4-pattern floor amendment diffs, and steelman Pro/Con impact analysis. |
| **`newsroom-receipt-verification`** | `skills/newsroom-receipt-verification/SKILL.md` | Atomic fact-checking of political claims, FEC/roll-call arithmetic verification, and evidence-backed investigative lead discovery. |

---

## Plans & Flat `1 Call = 1 Call` Quotas

Manage your OAuth connections, `st_live_...` API keys, and usage at **[theory.pqlabs.org/developers](https://theory.pqlabs.org/developers)**.

| Tier / Pack | Included Allowance | Auth Methods | Notes |
| :--- | :--- | :--- | :--- |
| **Free** | **`5` calls / day** | OAuth 2.1 Sign-In | Instant zero-key trial across Claude, Cursor, ChatGPT, Codex, Gemini CLI, and Antigravity |
| **Pro** | **`1,000` calls / month** | OAuth 2.1 + `st_live_...` API keys | Flat `1 call = 1 call` metering across all 15 billable tools |
| **Builder** | **`5,000` calls / month** | OAuth 2.1 + `st_live_...` API keys | Ideal for daily agentic workflows, civic apps, and policy analysts |
| **Scale** | **`20,000` calls / month** | OAuth 2.1 + `st_live_...` API keys | Built for newsrooms, research desks, and high-throughput pipelines |
| **`mcp_2k_pack`** | **`+2,000` calls / pack** | Automatically drawn down after base quota | Top-up add-on pack (`submit_mcp_feedback`, `ontology://`, and `ui://` reads are always `0` cost) |

---

## Repository Layout

```text
stringtheory-plugin/
├── assets/logo.png                 # 512x512 StringTheory 3-node civic mark
├── skills/
│   ├── civic-research/SKILL.md
│   ├── money-to-vote-tracing/SKILL.md
│   ├── bill-xray/SKILL.md
│   └── newsroom-receipt-verification/SKILL.md
├── plugin.json                     # Google Antigravity root manifest
├── .antigravity-plugin/plugin.json # Google Antigravity scoped manifest
├── mcp_config.json                 # Google Antigravity MCP server config
├── gemini-extension.json           # Gemini CLI extension manifest
├── GEMINI.md                       # Gemini CLI context & citation rules
├── .cursor-plugin/plugin.json      # Cursor Marketplace manifest
├── mcp.json                        # Cursor MCP server config
├── .claude-plugin/
│   ├── plugin.json                 # Anthropic Claude Code plugin manifest
│   └── marketplace.json            # Anthropic Claude Code marketplace catalog
├── .codex-plugin/plugin.json       # OpenAI ChatGPT & Codex plugin manifest
├── .mcp.json                       # Claude Code & OpenAI Codex MCP server config
├── server.json                     # Official MCP Registry (org.pqlabs/stringtheory)
└── LICENSE                         # Apache-2.0
```

---

## Links & Support

- **Developer Portal & API Keys**: [https://theory.pqlabs.org/developers](https://theory.pqlabs.org/developers)
- **StringTheory Web App**: [https://theory.pqlabs.org](https://theory.pqlabs.org)
- **Privacy Policy**: [https://theory.pqlabs.org/privacy](https://theory.pqlabs.org/privacy)
- **Terms of Service**: [https://theory.pqlabs.org/terms](https://theory.pqlabs.org/terms)
- **Support**: [support@pqlabs.org](mailto:support@pqlabs.org) (or ask your agent to call `submit_mcp_feedback` for free!)

## License

Licensed under the [Apache License 2.0](LICENSE).
