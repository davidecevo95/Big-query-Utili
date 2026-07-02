SELECT
    device.category AS device_category,
    traffic_source.source AS traffic_source,
    geo.country AS country,
    COUNT(DISTINCT user_pseudo_id) AS distinct_users,
    COUNT(DISTINCT CONCAT(user_pseudo_id, event_timestamp)) AS distinct_sessions
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` AS t
WHERE
    _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
GROUP BY
    device_category,
    traffic_source,
    country
ORDER BY
    distinct_users DESC
LIMIT 100
-- Questa query analizza i dati di eventi e-commerce da un dataset pubblico GA4 per il mese di novembre 2020.
-- Restituisce le prime 100 combinazioni di categoria dispositivo, sorgente di traffico e paese, ordinate per il numero di utenti distinti.
-- Per ogni combinazione, mostra il conteggio degli utenti distinti e delle sessioni distinte.
-- Calcoli principali:
-- - `COUNT(DISTINCT user_pseudo_id)`: Conta il numero di utenti unici.
-- - `COUNT(DISTINCT CONCAT(user_pseudo_id, event_timestamp))`: Conta il numero di sessioni uniche, identificando una sessione come la combinazione di un ID utente e un timestamp di evento.