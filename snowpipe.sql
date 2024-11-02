Snowpipe is Snowflake's continuous data ingestion service that loads data from files as soon as they are available in a stage. When dealing with multiple file formats in the same S3 bucket, you can set up multiple Snowpipes, each configured for a specific file format, or handle the file format dynamically within a single pipe.

Here's what we'll cover:

Create a Storage Integration
Define File Formats for Each File Type
Create an External Stage with Partitioning
Create Target Tables
Create Snowpipes for Each File Format
Configure S3 Event Notifications
Monitor Snowpipe Load History

Step 1: Create a Storage Integration
  
-- In Snowflake

-- Create a storage integration
CREATE OR REPLACE STORAGE INTEGRATION my_s3_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::your-aws-account-id:role/snowflake_role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://your-bucket-name/');

-- After executing, Snowflake will return an AWS_EXTERNAL_ID and STORAGE_AWS_IAM_USER_ARN.
-- You'll need these for configuring AWS IAM roles and policies.





Step 2: Define File Formats for Each File Type
Create a separate file format for JSON, CSV, Parquet, and ORC.

JSON File Format
CREATE OR REPLACE FILE FORMAT json_format
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE
  IGNORE_UTF8_ERRORS = TRUE;


CSV File Format
CREATE OR REPLACE FILE FORMAT csv_format
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  RECORD_DELIMITER = '\n'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  NULL_IF = ('\\N', 'NULL', '')
  EMPTY_FIELD_AS_NULL = TRUE;


Parquet File Format
CREATE OR REPLACE FILE FORMAT parquet_format
  TYPE = 'PARQUET';

ORC File Format
CREATE OR REPLACE FILE FORMAT orc_format
  TYPE = 'ORC';


Step 3: Create an External Stage with Partitioning
Create an external stage pointing to your S3 bucket. If you have different directories for each file format, you can set up partitioning within the same stage.

CREATE OR REPLACE STAGE my_s3_stage
  URL = 's3://your-bucket-name/'
  STORAGE_INTEGRATION = my_s3_integration;




Thought for 6 seconds

Certainly! I'll provide a detailed guide to creating and monitoring Snowpipe for multiple file formats (JSON, CSV, Parquet, ORC) from scratch, including how to handle different file formats in the same Amazon S3 bucket and configuring S3 bucket event notifications.

Overview
Snowpipe is Snowflake's continuous data ingestion service that loads data from files as soon as they are available in a stage. When dealing with multiple file formats in the same S3 bucket, you can set up multiple Snowpipes, each configured for a specific file format, or handle the file format dynamically within a single pipe.

Here's what we'll cover:

Create a Storage Integration
Define File Formats for Each File Type
Create an External Stage with Partitioning
Create Target Tables
Create Snowpipes for Each File Format
Configure S3 Event Notifications
Monitor Snowpipe Load History
Step 1: Create a Storage Integration
A storage integration allows Snowflake to access your S3 bucket securely.

sql
Copy code
-- In Snowflake

-- Create a storage integration
CREATE OR REPLACE STORAGE INTEGRATION my_s3_integration
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::your-aws-account-id:role/snowflake_role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://your-bucket-name/');

-- After executing, Snowflake will return an AWS_EXTERNAL_ID and STORAGE_AWS_IAM_USER_ARN.
-- You'll need these for configuring AWS IAM roles and policies.
Configure AWS IAM Role:

Create an IAM Role named snowflake_role in AWS.
Attach a Policy to the role granting access to your S3 bucket.
json
Copy code
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::your-bucket-name",
        "arn:aws:s3:::your-bucket-name/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "sqs:*",
      "Resource": "arn:aws:sqs:your-region:your-account-id:snowpipe-sqs-queue"
    }
  ]
}
Add Trust Relationship to allow Snowflake to assume the role using the AWS_EXTERNAL_ID provided by Snowflake.
json
Copy code
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::Snowflake-Account-ID:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "AWS_EXTERNAL_ID_from_Snowflake"
        }
      }
    }
  ]
}
Step 2: Define File Formats for Each File Type
Create a separate file format for JSON, CSV, Parquet, and ORC.

JSON File Format
sql
Copy code
CREATE OR REPLACE FILE FORMAT json_format
  TYPE = 'JSON'
  STRIP_OUTER_ARRAY = TRUE
  IGNORE_UTF8_ERRORS = TRUE;
