with live_odds as (
    select * from {{ ref('stg_live_odds') }}
),

historical_summary as (
    select
        home_team as team_name,
        count(*) as total_matches,
        count(case when home_score > away_score then 1 end) as total_wins
    from {{ ref('stg_historical_matches') }}
    group by home_team
),

teams as (
    select * from {{ ref('stg_teams') }}
)

select
    lo.match_id,
    lo.home_team,
    lo.away_team,
    lo.home_odds,
    lo.away_odds,
    lo.draw_odds,
    -- Pulling in historical context for the home team
    coalesce(h.total_matches, 0) as historical_home_matches,
    coalesce(h.total_wins, 0) as historical_home_wins,
    round(
        case 
            when coalesce(h.total_matches, 0) > 0 then (h.total_wins / h.total_matches) * 100
            else 0 
        end, 2
    ) as home_historical_win_percentage,
    lo.extracted_at as live_updated_at
from live_odds lo
left join historical_summary h 
    on lo.home_team = h.team_name