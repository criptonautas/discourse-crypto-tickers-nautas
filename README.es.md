# Crypto Tickers

[ENGLISH](README.md) | **ESPAÑOL**

Mantenido por Criptonautas. Sin afiliación ni respaldo de Discourse (Civilized Discourse Construction Kit, Inc.).

Precios cripto actuales en USD desde CoinGecko, para la barra lateral derecha. Cada fila muestra el precio y una línea con su dirección en 24 horas. Los precios se actualizan cada 5 minutos mientras la pestaña está visible.

## Instalación

Instalá [Right Sidebar Blocks](https://github.com/discourse/discourse-right-sidebar-blocks) y [discourse-phosphor-duotone-icons](https://github.com/somos-criptonautas/discourse-phosphor-duotone-icons). Subí este componente, adjuntalo a tu tema y agregá esta fila al ajuste `blocks` de Right Sidebar Blocks:

    { "name": "crypto-tickers" }

La barra lateral se ve solo en las listas de temas de escritorio.

## Ajustes

`tickers` define las monedas y su orden. `coingecko_id` es la última parte de la URL de la moneda en CoinGecko. Un ID incorrecto muestra una raya en esa fila.

## Privacidad

El navegador de cada visitante llama directamente a CoinGecko, así que CoinGecko ve su dirección IP.

## Licencia

MIT. Ver [LICENSE](LICENSE).

Texto de este README bajo [CC BY-NC-SA 4.0](CC-BY-NC-SA-4.0.txt).
