USE RecruitingAnalytics;
GO

-- Drop existing (safe to re-run)
IF OBJECT_ID('dbo.stg_candidates')  IS NOT NULL DROP TABLE dbo.stg_candidates;
IF OBJECT_ID('dbo.stg_interviews')  IS NOT NULL DROP TABLE dbo.stg_interviews;
IF OBJECT_ID('dbo.stg_offers')      IS NOT NULL DROP TABLE dbo.stg_offers;
GO

-- Candidates (raw staging)
CREATE TABLE dbo.stg_candidates (
  candidate_id       INT           PRIMARY KEY,
  full_name          NVARCHAR(100) NOT NULL,
  role_applied       NVARCHAR(50)  NULL,
  source             NVARCHAR(50)  NULL,
  applied_date       DATE          NULL,
  years_experience   DECIMAL(4,1)  NULL,
  current_location   NVARCHAR(20)  NULL,
  status             NVARCHAR(20)  NULL
);
GO

-- Interviews (raw staging)
CREATE TABLE dbo.stg_interviews (
  interview_id        INT            PRIMARY KEY,
  candidate_id        INT            NOT NULL,
  stage               NVARCHAR(20)   NULL,
  scheduled_datetime  DATETIME2      NULL,
  interviewer         NVARCHAR(50)   NULL,
  result              NVARCHAR(20)   NULL
);
GO

-- Offers (raw staging)
CREATE TABLE dbo.stg_offers (
  offer_id            INT            PRIMARY KEY,
  candidate_id        INT            NOT NULL,
  role                NVARCHAR(50)   NULL,
  offered_salary_usd  INT            NULL,
  decision            NVARCHAR(20)   NULL,
  decision_date       DATE           NULL
);
GO
