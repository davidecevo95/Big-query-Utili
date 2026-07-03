WITH UserDailyMetrics AS (
  SELECT
    user_id,
    DATE(event_timestamp) AS event_date,
    COUNT(DISTINCT event_type) AS distinct_event_count,
    SUM(duration_ms) AS total_duration_ms
  FROM
    `your_gcp_project.your_bq_dataset.activity_logs`
  WHERE
    event_timestamp BETWEEN '2023-01-01' AND '2023-01-31'
  GROUP BY
    user_id, event_date
),
AggregatedUserMetrics AS (
  SELECT
    udm.user_id,
    u.region,
    AVG(udm.total_duration_ms) AS avg_daily_duration_ms,
    SUM(udm.distinct_event_count) AS total_distinct_events_month,
    COUNT(DISTINCT udm.event_date) AS active_days
  FROM
    UserDailyMetrics AS udm
  JOIN
    `your_gcp_project.your_bq_dataset.users` AS u
  ON
    udm.user_id = u.user_id
  WHERE
    u.region = 'Europe'
  GROUP BY
    udm.user_id, u.region
)
SELECT
  user_id,
  region,
  avg_daily_duration_ms,
  total_distinct_events_month,
  active_days,
  RANK() OVER (PARTITION BY region ORDER BY avg_daily_duration_ms DESC) AS rank_by_avg_duration
FROM
  AggregatedUserMetrics
ORDER BY
  region, rank_by_avg_duration
LIMIT 100
;
-- Cosa fa la query: Questa query analizza i log di attività degli utenti per un periodo specifico, aggrega le metriche giornaliere per utente e poi le combina con le informazioni sugli utenti per filtrare per regione. Infine, calcola metriche aggregate mensili e classifica gli utenti all'interno di ciascuna regione.
-- Che risultato restituisce: Restituisce una lista (fino a 100 righe) di utenti, mostrando per ciascuno: ID utente, regione, durata media giornaliera delle attività, numero totale di eventi distinti nel mese, numero di giorni attivi e il loro ranking basato sulla durata media giornaliera all'interno della propria regione.
-- Che calcoli principali effettua: La query calcola il conteggio di eventi distinti e la somma della durata delle attività per utente per ogni giorno; la media della durata giornaliera, la somma degli eventi distinti e il conteggio dei giorni attivi per utente per il mese; e la funzione finestra RANK() per classificare gli utenti per durata media giornaliera all'interno della loro regione.