CSV File Format
sql
Copy code
CREATE OR REPLACE FILE FORMAT csv_format
  TYPE = 'CSV'
  FIELD_DELIMITER = ','
  RECORD_DELIMITER = '\n'
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  SKIP_HEADER = 1
  NULL_IF = ('\\N', 'NULL', '')
  EMPTY_FIELD_AS_NULL = TRUE;
Parquet File Format
sql
Copy code
CREATE OR REPLACE FILE FORMAT parquet_format
  TYPE = 'PARQUET';
ORC File Format
sql
Copy code
CREATE OR REPLACE FILE FORMAT orc_format
  TYPE = 'ORC';
Step 3: Create an External Stage with Partitioning
Create an external stage pointing to your S3 bucket. If you have different directories for each file format, you can set up partitioning within the same stage.

sql
Copy code
CREATE OR REPLACE STAGE my_s3_stage
  URL = 's3://your-bucket-name/'
  STORAGE_INTEGRATION = my_s3_integration;
Step 4: Create Target Tables
Define tables to store the ingested data. For simplicity, we'll create one table per file format.

JSON Target Table
CREATE OR REPLACE TABLE json_table (
  data VARIANT
);

CSV Target Table
CREATE OR REPLACE TABLE csv_table (
  id INT,
  name STRING,
  age INT
);

Step 5: Create Snowpipes for Each File Format
Since we have different file formats, it's advisable to create separate Snowpipes for each to handle specific loading requirements.

Snowpipe for JSON Files
CREATE OR REPLACE PIPE json_pipe
AUTO_INGEST = TRUE
AS
COPY INTO json_table
FROM (SELECT $1 FROM @my_s3_stage/json/)
FILE_FORMAT = (FORMAT_NAME = json_format)
PATTERN = '.*\.json$';


Snowpipe for CSV Files
CREATE OR REPLACE PIPE csv_pipe
AUTO_INGEST = TRUE
AS
COPY INTO csv_table
FROM @my_s3_stage/csv/
FILE_FORMAT = (FORMAT_NAME = csv_format)
PATTERN = '.*\.csv$';

Notes:

AUTO_INGEST = TRUE: Enables automatic data loading when new files arrive.
PATTERN: Ensures only files with the specified extension are processed by the pipe.
Directory Partitioning: We use subdirectories (json/, csv/, etc.) in the S3 bucket to organize files by format.



Step 6: Configure S3 Event Notifications
configure S3 bucket event notifications to enable Snowpipe to automatically ingest files when they arrive.


Understanding S3 Event Notifications with Snowpipe
Key Points:

S3 Event Notifications can be configured to send messages to Amazon SQS, Amazon SNS, or AWS Lambda when certain events occur (e.g., when a new file is uploaded to a bucket).
For Snowpipe, the recommended setup is to have S3 send notifications directly to an SQS queue, which Snowpipe will poll to detect new files.
All AWS resources involved (SQS queues, SNS topics, S3 buckets) are owned and managed within your AWS account, not by Snowflake.
Snowflake will access your SQS queue securely via the storage integration and associated AWS IAM role you set up.

Step 6: Configure S3 Event Notifications
We'll cover two options:

Option 1 (Recommended): Send S3 notifications directly to an SQS queue.
Option 2: Send S3 notifications to an SNS topic, with an SQS queue subscribed to that topic.
Option 1: Send S3 Notifications Directly to SQS
Step 6.1: Create an SQS Queue
Navigate to Amazon SQS in the AWS Management Console.
Click Create Queue.
Select Queue Type: Choose Standard Queue.
Name the Queue: For example, snowpipe-sqs-queue.
Configure Queue Settings: Leave default settings unless you have specific requirements.
Click Create Queue.
Step 6.2: Configure S3 Bucket Event Notifications to Send to SQS
Go to your S3 bucket in the AWS Management Console.
Click on the Properties tab.
Scroll down to Event notifications and click Create event notification.
Set Up the Event Notification:
Name: Enter a name (e.g., SnowpipeEvent).
Prefix (optional): Specify if you want to limit events to a specific folder (e.g., json/).
Suffix (optional): Specify if you want to limit events to specific file types (e.g., .json).
Event Types: Select All object create events.
Destination:
Select: SQS Queue.
Choose SQS Queue: Select the queue you created (snowpipe-sqs-queue).
Click Save changes.
Step 6.3: Set Permissions for the SQS Queue
Snowflake needs permission to read messages from your SQS queue.

