import { module, test } from "qunit";
import { newestUpdate, toRow } from "../../../discourse/lib/quotes";

const NOW = 1_800_000_000_000;
const seconds = (ms) => Math.floor(ms / 1000);
const ticker = { coingecko_id: "bitcoin", ticker: "BTC", icon: "ph-dt-btc" };
const quote = (usd, change, ageMs = 0) => ({
  usd,
  usd_24h_change: change,
  last_updated_at: seconds(NOW - ageMs),
});

module("Unit | crypto-tickers | quotes", function () {
  test("uses two decimals at one dollar or more", function (assert) {
    assert.strictEqual(toRow(ticker, quote(78605, 1), NOW).price, "78,605.00");
    assert.strictEqual(toRow(ticker, quote(1, 1), NOW).price, "1.00");
  });

  test("uses four decimals below one dollar", function (assert) {
    assert.strictEqual(toRow(ticker, quote(0.325848, 1), NOW).price, "0.3258");
  });

  test("direction follows the sign of the change", function (assert) {
    assert.strictEqual(toRow(ticker, quote(5, 0.1), NOW).direction, "up");
    assert.strictEqual(toRow(ticker, quote(5, -0.1), NOW).direction, "down");
    assert.strictEqual(toRow(ticker, quote(5, 0), NOW).direction, null);
    assert.strictEqual(toRow(ticker, quote(5, null), NOW).direction, null);
  });

  test("a quote at 15 minutes is kept and older is dropped", function (assert) {
    const limit = 15 * 60 * 1000;
    assert.strictEqual(toRow(ticker, quote(5, 1, limit), NOW).price, "5.00");

    const stale = toRow(ticker, quote(5, 1, limit + 1000), NOW);
    assert.strictEqual(stale.price, null);
    assert.strictEqual(stale.direction, null);
  });

  test("a missing quote has no price or direction", function (assert) {
    const row = toRow(ticker, undefined, NOW);
    assert.strictEqual(row.ticker, "BTC");
    assert.strictEqual(row.icon, "ph-dt-btc");
    assert.strictEqual(row.price, null);
    assert.strictEqual(row.direction, null);
  });

  test("newestUpdate returns the latest time in milliseconds", function (assert) {
    assert.strictEqual(
      newestUpdate({ a: { last_updated_at: 10 }, b: { last_updated_at: 20 } }),
      20000
    );
    assert.strictEqual(
      newestUpdate({ a: { last_updated_at: 10 }, b: {} }),
      10000
    );
    assert.strictEqual(newestUpdate({}), null);
    assert.strictEqual(newestUpdate(null), null);
  });
});
