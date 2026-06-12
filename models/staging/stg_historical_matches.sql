select
    date as match_date,
    trim(home_team) as home_team,
    trim(away_team) as away_team,
    home_score,
    away_score,
    tournament
from {{ source('gcp_raw_source', 'historical_matches_clean') }}