Obtain Snowflake's AWS Account ID for your region from Snowflake's documentation.

Retrieve the External ID from your storage integration in Snowflake:

sql
Copy code
DESCRIBE STORAGE INTEGRATION my_s3_integration;
Look for the STORAGE_AWS_EXTERNAL_ID value.
Edit the Access Policy of the SQS Queue:

Go to your SQS queue (snowpipe-sqs-queue) in the AWS Console.

Click on the Permissions tab.

Under Access policy, click Edit.

Replace the existing policy with the following, updating placeholders:

json
Copy code
{
  "Version": "2012-10-17",
  "Id": "SnowflakeSQSPolicy",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<Snowflake-Region-Account-ID>:root"
      },
      "Action": [
        "SQS:ReceiveMessage",
        "SQS:DeleteMessage",
        "SQS:GetQueueAttributes",
        "SQS:GetQueueUrl"
      ],
      "Resource": "arn:aws:sqs:<Your-Region>:<Your-AWS-Account-ID>:snowpipe-sqs-queue",
      "Condition": {
        "StringEquals": {
          "aws:ExternalId": "<STORAGE_AWS_EXTERNAL_ID>"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "SQS:SendMessage",
      "Resource": "arn:aws:sqs:<Your-Region>:<Your-AWS-Account-ID>:snowpipe-sqs-queue",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "arn:aws:s3:::your-bucket-name"
        }
      }
    }
  ]
}
Replace:

<Snowflake-Region-Account-ID>: Snowflake's AWS account ID for your region.
<Your-Region>: Your AWS region (e.g., us-east-1).
<Your-AWS-Account-ID>: Your AWS account ID.
snowpipe-sqs-queue: The name of your SQS queue.
<STORAGE_AWS_EXTERNAL_ID>: The external ID from your storage integration.
your-bucket-name: Your S3 bucket name.
Click Save to apply the policy.

Step 6.4: Ensure IAM Role Trusts Snowflake
The IAM role associated with your storage integration must trust Snowflake:

Go to IAM Roles in AWS Console.

Find and select the IAM role you created for Snowflake (snowflake_role).

Click on the Trust relationships tab.

Click Edit trust relationship.

Ensure the trust policy allows Snowflake to assume the role using the external ID:

json
Copy code
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<Snowflake-Region-Account-ID>:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "<STORAGE_AWS_EXTERNAL_ID>"
        }
      }
    }
  ]
}
Replace placeholders as before.

Click Update Trust Policy.

Important Clarifications
Ownership of AWS Resources:

SQS Queues : Owned and managed by you in your AWS account.
Snowflake's Role: Snowflake accesses your SQS queue to receive event notifications. It does not own or manage the SQS resources.
Permissions and Security:

IAM Roles and Policies: You grant Snowflake permission to read from your SQS queue via IAM policies and the storage integration's external ID.
External ID: Ensures that only Snowflake can assume the role and access the SQS queue securely.
Event Notification Destination:

Recommended: Send S3 notifications directly to an SQS queue.

  

Step 7: Monitor Snowpipe Load History
You can monitor the load history using the INFORMATION_SCHEMA.LOAD_HISTORY table function or COPY_HISTORY view.
  

SELECT * 
FROM TABLE(INFORMATION_SCHEMA.LOAD_HISTORY(
    TABLE_NAME => 'your_table_name',
    START_TIME => DATEADD('day', -1, CURRENT_TIMESTAMP())
));


SELECT * 
FROM TABLE(INFORMATION_SCHEMA.LOAD_HISTORY(
    START_TIME => DATEADD('day', -7, CURRENT_TIMESTAMP())
));



SELECT *
FROM TABLE(INFORMATION_SCHEMA.LOAD_HISTORY(
    PIPE_NAME => 'my_snowpipe',
    START_TIME => DATEADD('day', -7, CURRENT_TIMESTAMP())
))
WHERE STATUS = 'LOAD_FAILED';
