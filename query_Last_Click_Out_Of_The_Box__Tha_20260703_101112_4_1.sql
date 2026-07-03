SELECT
  PARSE_DATE('%Y%m%d', _PARTITIONTIME) AS data,
  SUM(CASE WHEN event_name = 'session_start' THEN 1 ELSE 0 END) AS sessioni,
  SUM(CASE WHEN event_name = 'first_open' THEN 1 ELSE 0 END) AS installazioni,
  SUM(CASE WHEN event_name = 'user_engagement' THEN 1 ELSE 0 END) AS user_engagement,
  SUM(CASE WHEN event_name = 'scroll' THEN 1 ELSE 0 END) AS scroll,
  SUM(CASE WHEN event_name = 'page_view' THEN 1 ELSE 0 END) AS page_view,
  SUM(CASE WHEN event_name = 'screen_view' THEN 1 ELSE 0 END) AS screen_view,
  SUM(CASE WHEN event_name = 'view_item' THEN 1 ELSE 0 END) AS view_item,
  SUM(CASE WHEN event_name = 'add_to_cart' THEN 1 ELSE 0 END) AS add_to_cart,
  SUM(CASE WHEN event_name = 'begin_checkout' THEN 1 ELSE 0 END) AS begin_checkout,
  SUM(CASE WHEN event_name = 'purchase' THEN 1 ELSE 0 END) AS acquisti,
  SUM(CASE WHEN event_name = 'refund' THEN 1 ELSE 0 END) AS rimborsi
FROM
  `your-project-id.analytics_22222222.events_*`
WHERE
  _TABLE_SUFFIX BETWEEN '20231201' AND '20231231'
GROUP BY
  data
ORDER BY
  data ASC
-- La query aggrega e conta diversi tipi di eventi per ogni giorno in un intervallo specifico.
-- Restituisce una tabella con la data e il numero totale di sessioni, installazioni, user engagement e vari eventi e-commerce per ogni giorno.
-- I calcoli principali includono: estrazione della data dalla partizione, conteggio condizionale degli eventi tramite SUM(CASE WHEN ...), e raggruppamento per data per ottenere i totali giornalieri.