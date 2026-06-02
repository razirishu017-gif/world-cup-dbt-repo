select
    match_id,
    sport_key,
    commence_time,
    home_team,
    away_team,
    bookmaker_name,
    market_type,
    team_name as odds_target_team,
    decimal_odds,
    odds_last_update
from {{ source('gcp_raw_source', 'live_odds_flat') }}