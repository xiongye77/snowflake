# snowflake

Query history on specific table 
SELECT 
    query_id,
    user_name,
    database_name,
    schema_name,
    query_text,
    start_time,
    end_time
FROM 
    SNOWFLAKE.ACCOUNT_USAGE.QUERY_HISTORY
WHERE 
    query_text ILIKE '%digital_market_sandbox.application.sfmc_bc_organisation%'
    AND start_time > DATEADD(DAY, -30, CURRENT_TIMESTAMP) -- Last 30 days
ORDER BY 
    start_time DESC;


<img width="1466" alt="image" src="https://github.com/user-attachments/assets/17c582b3-79d3-430a-8ad6-d261bfdf20ea">


SELECT
    ah.QUERY_ID,
    ah.query_start_time,
    ah.USER_NAME,
    base_object.value:"objectName"::string AS OBJECT_NAME
FROM
    SNOWFLAKE.ACCOUNT_USAGE.ACCESS_HISTORY ah,
    LATERAL FLATTEN(input => ah.BASE_OBJECTS_ACCESSED) base_object
WHERE
   query_start_time > DATEADD(DAY, -1, CURRENT_TIMESTAMP)  and 
    base_object.value is not null  and ah.user_name ='YE.XIONG@XERO.COM' and object_name like 'DIGITAL_MARKET_SANDBOX.APPLICATION.INTERCOM_ORG' order by query_start_time desc

    
<img width="1635" alt="image" src="https://github.com/user-attachments/assets/05e8a073-8c0a-4c94-9a09-f5d70616ede7">

<img width="1133" alt="image" src="https://github.com/user-attachments/assets/7f50e754-77fe-42b6-9c91-1699aa5fb693">
<img width="1119" alt="image" src="https://github.com/user-attachments/assets/66be9eab-6ab7-496c-9752-4587ccf11948">
<img width="1072" alt="image" src="https://github.com/user-attachments/assets/0794c100-2102-48ba-a70d-1cadc81baf00">
<img width="1104" alt="image" src="https://github.com/user-attachments/assets/75b5c3de-deb4-46a1-97b2-062f62eac184">

<img width="1044" alt="image" src="https://github.com/user-attachments/assets/360f099c-9f39-46be-a8ef-0814180cc487">
<img width="988" alt="image" src="https://github.com/user-attachments/assets/404bb90e-6fe1-4198-881c-822e4c5e5d60">


<img width="624" alt="image" src="https://github.com/user-attachments/assets/dea8d670-2820-4892-8fcb-426ab8003231">
<img width="703" alt="image" src="https://github.com/user-attachments/assets/349d2922-c9a9-40f7-adee-eb2fb67ca770">

<img width="767" alt="image" src="https://github.com/user-attachments/assets/0d0c90ad-a214-4a47-b84f-0e99130e6027">

Version 2.0.0 (or later) of the Kafka connector is required for use with Snowpipe Streaming. The Kafka connector with Snowpipe Streaming includes the Snowflake Ingest SDK and supports streaming rows from Apache Kafka topics directly into target tables.

<img width="831" alt="image" src="https://github.com/user-attachments/assets/efa8c0cc-41b9-4c85-8e4f-b99c49a66613">

<img width="1077" alt="image" src="https://github.com/user-attachments/assets/6fb933bd-0e96-48dc-ae3e-25151456dec8">


<img width="779" alt="image" src="https://github.com/user-attachments/assets/64539d72-09d6-429b-b1b9-cf899e76fd0b">

<img width="1400" alt="image" src="https://github.com/user-attachments/assets/20ce17d0-2767-4f8a-8592-04e7b13dba69">



# OAUTH2 in Snowflake
<img width="564" alt="image" src="https://github.com/user-attachments/assets/2b3778b7-4b3e-487a-8c94-b5d9abf1ea19">
<img width="1268" alt="image" src="https://github.com/user-attachments/assets/eda35714-bb92-416d-bd37-88b73eb6a87b">
<img width="690" alt="image" src="https://github.com/user-attachments/assets/2678c4cf-cf8b-4029-9d69-1abe5e6df75d">

# Snowpipe streaming vs Snowpipe 
<img width="961" alt="image" src="https://github.com/user-attachments/assets/f5f233da-bab6-401c-8c6b-261426ab7e88">



