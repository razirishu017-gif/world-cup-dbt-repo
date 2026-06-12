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
    
    -- Our Model's True Probability
    round(
        case 
            when coalesce(h.total_matches, 0) > 0 then (h.total_wins * 100.0 / h.total_matches)
            else 0 
        end, 2
    ) as home_historical_win_percentage,

    -- The Bookmaker's Implied Probability
    round((1.0 / nullif(lo.decimal_odds, 0)) * 100, 2) as bookmaker_implied_probability,

    -- THE ALGORITHM: Value Bet Flag (Is our probability higher than the bookmaker's?)
    case 
        when round(case when coalesce(h.total_matches, 0) > 0 then (h.total_wins * 100.0 / h.total_matches) else 0 end, 2) > round((1.0 / nullif(lo.decimal_odds, 0)) * 100, 2) 
        then TRUE 
        else FALSE 
    end as value_bet_flag,
    
    -- Market Value Imputation for Unranked Teams
    coalesce(t_home.team_market_value, 
        case 
            when lo.home_team = 'Uzbekistan' then 30000000
            when lo.home_team = 'Cape Verde' then 24000000
            when lo.home_team = 'Haiti' then 15000000
            when lo.home_team = 'Curaçao' then 12000000
            else 10000000 
        end
    ) as home_team_market_value,

    coalesce(t_away.team_market_value, 
        case 
            when lo.away_team = 'Uzbekistan' then 30000000
            when lo.away_team = 'Cape Verde' then 24000000
            when lo.away_team = 'Haiti' then 15000000
            when lo.away_team = 'Curaçao' then 12000000
            else 10000000 
        end
    ) as away_team_market_value,
    
    lo.odds_last_update as live_updated_at

from live_odds lo
left join historical_summary h 
    on lo.home_team = h.team_name
left join teams t_home 
    on lo.home_team = t_home.team_name
left join teams t_away 
    on lo.away_team = t_away.team_name