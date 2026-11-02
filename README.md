# Crypto Tickers

**ENGLISH** | [ESPAÑOL](README.es.md)

Maintained by Criptonautas. Not affiliated with or endorsed by Discourse (Civilized Discourse Construction Kit, Inc.).

Current crypto prices in USD from CoinGecko, for the right sidebar. Each row shows the price and a line for its 24-hour direction. Prices refresh every 5 minutes while the tab is visible.

## Install

Install [Right Sidebar Blocks](https://github.com/discourse/discourse-right-sidebar-blocks) and [discourse-phosphor-duotone-icons](https://github.com/somos-criptonautas/discourse-phosphor-duotone-icons). Upload this component, attach it to your theme, and add this row to the Right Sidebar Blocks `blocks` setting:

    { "name": "crypto-tickers" }

The sidebar shows on desktop topic lists only.

## Settings

`tickers` sets the coins and their order. `coingecko_id` is the last part of the coin's CoinGecko page URL. A wrong ID shows a dash in that row.

## Privacy

Each visitor's browser calls CoinGecko directly, so CoinGecko sees the visitor's IP address.

## License

MIT. See [LICENSE](LICENSE).

Text of this README under [CC BY-NC-SA 4.0](CC-BY-NC-SA-4.0.txt).
