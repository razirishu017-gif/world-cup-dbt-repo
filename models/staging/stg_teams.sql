select
    trim(
        case 
            when team = 'Bosnia and Herzegovina' then 'Bosnia & Herzegovina'
            when team = 'United States' then 'USA'
            when team = 'Korea Republic' then 'South Korea'
            when team = 'Congo DR' then 'DR Congo'
            when team = 'Democratic Republic of the Congo' then 'DR Congo'
            when team = 'IR Iran' then 'Iran'
            else team 
        end
    ) as team_name,
    continent,
    fifa_rank_pre_tournament,
    world_cup_titles_before,
    squad_total_market_value_eur as team_market_value
from {{ source('gcp_raw_source', 'teams_2026') }}