USE CRM_DB;
GO

-- ========================
-- Drop Tables (in reverse FK order to avoid dependency errors)
-- ========================
IF OBJECT_ID('TenantSubscriptions', 'U') IS NOT NULL DROP TABLE TenantSubscriptions;
IF OBJECT_ID('SubscriptionPlans', 'U') IS NOT NULL DROP TABLE SubscriptionPlans;
IF OBJECT_ID('UserRoles', 'U') IS NOT NULL DROP TABLE UserRoles;
IF OBJECT_ID('RolePermissions', 'U') IS NOT NULL DROP TABLE RolePermissions;
IF OBJECT_ID('Permissions', 'U') IS NOT NULL DROP TABLE Permissions;
IF OBJECT_ID('Roles', 'U') IS NOT NULL DROP TABLE Roles;
IF OBJECT_ID('Users', 'U') IS NOT NULL DROP TABLE Users;
IF OBJECT_ID('Tenants', 'U') IS NOT NULL DROP TABLE Tenants;
GO

CREATE TABLE Tenants (
    TenantId INT IDENTITY(1,1) PRIMARY KEY,
    TenantName NVARCHAR(200) NOT NULL,
    Domain NVARCHAR(200) NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE Roles (
    RoleId INT IDENTITY(1,1) PRIMARY KEY,
    TenantId INT NOT NULL FOREIGN KEY REFERENCES Tenants(TenantId),
    RoleName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE Permissions (
    PermissionId INT IDENTITY(1,1) PRIMARY KEY,
    PermissionName  NVARCHAR(200) NOT NULL,
    Code NVARCHAR(100) NOT NULL UNIQUE, -- e.g. CRM_READ_CONTACT
    Description NVARCHAR(255) NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE RolePermissions (
    RolePermissionId INT IDENTITY(1,1) PRIMARY KEY,
    RoleId INT NOT NULL FOREIGN KEY REFERENCES Roles(RoleId),
    PermissionId INT NOT NULL FOREIGN KEY REFERENCES Permissions(PermissionId),
    CONSTRAINT UQ_RolePermission UNIQUE(RoleId, PermissionId)
);

CREATE TABLE Users (
    UserId INT IDENTITY(1,1) PRIMARY KEY,
    TenantId INT NOT NULL FOREIGN KEY REFERENCES Tenants(TenantId),
    Email NVARCHAR(255) NOT NULL UNIQUE,
    DisplayName NVARCHAR(200) NOT NULL,
    AuthProvider NVARCHAR(50) NOT NULL, -- Microsoft | Google | Custom
    ExternalId NVARCHAR(255) NULL,      -- Maps to provider's ID
    PasswordHash NVARCHAR(500) NULL,    -- Only for Custom auth
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    LastLoginAt DATETIMEOFFSET NULL
);

CREATE TABLE UserRoles (
    UserRoleId INT IDENTITY(1,1) PRIMARY KEY,
    UserId INT NOT NULL FOREIGN KEY REFERENCES Users(UserId),
    RoleId INT NOT NULL FOREIGN KEY REFERENCES Roles(RoleId),
    CONSTRAINT UQ_UserRole UNIQUE(UserId, RoleId)
);




CREATE TABLE SubscriptionPlans (
    PlanId INT IDENTITY(1,1) PRIMARY KEY,
    PlanName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255) NULL,
    Price DECIMAL(10,2) NOT NULL DEFAULT 0,
    IsFree BIT NOT NULL DEFAULT 0,
    MaxUsers INT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);


CREATE TABLE TenantSubscriptions (
    SubscriptionId INT IDENTITY(1,1) PRIMARY KEY,
    TenantId INT NOT NULL FOREIGN KEY REFERENCES Tenants(TenantId),
    PlanId INT NOT NULL FOREIGN KEY REFERENCES SubscriptionPlans(PlanId),
    StartDate DATETIMEOFFSET NOT NULL DEFAULT SYSUTCDATETIME(),
    EndDate DATETIMEOFFSET NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CreatedAt DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);