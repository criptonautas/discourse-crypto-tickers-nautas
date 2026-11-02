# Crypto Tickers

**ENGLISH** | [ESPAÑOL](README.es.md)

Maintained by Criptonautas. Not affiliated with or endorsed by Discourse (Civilized Discourse Construction Kit, Inc.).

Discourse theme component showing current crypto prices in USD from CoinGecko, for the right sidebar. It reports prices and nothing more: no percentages and no green or red.

```
◐ BTC           78,605.00   ↗
◐ ETH            2,306.85   ↗
◐ XMR              601.62   ↘
◐ PAXG           3,913.85   ↗
◐ XNO              0.3258   ↗

       updated 3 min ago
        USD · CoinGecko
```

## Features

- **Prices in USD**, with two decimals at $1 or more and four below $1.
- **A line for the 24-hour direction**, up or down, in the text colour. The percentage is never shown.
- **An "updated X min ago" line**, taken from CoinGecko's own timestamps.
- **Coins and order set in the theme settings**, with no code changes.
- **Refresh every 5 minutes** while the tab is visible. Returning to a topic list reuses the last prices instead of calling CoinGecko again.
- **No backend and no API key.**

## Requirements

| Needed | Why |
|---|---|
| [Right Sidebar Blocks](https://github.com/discourse/discourse-right-sidebar-blocks) | Places the card in the sidebar |
| [discourse-phosphor-duotone-icons](https://github.com/somos-criptonautas/discourse-phosphor-duotone-icons) | Provides the default icons, including `ph-dt-ingot` for PAXG |

`ph-dt-ingot` is on that component's `feat/ingot-icon` branch until it is merged. Without it, the PAXG row has a blank icon.

## Install

1. Install both required components.
2. Upload this component in **Admin > Customize > Themes** and attach all three to your active theme.
3. Add this row to the Right Sidebar Blocks `blocks` setting:

   ```json
   { "name": "crypto-tickers" }
   ```

The sidebar shows on desktop topic lists only, never on topic pages or phones.

## Settings

`tickers` sets the coins and their order. Use move up and move down in the editor to reorder them.

| Property | Required | Example | Meaning |
|---|---|---|---|
| `coingecko_id` | yes | `monero` | Last part of the coin's CoinGecko page URL, as in `coingecko.com/en/coins/monero` |
| `ticker` | yes | `XMR` | Label shown in the row |
| `icon` | no | `ph-dt-xmr` | Icon name; empty leaves a blank slot |

## When something fails

| Case | Result |
|---|---|
| First request still loading | One row per coin with dashes |
| First request fails | Card hides |
| Later request fails, including a rate limit | Keeps the last prices; the updated line keeps counting |
| A price is over 15 minutes old | That row shows a dash |
| A wrong `coingecko_id` | That row shows a dash |

## Privacy and limits

Each visitor's browser calls CoinGecko directly, so CoinGecko sees the visitor's IP address.

CoinGecko's keyless API limits requests per IP address and publishes no number for it, so members sharing an IP address may see older prices or dashes. Read CoinGecko's API terms before using this on your site. The card always credits CoinGecko.

## Files

| Path | Purpose |
|---|---|
| `about.json` | Component metadata |
| `settings.yml` | The `tickers` setting and its defaults |
| `javascripts/discourse/components/crypto-tickers.gjs` | Fetching, refresh and rendering |
| `javascripts/discourse/lib/quotes.js` | Price formatting, direction and the 15-minute rule |
| `common/common.scss` | Card styles |
| `locales/en.yml`, `locales/es.yml` | Copy and setting descriptions |
| `test/` | QUnit unit and integration tests |
| `.github/workflows/discourse-theme.yml` | Lint and tests in CI |

## Development

```bash
pnpm install
pnpm lint
```

CI runs lint and QUnit on pull requests and on pushes to `main`.

## License

MIT. See [LICENSE](LICENSE).

Text of this README under [CC BY-NC-SA 4.0](CC-BY-NC-SA-4.0.txt).
