select
    -- Assuming your streaming function outputs these columns; adjust if names differ
    id as match_id,
    home_team,
    away_team,
    home_odds,
    away_odds,
    draw_odds,
    extracted_at
from {{ source('gcp_raw_source', 'live_odds_flat') }}