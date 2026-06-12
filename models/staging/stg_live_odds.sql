select
    match_id,
    sport_key,
    commence_time,
    trim(home_team) as home_team,
    trim(away_team) as away_team,
    bookmaker_name,
    market_type,
    trim(team_name) as odds_target_team,
    decimal_odds,
    odds_last_update
from {{ source('gcp_raw_source', 'live_odds_flat') }}