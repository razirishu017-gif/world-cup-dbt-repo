select
    team as team_name,
    continent,
    fifa_rank_pre_tournament,
    world_cup_titles_before
from {{ source('gcp_raw_source', 'teams_2026') }}