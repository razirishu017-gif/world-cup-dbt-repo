select
    date as match_date,
    home_team,
    away_team,
    home_score,
    away_score,
    tournament
from {{ source('gcp_raw_source', 'historical_matches_clean') }}