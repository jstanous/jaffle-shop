{% docs source__SOURCE_NAME %}
Brief description of the source system or dataset.  
{% enddocs %}

{% docs table__TABLE_NAME %}
Brief description of the table.  

** Source: ** <schema.table>  
** Grain: ** One record per <entity>.  
{% enddocs %}

{% docs model__MODEL_NAME %}  
Staging model for Stripe Payments for Jaffle Shop orders.  

** Source: ** <table.column>  
** Grain: ** One record per <entity>.  OR
 - One record <entity>.  
 - <additional notes>.  
{% enddocs %}  

{% docs column__COLUMN_NAME %}
Brief description of the column.  

** Business Name: ** <column_name>  
** Source: ** <table.column>  
** Role: ** <Primary Key/Foreign Key> OR
 - <Primary Key>
 - <Foreign Key>

** Use case: ** <<Purpose of column (e.g Indicate if customer is new or returning)>>

** Values: **  
 - value1 — description  
 - value2 — description  

** Logic: ** <transformation or macro if applicable>  
{% enddocs %}

