{% macro assign_alert_color(magnitude) %}
    case
        when {{ magnitude }} <= 4.0 then 'green'
        when {{ magnitude }} > 4.0 and {{ magnitude }} <= 6.0 then 'yellow'
        else 'red'
    end
{% endmacro %}
