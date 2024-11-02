In Snowflake, the CHANGE_TRACKING table property controls whether a table supports change data capture (CDC) through standard streams. Executing the statement:
    ALTER TABLE table_name SET CHANGE_TRACKING = TRUE;


Key Differences Between CHANGE_TRACKING = TRUE and FALSE
Ability to Create Standard Streams:

CHANGE_TRACKING = TRUE: Allows you to create standard streams on the table, which track all DML changes—inserts, updates, and deletes.
CHANGE_TRACKING = FALSE (Default): You cannot create standard streams. Only append-only streams are available, which track inserted rows but not updates or deletes.
Change Data Capture (CDC):

With Change Tracking Enabled: Supports full CDC capabilities. You can capture and process all types of data changes, making it suitable for applications that need to maintain synchronized copies of data or process incremental changes.
Without Change Tracking: Limited to insert-only tracking. You won't capture updates or deletes, which might not suffice for scenarios requiring complete change awareness.
Stream Behavior:

Standard Streams: Provide access to the delta of changes (inserts, updates, deletes) since the last time the stream was consumed. This is possible only when CHANGE_TRACKING is enabled.
Append-Only Streams: Only capture newly inserted rows. Updates and deletes are not tracked, regardless of the CHANGE_TRACKING setting.
Use Cases:

When to Enable Change Tracking:
Your table undergoes updates and deletes in addition to inserts.
You need to perform incremental data processing that considers all types of DML changes.
Implementing complex CDC workflows that require awareness of all data modifications.
When Change Tracking Is Not Necessary:
Your table is append-only, meaning it only ever receives inserts.
You only need to process newly inserted data and can ignore updates and deletes.
You want to minimize storage overhead associated with tracking changes.
How Change Tracking Affects Streams and CDC
Enabling Change Tracking (TRUE):

Streams: Can create both standard and append-only streams.
CDC Capability: Full CDC is possible, capturing inserts, updates, and deletes.
Metadata Columns: Streams will include metadata columns like METADATA$ACTION, METADATA$ISUPDATE, etc., which provide information about the type of DML operation.
Usage: Ideal for tables where data can change in any form and you need to keep downstream systems in sync.
Without Change Tracking (FALSE):

Streams: Limited to append-only streams.
CDC Capability: Only new inserts are tracked; updates and deletes are ignored.
Metadata Columns: Fewer metadata columns are available, as updates and deletes are not tracked.
Usage: Suitable for log tables, audit trails, or any scenario where data is only added and never modified or removed.
Example Scenario
Suppose you have a table that records customer transactions:

sql
Copy code
CREATE OR REPLACE TABLE customer_transactions (
    transaction_id INT,
    customer_id INT,
    amount NUMBER,
    status STRING
);
If you set CHANGE_TRACKING = TRUE:

sql
Copy code
ALTER TABLE customer_transactions SET CHANGE_TRACKING = TRUE;
Use Case: You can create a standard stream to track all changes, including when transactions are updated (e.g., status changes) or deleted.
Benefit: Allows you to implement a CDC pipeline that keeps an analytics database or a downstream system in sync with the source table.
If you do not set CHANGE_TRACKING or set it to FALSE:

sql
Copy code
ALTER TABLE customer_transactions SET CHANGE_TRACKING = FALSE;
Use Case: You can only create an append-only stream, which will capture new transactions but not any updates to existing transactions or deletions.
Limitation: Updates to transaction statuses or deleted transactions will not be tracked, potentially leading to inconsistencies in downstream systems relying on this data.
Considerations When Enabling Change Tracking
Storage Impact: Enabling change tracking may increase storage usage because Snowflake needs to maintain additional metadata about data changes.
Performance: There might be a slight impact on DML performance due to the overhead of tracking changes.
Data Retention: Streams rely on Snowflake's time travel feature. Ensure that your data retention period is sufficient for your change tracking needs.
Steps to Enable Change Tracking and Use Streams
Enable Change Tracking on the Table:

sql
Copy code
ALTER TABLE table_name SET CHANGE_TRACKING = TRUE;
Create a Standard Stream on the Table:

sql
Copy code
CREATE OR REPLACE STREAM table_stream ON TABLE table_name;
Use the Stream in Data Processing:

Query the Stream to retrieve changes:

sql
Copy code
SELECT
    METADATA$ACTION,
    METADATA$ISUPDATE,
    table_name.*
FROM
    table_stream;
Implement CDC Logic using MERGE statements to apply changes to a target table.

Consume the Stream Regularly:

Set up Tasks to automate the consumption and processing of the stream data.
Example of Using a Standard Stream with Change Tracking
sql
Copy code
-- Enable change tracking
ALTER TABLE orders SET CHANGE_TRACKING = TRUE;

-- Create a standard stream
CREATE OR REPLACE STREAM orders_stream ON TABLE orders;

-- Merge changes into a target table
MERGE INTO orders_target AS t
USING orders_stream AS s
ON t.order_id = s.order_id
WHEN MATCHED AND s.METADATA$ACTION = 'DELETE' THEN
    DELETE
WHEN MATCHED THEN
    UPDATE SET
        t.customer_id = s.customer_id,
        t.amount = s.amount,
        t.status = s.status
WHEN NOT MATCHED THEN
    INSERT (order_id, customer_id, amount, status)
    VALUES (s.order_id, s.customer_id, s.amount, s.status);
Summary
CHANGE_TRACKING = TRUE:

Enables full change data capture through standard streams.
Tracks inserts, updates, and deletes.
Suitable for tables where data modifications need to be fully tracked and processed.
CHANGE_TRACKING = FALSE:

Limits you to append-only streams.
Only tracks inserts.
Appropriate for tables that only receive new data and do not undergo updates or deletes.
Choosing whether to enable change tracking depends on your specific data processing needs. If you require comprehensive tracking of all data changes for synchronization, auditing, or incremental processing, enabling change tracking is essential. If your use case involves only new data additions and you can ignore updates and deletions, you may opt to leave change tracking disabled to save on storage and potentially improve performance.


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
