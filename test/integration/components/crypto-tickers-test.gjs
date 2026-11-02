import { render } from "@ember/test-helpers";
import { module, test } from "qunit";
import sinon from "sinon";
import { setupRenderingTest } from "discourse/tests/helpers/component-test";
import CryptoTickers from "../../../discourse/components/crypto-tickers";

const flush = () => new Promise((resolve) => setTimeout(resolve));
const MINUTE = 60 * 1000;

function jsonResponse(body) {
  return Promise.resolve(new Response(JSON.stringify(body), { status: 200 }));
}

function nowSeconds() {
  return Math.floor(Date.now() / 1000);
}

function liveQuotes() {
  return {
    bitcoin: {
      usd: 78605,
      usd_24h_change: 1.2,
      last_updated_at: nowSeconds(),
    },
    nano: {
      usd: 0.3258,
      usd_24h_change: -0.3,
      last_updated_at: nowSeconds(),
    },
  };
}

module("Integration | Component | crypto-tickers", function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    this.originalTickers = settings.tickers;
    settings.tickers = [
      { coingecko_id: "nano", ticker: "XNO", icon: "ph-dt-lightning" },
      { coingecko_id: "bitcoin", ticker: "BTC", icon: "ph-dt-btc" },
      { coingecko_id: "not-a-coin", ticker: "BAD", icon: "" },
    ];
    this.fetchStub = sinon.stub(window, "fetch");
  });

  hooks.afterEach(function () {
    settings.tickers = this.originalTickers;
    sinon.restore();
  });

  test("renders rows in setting order and requests every id", async function (assert) {
    this.fetchStub.callsFake(() => jsonResponse(liveQuotes()));

    await render(<template><CryptoTickers /></template>);
    await flush();

    const url = new URL(this.fetchStub.firstCall.args[0]);
    assert.strictEqual(url.searchParams.get("ids"), "nano,bitcoin,not-a-coin");
    assert.strictEqual(url.searchParams.get("vs_currencies"), "usd");

    const tickers = [...document.querySelectorAll(".crypto-tickers__ticker")];
    assert.deepEqual(
      tickers.map((el) => el.textContent.trim()),
      ["XNO", "BTC", "BAD"]
    );

    const prices = [...document.querySelectorAll(".crypto-tickers__price")];
    assert.deepEqual(
      prices.map((el) => el.textContent.trim()),
      ["0.3258", "78,605.00", "—"]
    );
  });

  test("shows direction icons and no percentage", async function (assert) {
    this.fetchStub.callsFake(() => jsonResponse(liveQuotes()));

    await render(<template><CryptoTickers /></template>);
    await flush();

    assert
      .dom(".crypto-tickers .d-icon-ph-dt-chart-line-down")
      .exists({ count: 1 });
    assert
      .dom(".crypto-tickers .d-icon-ph-dt-chart-line-up")
      .exists({ count: 1 });
    assert.false(
      document.querySelector(".crypto-tickers").textContent.includes("%")
    );
  });

  test("shows the updated line and the credit", async function (assert) {
    this.fetchStub.callsFake(() => jsonResponse(liveQuotes()));

    await render(<template><CryptoTickers /></template>);
    await flush();

    assert.dom(".crypto-tickers__updated .relative-date").exists();
    assert.dom(".crypto-tickers__credit").hasText("USD · CoinGecko");
  });

  test("a stale quote shows a dash", async function (assert) {
    const quotes = liveQuotes();
    quotes.bitcoin.last_updated_at = nowSeconds() - 16 * 60;
    this.fetchStub.callsFake(() => jsonResponse(quotes));

    await render(<template><CryptoTickers /></template>);
    await flush();

    const prices = [...document.querySelectorAll(".crypto-tickers__price")];
    assert.strictEqual(prices[1].textContent.trim(), "—");
  });

  test("hides the card when the first request fails", async function (assert) {
    this.fetchStub.callsFake(() =>
      Promise.resolve(new Response("", { status: 429 }))
    );

    await render(<template><CryptoTickers /></template>);
    await flush();

    assert.dom(".crypto-tickers.--hidden").exists();
    assert.dom(".crypto-tickers__row").doesNotExist();
  });

  test("a later failure keeps the last prices", async function (assert) {
    this.fetchStub.onFirstCall().callsFake(() => jsonResponse(liveQuotes()));
    this.fetchStub.onSecondCall().rejects(new Error("network"));

    await render(<template><CryptoTickers /></template>);
    await flush();

    const start = Date.now();
    sinon.stub(Date, "now").returns(start + 6 * MINUTE);
    document.dispatchEvent(new Event("visibilitychange"));
    await flush();

    assert.strictEqual(this.fetchStub.callCount, 2);
    assert.dom(".crypto-tickers__row").exists({ count: 3 });
    assert.dom(".crypto-tickers__price").hasText("0.3258");
  });

  test("returning under five minutes does not request again", async function (assert) {
    this.fetchStub.callsFake(() => jsonResponse(liveQuotes()));

    await render(<template><CryptoTickers /></template>);
    await flush();

    document.dispatchEvent(new Event("visibilitychange"));
    await flush();

    assert.strictEqual(this.fetchStub.callCount, 1);
  });
});
