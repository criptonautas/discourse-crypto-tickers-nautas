# Crypto Tickers

[ENGLISH](README.md) | **ESPAÑOL**

Mantenido por Criptonautas. Sin afiliación ni respaldo de Discourse (Civilized Discourse Construction Kit, Inc.).

Componente de tema de Discourse que muestra precios cripto actuales en USD desde CoinGecko, para la barra lateral derecha. Informa precios y nada más: sin porcentajes y sin verde ni rojo.

```
◐ BTC           78,605.00   ↗
◐ ETH            2,306.85   ↗
◐ XMR              601.62   ↘
◐ PAXG           3,913.85   ↗
◐ XNO              0.3258   ↗

     actualizado hace 3 min
        USD · CoinGecko
```

## Funciones

- **Precios en USD**, con dos decimales desde $1 y cuatro por debajo de $1.
- **Una línea con la dirección en 24 horas**, hacia arriba o hacia abajo, en el color del texto. El porcentaje nunca se muestra.
- **Una línea «actualizado hace X min»**, tomada de las marcas de tiempo de CoinGecko.
- **Un enlace a CoinGecko** en el crédito, que abre en otra pestaña con `rel="noopener noreferrer"`, así no se envía el referrer.
- **Título, monedas y orden definidos en los ajustes del tema**, sin tocar código.
- **Actualización cada 5 minutos** mientras la pestaña está visible. Al volver a una lista de temas se reutilizan los últimos precios, sin llamar de nuevo a CoinGecko.
- **Sin backend y sin clave de API.**

## Requisitos

| Necesario | Para qué |
|---|---|
| [Right Sidebar Blocks](https://github.com/discourse/discourse-right-sidebar-blocks) | Coloca la tarjeta en la barra lateral |
| [discourse-phosphor-duotone-icons](https://github.com/somos-criptonautas/discourse-phosphor-duotone-icons) | Aporta los iconos por defecto; este componente incluye `ph-dt-ingot` para PAXG |

## Instalación

1. Instalá los dos componentes requeridos.
2. Subí este componente en **Admin > Personalizar > Temas** y adjuntá los tres a tu tema activo.
3. Agregá esta fila al ajuste `blocks` de Right Sidebar Blocks:

   ```json
   { "name": "crypto-tickers" }
   ```

La barra lateral se ve solo en las listas de temas de escritorio, nunca en las páginas de un tema ni en teléfonos.

## Ajustes

`title` define el título de la tarjeta. Vacío usa el valor por defecto, «Precios» ("Prices" en inglés).

`tickers` define las monedas y su orden. Usá mover arriba y mover abajo en el editor para reordenarlas.

| Propiedad | Requerida | Ejemplo | Significado |
|---|---|---|---|
| `coingecko_id` | sí | `monero` | Última parte de la URL de la moneda en CoinGecko, como en `coingecko.com/en/coins/monero` |
| `ticker` | sí | `XMR` | Etiqueta que se ve en la fila |
| `icon` | no | `ph-dt-xmr` | Nombre del icono; vacío deja el espacio en blanco |

## Cuando algo falla

| Caso | Resultado |
|---|---|
| El primer pedido todavía carga | Una fila por moneda con rayas |
| Falla el primer pedido | La tarjeta se oculta |
| Falla un pedido posterior, incluido un límite de uso | Se mantienen los últimos precios; la línea de actualización sigue contando |
| Un precio tiene más de 15 minutos | Esa fila muestra una raya |
| Un `coingecko_id` incorrecto | Esa fila muestra una raya |

## Privacidad y límites

El navegador de cada visitante llama directamente a CoinGecko, así que CoinGecko ve su dirección IP.

La API sin clave de CoinGecko limita los pedidos por dirección IP y no publica una cifra, así que quienes comparten una IP pueden ver precios más viejos o rayas. Leé los términos de la API de CoinGecko antes de usar esto en tu sitio. La tarjeta siempre le da crédito a CoinGecko.

## Archivos

| Ruta | Función |
|---|---|
| `about.json` | Metadatos del componente |
| `settings.yml` | El ajuste `tickers` y sus valores por defecto |
| `javascripts/discourse/components/crypto-tickers.gjs` | Pedidos, actualización y renderizado |
| `javascripts/discourse/lib/quotes.js` | Formato de precios, dirección y la regla de 15 minutos |
| `common/common.scss` | Estilos de la tarjeta |
| `assets/icons-sprite.svg` | El icono `ph-dt-ingot` |
| `locales/en.yml`, `locales/es.yml` | Textos y descripciones de ajustes |
| `test/` | Pruebas QUnit unitarias y de integración |
| `.github/workflows/discourse-theme.yml` | Lint y pruebas en CI |

## Desarrollo

```bash
pnpm install
pnpm lint
```

CI corre lint y QUnit en los pull requests y en cada push a `main`.

## Licencia

MIT. Ver [LICENSE](LICENSE).

Texto de este README bajo [CC BY-NC-SA 4.0](CC-BY-NC-SA-4.0.txt).
