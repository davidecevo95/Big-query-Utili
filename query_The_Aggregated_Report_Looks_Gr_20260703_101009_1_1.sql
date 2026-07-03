SELECT
DISTINCT t2.repo_name AS repo_name,
t2.actor.login AS actor,
COUNT(t1.type) OVER (PARTITION BY t2.repo_name) AS num_events_repo
FROM
bigquery-public-data.github_repos.commits AS t1
INNER JOIN
bigquery-public-data.github_repos.contents AS t2
ON t1.repo_name = t2.repo_name
WHERE
t1.repo_name IN (
SELECT repo_name
FROM bigquery-public-data.github_repos.commits
GROUP BY repo_name
ORDER BY COUNT(type) DESC
LIMIT 5
)
AND t2.actor.login IN (
SELECT actor.login
FROM bigquery-public-data.github_repos.commits
GROUP BY actor.login
ORDER BY COUNT(type) DESC
LIMIT 5
)
ORDER BY num_events_repo DESC, repo_name ASC, actor ASC
LIMIT 10
-- Questa query seleziona coppie distinte di nome repository e attore.
-- Filtra per i 5 repository e i 5 attori più attivi (basato sul numero di eventi).
-- Restituisce le prime 10 di queste combinazioni, ordinandole per numero totale di eventi del repository.
-- I calcoli principali includono:
-- - Identificazione dei 5 repository più attivi e dei 5 attori più attivi tramite sottoquery con COUNT e LIMIT.
-- - Calcolo del numero totale di eventi per ciascun repository utilizzando una funzione di finestra (COUNT(t1.type) OVER (PARTITION BY t2.repo_name)).