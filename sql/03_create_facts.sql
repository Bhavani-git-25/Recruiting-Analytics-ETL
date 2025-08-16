USE RecruitingAnalytics;
GO

-- Clean re-run
IF OBJECT_ID('dbo.fact_candidate_stage') IS NOT NULL DROP TABLE dbo.fact_candidate_stage;
IF OBJECT_ID('dbo.fact_offer')          IS NOT NULL DROP TABLE dbo.fact_offer;
GO

-- Fact tables
CREATE TABLE dbo.fact_candidate_stage (
  candidate_key INT NOT NULL,
  role_key      INT NOT NULL,
  source_key    INT NOT NULL,
  applied_date  DATE,
  stage         NVARCHAR(20),
  result        NVARCHAR(20)
  -- Optional FK constraints can be added after load
);

CREATE TABLE dbo.fact_offer (
  candidate_key       INT NOT NULL,
  role_key            INT NOT NULL,
  offered_salary_usd  INT,
  decision            NVARCHAR(20),
  decision_date       DATE
  -- Optional FK constraints can be added after load
);
GO

-- Load facts from staging + dimensions
INSERT INTO dbo.fact_candidate_stage (candidate_key, role_key, source_key, applied_date, stage, result)
SELECT
  dc.candidate_key,
  dr.role_key,
  ds.source_key,
  sc.applied_date,
  si.stage,
  si.result
FROM dbo.stg_interviews si
JOIN dbo.stg_candidates sc ON sc.candidate_id = si.candidate_id
JOIN dbo.dim_candidate dc  ON dc.candidate_id = sc.candidate_id
JOIN dbo.dim_role dr       ON dr.role_name    = sc.role_applied
JOIN dbo.dim_source ds     ON ds.source_name  = sc.source;

INSERT INTO dbo.fact_offer (candidate_key, role_key, offered_salary_usd, decision, decision_date)
SELECT
  dc.candidate_key,
  dr.role_key,
  so.offered_salary_usd,
  so.decision,
  so.decision_date
FROM dbo.stg_offers so
JOIN dbo.dim_candidate dc ON dc.candidate_id = so.candidate_id
JOIN dbo.dim_role dr      ON dr.role_name    = so.role;
GO

-- Helpful indexes
CREATE INDEX IX_fcs_candidate    ON dbo.fact_candidate_stage (candidate_key);
CREATE INDEX IX_fcs_role_source  ON dbo.fact_candidate_stage (role_key, source_key);
CREATE INDEX IX_fo_role          ON dbo.fact_offer (role_key);
GO

-- Quick checks (optional)
-- SELECT COUNT(*) fact_candidate_stage FROM dbo.fact_candidate_stage;
-- SELECT COUNT(*) fact_offer FROM dbo.fact_offer;
