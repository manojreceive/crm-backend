-- Create DB only if not exists
IF DB_ID('CRM_DB') IS NULL
    CREATE DATABASE CRM_DB;
GO

USE CRM_DB;
GO