# Storage monitoring 
![image](https://github.com/xiongye77/snowflake/assets/36766101/3d3ffafe-2862-4cc3-80bf-1690fa2c8e68)

show tables;

DESCRIBE TABLE KPI_MARKETING_SPEND_REPORT

SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'KPI_MARKETING_SPEND_REPORT'

<img width="1055" alt="image" src="https://github.com/user-attachments/assets/dbe3573a-878a-4cb9-ae19-80c09a912010">


# Data loading
![image](https://github.com/xiongye77/snowflake/assets/36766101/da1abf94-2477-4789-988c-11bd97083240)

# Understanding Stage 
![image](https://github.com/xiongye77/snowflake/assets/36766101/41154a9e-098c-45ba-8e75-46204f1294c3)
![image](https://github.com/xiongye77/snowflake/assets/36766101/c1fe17c7-b06d-48d3-beba-21eb0970a86e)
![image](https://github.com/xiongye77/snowflake/assets/36766101/a6494a06-9b2a-4920-a646-d12c752992a3)

# STAGE METADATA
![image](https://github.com/xiongye77/snowflake/assets/36766101/6b2deba3-5843-41fe-ac21-6e2c0020f8fe)

# STORAGE INTEGRATION
![image](https://github.com/xiongye77/snowflake/assets/36766101/a110b5f4-977f-4899-9a25-d6068ddaa946)


# What is Snowflake, and how does it differ from traditional data warehousing solutions
<img width="636" alt="image" src="https://github.com/user-attachments/assets/4331029d-cf40-49c0-942f-29979837a432">

# Snowflake's architecture and its key components
<img width="695" alt="image" src="https://github.com/user-attachments/assets/b9b27326-680e-494b-b5bb-4fb83486a510">

# How does Snowflake handle data partitioning and clustering
<img width="659" alt="image" src="https://github.com/user-attachments/assets/5d8a4bfe-9bf0-4b19-887e-cc14e1f86c17">

# What are Virtual Warehouses in Snowflake, and how do they affect performance and cost
<img width="780" alt="image" src="https://github.com/user-attachments/assets/f77c2d31-4ee1-48bb-aac0-d8f296134fb6">


# How do you load data into Snowflake, and what are some best practices
<img width="593" alt="image" src="https://github.com/user-attachments/assets/394029f4-c2ff-4e8d-9d4e-ebeddea84e1d">

# How does Snowflake ensure data security and compliance
<img width="567" alt="image" src="https://github.com/user-attachments/assets/4b3469e9-ca6b-4454-b6d9-7200d19c9b35">

# What is Time Travel in Snowflake, and how can it be used
<img width="647" alt="image" src="https://github.com/user-attachments/assets/6d3aa1db-a121-44d7-92d6-4a2dc8f8f4f2">

# How does Snowflake handle semi-structured data, and what data types are used?
<img width="633" alt="image" src="https://github.com/user-attachments/assets/bfcac9b5-ca34-451a-8b2f-16df5f3c8397">


# Column level security protect PII data 
<img width="1239" alt="image" src="https://github.com/user-attachments/assets/e0ccdc05-db96-4901-a840-06dafbb67a73">


# Data Model 

<img width="1406" alt="image" src="https://github.com/user-attachments/assets/246bf5b9-7514-4c42-8d87-dbfd0a779985">
<img width="1441" alt="image" src="https://github.com/user-attachments/assets/bf329955-e30d-40b6-aafa-fd0f16321fee">


# Schema on Read and Schema on Write
<img width="1421" alt="image" src="https://github.com/user-attachments/assets/aaff4c7a-5770-45b4-b098-4ffa359d8b14">
<img width="1197" alt="image" src="https://github.com/user-attachments/assets/45dd0934-e411-4bec-a3b3-38129bdfe925">





<img width="1410" alt="image" src="https://github.com/user-attachments/assets/41944c04-ed62-4f05-8b7a-6fb6bba3620b">

<img width="1395" alt="image" src="https://github.com/user-attachments/assets/cc0a1abe-9da4-4dd7-8f41-f6b512955966">

<img width="1246" alt="image" src="https://github.com/user-attachments/assets/77e705b9-e479-44d9-a6fd-2336ba363b3f">

<img width="1157" alt="image" src="https://github.com/user-attachments/assets/c50834e6-4884-4262-ac12-e26c3c4cd9d8">


# Snowpark Python for Snowflake
Snowflake is a cloud-based data warehouse that is very popular among data scientists, engineers, and analysts. It offers a number of advantages over traditional on-premises data warehouses, including scalability, elasticity, and pay-as-you-go pricing.

Snowpark is a new developer experience for Snowflake that allows developers to write code in their preferred language (Python, Scala, and Java) and run that code directly on Snowflake.



# Snowflake data ingestion
<img width="1407" alt="image" src="https://github.com/user-attachments/assets/81b42eff-80a2-4cd6-bc88-519d93ce0118">

# Snowflake external storage such as S3
<img width="1400" alt="image" src="https://github.com/user-attachments/assets/6d118359-f380-4b63-a6f5-3750db55819a">
<img width="1416" alt="image" src="https://github.com/user-attachments/assets/a9379965-bc61-4a0c-93ac-c18c8d014adb">


# Snowflake bulk load vs continuous load vs stream load (snowpipe stream)
<img width="771" alt="image" src="https://github.com/user-attachments/assets/8b4e4d1f-0b94-412c-b217-25b55f853db0">
<img width="1463" alt="image" src="https://github.com/user-attachments/assets/89a629b7-1c92-49f2-b678-bb953e0cf849">
<img width="1432" alt="image" src="https://github.com/user-attachments/assets/d5d8b3f6-ff65-43ce-9637-3c145c0caa5a">
<img width="1469" alt="image" src="https://github.com/user-attachments/assets/3d6fbb8e-7c82-42b9-a977-39db4c703384">



# Snowflake views type 
<img width="1436" alt="image" src="https://github.com/user-attachments/assets/e79dd0cf-4468-4e9c-9b41-38c60f4ef44d">



# Snowflake Stream (similar to Dynamodb Stream record all changes to a table)
<img width="1430" alt="image" src="https://github.com/user-attachments/assets/b7250ebd-3575-43d7-ae87-8efa5187cbc5">


# Snowflake connector for Spark
<img width="1381" alt="image" src="https://github.com/user-attachments/assets/c2f939eb-9c91-4618-bab1-0da32fe69315">



# Resource optimization
<img width="1398" alt="image" src="https://github.com/user-attachments/assets/58ec1381-e690-4134-9161-7b8b38594a43">


<img width="1436" alt="image" src="https://github.com/user-attachments/assets/c9ec777a-edf8-43e3-95d3-bbff987232d8">

# Virtual Warehouse
<img width="1238" alt="image" src="https://github.com/user-attachments/assets/8e51ca8e-2e8b-4ec9-a2ec-e61a58ab65dc">
<img width="1430" alt="image" src="https://github.com/user-attachments/assets/83305708-df43-442e-935c-0905f5d670ac">


<img width="1454" alt="image" src="https://github.com/user-attachments/assets/a7ce3ab2-7a2a-4484-9531-b5ccbdcfe96f">


# Clustering key
<img width="1437" alt="image" src="https://github.com/user-attachments/assets/d55e5a85-090a-47ae-b599-3d8a6ddcb0f5">
<img width="1408" alt="image" src="https://github.com/user-attachments/assets/1dae55ac-4107-4ebe-93c0-8f058ebb594d">


# Snowflake account usage 
<img width="1428" alt="image" src="https://github.com/user-attachments/assets/78b5f365-29f5-4fa6-8d49-a51ce48cac90">


# Snowflake database parameter 
show parameters in database database_name
<img width="1051" alt="image" src="https://github.com/user-attachments/assets/ff01d394-54f7-426a-a3da-2857150fb118">

show tables in schema scheme-name 
<img width="1072" alt="image" src="https://github.com/user-attachments/assets/bc3e93aa-0e63-462a-80f7-585369c560fe">
SHOW TABLES IN DATABASE database-name



# Snowflake Failsafe
for permanent table only  (permanent table/transient table/temporary table )
<img width="657" alt="image" src="https://github.com/user-attachments/assets/3e07708e-1320-4310-a39e-9a8ed1c6a7d0">
<img width="825" alt="image" src="https://github.com/user-attachments/assets/cb48697c-e194-4f51-843a-b19b7912920d">


# Snowflake table change tracking for CDC
<img width="707" alt="image" src="https://github.com/user-attachments/assets/c4937fd0-7682-4b97-9989-9ef96f812f95">


# Snowflake table retention period and time travel
Snowflake, the table retention period generally refers to the Time Travel period. This period allows you to access historical data, enabling you to recover from accidental data modifications or deletions by "traveling back in time" to a previous state of the table.
<img width="1059" alt="image" src="https://github.com/user-attachments/assets/37176263-622f-4dcb-b900-ea522b0c25a9">



# Snowflake cost of 2x/3X/4X/5X/6X large 
<img width="1207" alt="image" src="https://github.com/user-attachments/assets/60f03915-74c9-40b9-9652-63d312e3fab4">

# Scale up and Scale out 
<img width="1241" alt="image" src="https://github.com/user-attachments/assets/56f6c37e-e3d1-432c-a391-30553de815a8">


# Fileformat in Snowflake for ingestion
<img width="1065" alt="image" src="https://github.com/user-attachments/assets/dfd5785a-783c-41d3-aecd-3eb145f388bd">


# Load CSV data into Snowflake Tables using InferSchema
InferSchema automates the schema inference process, intelligently deducing the structure of the CSV, Parquet and other file types. With this technique, analysts can swiftly create tables in Snowflake based on the inferred schema, eliminating the need for manual column definition. Once the tables are in place, executing the COPY INTO command seamlessly loads the data, expediting the entire process.

<img width="808" alt="image" src="https://github.com/user-attachments/assets/494b89f8-df4f-4d65-b692-fb00cd37d790">
<img width="872" alt="image" src="https://github.com/user-attachments/assets/4eb50129-3e3b-4725-a03c-72515b23ac4e">


# Enable ENABLE_SCHEMA_EVOLUTION




# Change data capture 
<img width="1206" alt="image" src="https://github.com/user-attachments/assets/b75bef6a-34b3-4ffa-9288-9e0fe0fab980">

# Snowflake database share across account 
<img width="1683" alt="image" src="https://github.com/user-attachments/assets/a4cbcfef-e13a-4355-8290-bcafb28f40c4">
<img width="1555" alt="image" src="https://github.com/user-attachments/assets/157815e6-d7c3-4071-a8b9-37a01ada6e74">

