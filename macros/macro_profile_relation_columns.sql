{% macro profile_relation_columns(relation) %}
    select 
        'table' as type,
        '{{ relation.identifier }}' as name,
        '' as data_type,
        0 as ordinal,
        count(*) as distincts,
        null as non_nulls,
        null as nulls,
        null::varchar as min_value,
        null::varchar as max_value
    from {{ relation }}
    union all
    {% set cols = adapter.get_columns_in_relation(relation) %}
    {% for col in cols %}
        select
            'column' as type,
            '{{ col.name | lower }}' as name,
            '{{ col.data_type }}' as data_type,
            {{ loop.index }} as ordinal,
            count(distinct {{ col.name }}) as distincts,
            count({{ col.name }}) as non_nulls,
            sum(case when {{ col.name }} is null then 1 else 0 end) as nulls,
            min({{ col.name }})::varchar as min_value,
            max({{ col.name }})::varchar as max_value
        from {{ relation }}
        {% if not loop.last %}
        union all
        {% endif %}
    {% endfor %}
    order by 4
{% endmacro %}
