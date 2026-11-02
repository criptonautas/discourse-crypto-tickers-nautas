const STALE_MS = 15 * 60 * 1000;

function formatPrice(price) {
  const digits = price >= 1 ? 2 : 4;

  return price.toLocaleString("en-US", {
    minimumFractionDigits: digits,
    maximumFractionDigits: digits,
  });
}

function toDirection(change) {
  if (change > 0) {
    return "up";
  }

  return change < 0 ? "down" : null;
}

function isFresh(quote, now) {
  return (
    typeof quote?.usd === "number" &&
    now - quote.last_updated_at * 1000 <= STALE_MS
  );
}

export function toRow(ticker, quote, now) {
  const fresh = isFresh(quote, now);

  return {
    ticker: ticker.ticker,
    icon: ticker.icon,
    price: fresh ? formatPrice(quote.usd) : null,
    direction: fresh ? toDirection(quote.usd_24h_change) : null,
  };
}

export function newestUpdate(quotes) {
  const times = Object.values(quotes || {})
    .map((q) => q.last_updated_at)
    .filter(Boolean);

  return times.length ? Math.max(...times) * 1000 : null;
}
