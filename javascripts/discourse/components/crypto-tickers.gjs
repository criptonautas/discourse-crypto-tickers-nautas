import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { registerDestructor } from "@ember/destroyable";
import { htmlSafe } from "@ember/template";
import icon from "discourse/helpers/d-icon";
import { bind } from "discourse/lib/decorators";
import { autoUpdatingRelativeAge } from "discourse/lib/formatter";
import { i18n } from "discourse-i18n";
import { newestUpdate, toRow } from "../lib/quotes";

const API_URL = "https://api.coingecko.com/api/v3/simple/price";
const REFRESH_MS = 5 * 60 * 1000;
const DASH = "—";
const DIRECTION_ICONS = {
  up: "ph-dt-chart-line-up",
  down: "ph-dt-chart-line-down",
};

export default class CryptoTickers extends Component {
  @tracked quotes = null;
  @tracked failed = false;
  @tracked now = Date.now();
  lastRequest = 0;

  constructor() {
    super(...arguments);

    const interval = setInterval(this.refresh, REFRESH_MS);
    document.addEventListener("visibilitychange", this.onVisibilityChange);
    registerDestructor(this, () => {
      clearInterval(interval);
      document.removeEventListener("visibilitychange", this.onVisibilityChange);
    });

    this.refresh();
  }

  get tickers() {
    return settings.tickers || [];
  }

  get hidden() {
    return this.failed || !this.tickers.length;
  }

  get rows() {
    return this.tickers.map((ticker) => {
      const row = toRow(ticker, this.quotes?.[ticker.coingecko_id], this.now);

      return {
        ...row,
        directionIcon: DIRECTION_ICONS[row.direction],
        displayPrice: row.price || DASH,
        label: this.labelFor(row),
      };
    });
  }

  get updatedAge() {
    const updated = newestUpdate(this.quotes);

    return updated
      ? htmlSafe(
          autoUpdatingRelativeAge(new Date(updated), {
            format: "medium",
            leaveAgo: true,
          })
        )
      : null;
  }

  labelFor({ ticker, price, direction }) {
    const key = !price ? "unavailable" : direction || "flat";

    return i18n(themePrefix(`crypto_tickers.row.${key}`), { ticker, price });
  }

  @bind
  onVisibilityChange() {
    if (Date.now() - this.lastRequest >= REFRESH_MS) {
      this.refresh();
    }
  }

  @bind
  async refresh() {
    if (document.hidden || !this.tickers.length) {
      return;
    }

    this.lastRequest = Date.now();
    const url = new URL(API_URL);
    url.search = new URLSearchParams({
      ids: this.tickers.map((ticker) => ticker.coingecko_id).join(","),
      vs_currencies: "usd",
      include_24hr_change: "true",
      include_last_updated_at: "true",
    });

    let quotes = null;
    try {
      const response = await fetch(url.toString());
      quotes = response.ok ? await response.json() : null;
    } catch {
      // A failure is handled below: keep the last prices, or hide without any.
    }

    if (this.isDestroying || this.isDestroyed) {
      return;
    }

    if (quotes) {
      this.quotes = quotes;
    }
    this.failed = !this.quotes;
    this.now = Date.now();
  }

  <template>
    {{#if this.hidden}}
      {{! An empty marker, so the sidebar's card can hide itself with :has() }}
      <div class="crypto-tickers --hidden"></div>
    {{else}}
      <div class="crypto-tickers">
        <ul class="crypto-tickers__list">
          {{#each this.rows key="ticker" as |row|}}
            <li>
              <span class="sr-only">{{row.label}}</span>
              <span class="crypto-tickers__row" aria-hidden="true">
                <span class="crypto-tickers__icon">
                  {{#if row.icon}}{{icon row.icon}}{{/if}}
                </span>
                <span class="crypto-tickers__ticker">{{row.ticker}}</span>
                <span class="crypto-tickers__price">{{row.displayPrice}}</span>
                <span class="crypto-tickers__direction">
                  {{#if row.directionIcon}}{{icon row.directionIcon}}{{/if}}
                </span>
              </span>
            </li>
          {{/each}}
        </ul>

        {{#if this.updatedAge}}
          <p class="crypto-tickers__updated">
            {{i18n (themePrefix "crypto_tickers.updated")}}
            {{this.updatedAge}}
          </p>
        {{/if}}
        <p class="crypto-tickers__credit">USD · CoinGecko</p>
      </div>
    {{/if}}
  </template>
}
