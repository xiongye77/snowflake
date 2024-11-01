use the MERGE statement in combination with a stream to perform incremental changes (upserts) to a target table based on changes in a source table. 
A stream in Snowflake tracks changes (inserts, updates, and deletes) made to a table, allowing you to apply these changes to another table in a controlled way.

CREATE OR REPLACE TABLE source_table (
    id INT,
    name STRING,
    value NUMBER
);



CREATE OR REPLACE TABLE target_table (
    id INT,
    name STRING,
    value NUMBER
);


CREATE OR REPLACE STREAM source_stream ON TABLE source_table;




CREATE OR REPLACE TASK merge_task
  WAREHOUSE = my_warehouse
  SCHEDULE = '5 MINUTE'  -- Schedule as per your requirement
AS
MERGE INTO target_table AS t
USING source_stream AS s
ON t.id = s.id
WHEN MATCHED AND s.METADATA$ACTION = 'UPDATE' THEN 
    UPDATE SET 
        t.name = s.name,
        t.value = s.value
WHEN MATCHED AND s.METADATA$ACTION = 'DELETE' THEN 
    DELETE
WHEN NOT MATCHED AND s.METADATA$ACTION = 'INSERT' THEN 
    INSERT (id, name, value) 
    VALUES (s.id, s.name, s.value);
