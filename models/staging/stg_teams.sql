select
    team as team_name,
    continent,
    fifa_rank_pre_tournament,
    world_cup_titles_before,
    squad_total_market_value_eur as team_market_value
from {{ source('gcp_raw_source', 'teams_2026') }}