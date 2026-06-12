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
    lo.commence_time,  
    lo.home_team,
    lo.away_team,
    lo.bookmaker_name,
    lo.odds_target_team,
    lo.decimal_odds,
    
    coalesce(h.total_matches, 0) as historical_home_matches,
    coalesce(h.total_wins, 0) as historical_home_wins,
    round(
        case 
            when coalesce(h.total_matches, 0) > 0 then (h.total_wins / h.total_matches) * 100
            else 0 
        end, 2
    ) as home_historical_win_percentage,
    
    -- The new financial columns mapping from our double join
    t_home.team_market_value as home_team_market_value,
    t_away.team_market_value as away_team_market_value,
    
    lo.odds_last_update as live_updated_at

from live_odds lo
left join historical_summary h 
    on lo.home_team = h.team_name
left join teams t_home 
    on lo.home_team = t_home.team_name
left join teams t_away 
    on lo.away_team = t_away.team_name