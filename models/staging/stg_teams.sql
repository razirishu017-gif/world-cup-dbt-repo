select
    team_id,
    team_name,
    group_assignment
from {{ source('gcp_raw_source', 'teams_2026') }}