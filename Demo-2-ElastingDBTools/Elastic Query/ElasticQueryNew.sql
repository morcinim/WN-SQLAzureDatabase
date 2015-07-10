-- Create a db master key if one does not already exist, using your own password.
CREATE MASTER KEY ENCRYPTION BY PASSWORD='RedW1ne!';

-- Create a database credential
-- Note – this syntax is temporary and will be changed in the next release.
CREATE CREDENTIAL cred ON DATABASE WITH IDENTITY = 'morcinim', SECRET='RedW1ne!';
-- For high security, drop the credential when it is no longer in use. 
-- Note, this syntax is temporary and will be changed in the next release.
-- DROP CREDENTIAL cred ON DATABASE;

-- DROP EXTERNAL DATA SOURCE AllBlogsDBs
CREATE EXTERNAL DATA SOURCE AllBlogsDBs
WITH
(
TYPE=SHARD_MAP_MANAGER,
LOCATION='eu-west-gps-v12.database.windows.net',
DATABASE_NAME='ShardMgtDB',
CREDENTIAL = cred,
SHARD_MAP_NAME='ElasticScaleWithEF'
);
select * from sys.external_data_sources;
-- The Shard Map Name
-- SELECT * FROM __ShardManagement.ShardMapsGlobal

-- DROP EXTERNAL TABLE [dbo].[AllBlogs]
CREATE EXTERNAL TABLE [dbo].[AllBlogs](
	[BlogId] [int]  NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Url] [nvarchar](max) NULL
)
WITH
(
DATA_SOURCE = AllBlogsDBs,
DISTRIBUTION=SHARDED([CustomerId])
);

select * from sys.external_tables;

-- RUN Queries
select * from  [dbo].[AllBlogs] order by Url
