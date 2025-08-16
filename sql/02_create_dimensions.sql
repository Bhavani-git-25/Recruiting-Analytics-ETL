USE RecruitingAnalytics;
GO

-- Clean re-run
IF OBJECT_ID('dbo.dim_role')      IS NOT NULL DROP TABLE dbo.dim_role;
IF OBJECT_ID('dbo.dim_source')    IS NOT NULL DROP TABLE dbo.dim_source;
IF OBJECT_ID('dbo.dim_candidate') IS NOT NULL DROP TABLE dbo.dim_candidate;
GO

-- Dimension tables
CREATE TABLE dbo.dim_role (
  role_key  INT IDENTITY(1,1) PRIMARY KEY,
  role_name NVARCHAR(50) UNIQUE
);

CREATE TABLE dbo.dim_source (
  source_key  INT IDENTITY(1,1) PRIMARY KEY,
  source_name NVARCHAR(50) UNIQUE
);

CREATE TABLE dbo.dim_candidate (
  candidate_key     INT IDENTITY(1,1) PRIMARY KEY,
  candidate_id      INT UNIQUE,
  full_name         NVARCHAR(100),
  current_location  NVARCHAR(20),
  years_experience  DECIMAL(4,1)
);
GO

-- Seed dimensions from staging
INSERT INTO dbo.dim_role (role_name)
SELECT DISTINCT role_applied
FROM dbo.stg_candidates
WHERE role_applied IS NOT NULL;

INSERT INTO dbo.dim_source (source_name)
SELECT DISTINCT source
FROM dbo.stg_candidates
WHERE source IS NOT NULL;

INSERT INTO dbo.dim_candidate (candidate_id, full_name, current_location, years_experience)
SELECT DISTINCT
  sc.candidate_id, sc.full_name, sc.current_location, sc.years_experience
FROM dbo.stg_candidates sc;
GO

-- Quick checks (optional)
-- SELECT COUNT(*) dim_role FROM dbo.dim_role;
-- SELECT COUNT(*) dim_source FROM dbo.dim_source;
-- SELECT COUNT(*) dim_candidate FROM dbo.dim_candidate;
