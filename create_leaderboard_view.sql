CREATE VIEW leaderboard
AS
WITH unioned AS (
SELECT 
    p.player_name as player_name,
    SUM(og.player_one_score) AS points_for,
    SUM(og.player_two_score) AS points_against,
CASE
    WHEN og.player_one_score > og.player_two_score
    THEN 1
    ELSE 0
END win,
CASE
    WHEN og.player_one_score < og.player_two_score
    THEN 1
    ELSE 0
END loss
FROM player p
JOIN office_game og ON p.id = og.player_one_id
GROUP BY p.player_name, og.player_one_score, og.player_two_score
UNION ALL
SELECT 
    p.player_name as player_name,
    SUM(og.player_two_score) AS points_for,
    SUM(og.player_one_score) AS points_against,
CASE
    WHEN og.player_one_score < og.player_two_score
    THEN 1
    ELSE 0
END win,
CASE
    WHEN og.player_one_score > og.player_two_score
    THEN 1
    ELSE 0
END loss
FROM player p
JOIN office_game og ON p.id = og.player_two_id
GROUP BY p.player_name, og.player_one_score, og.player_two_score
)
SELECT 
    player_name,
    SUM(win) + SUM(loss) as games_played,
    SUM(points_for) as points_for,
    SUM(points_against) as points_against,
    SUM(win) as wins,
    SUM(loss) as losses,
    SUM(win) * 100 / (SUM(win) + SUM(loss)) as win_percentage
FROM unioned
GROUP BY player_name
ORDER BY wins DESC, win_percentage DESC;