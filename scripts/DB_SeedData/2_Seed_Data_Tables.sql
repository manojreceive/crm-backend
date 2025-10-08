USE CRM_DB;
GO

INSERT INTO Tenants (TenantName, Domain, IsActive, CreatedAt)
VALUES
('DemoTenant', 'demo.crm.local', 1, SYSUTCDATETIME()),
('UATTenant', 'uat.crm.local', 1, SYSUTCDATETIME()),
('LiveTenant', 'live.crm.local', 1, SYSUTCDATETIME());
GO

-- Verify insert
SELECT * FROM Tenants;

USE CRM_DB;
GO

-- Seed Roles for each Tenant
INSERT INTO Roles (TenantId, RoleName, Description, CreatedAt)
SELECT t.TenantId, 'Admin', 'Full access to all features', SYSUTCDATETIME()
FROM Tenants t
WHERE NOT EXISTS (
    SELECT 1 FROM Roles r WHERE r.TenantId = t.TenantId AND r.RoleName = 'Admin'
);

INSERT INTO Roles (TenantId, RoleName, Description, CreatedAt)
SELECT t.TenantId, 'Manager', 'Manage team members and CRM records', SYSUTCDATETIME()
FROM Tenants t
WHERE NOT EXISTS (
    SELECT 1 FROM Roles r WHERE r.TenantId = t.TenantId AND r.RoleName = 'Manager'
);

INSERT INTO Roles (TenantId, RoleName, Description, CreatedAt)
SELECT t.TenantId, 'User', 'Standard CRM user with limited permissions', SYSUTCDATETIME()
FROM Tenants t
WHERE NOT EXISTS (
    SELECT 1 FROM Roles r WHERE r.TenantId = t.TenantId AND r.RoleName = 'User'
);

INSERT INTO Roles (TenantId, RoleName, Description, CreatedAt)
SELECT t.TenantId, 'ReadOnly', 'Can only view data, no modifications allowed', SYSUTCDATETIME()
FROM Tenants t
WHERE NOT EXISTS (
    SELECT 1 FROM Roles r WHERE r.TenantId = t.TenantId AND r.RoleName = 'ReadOnly'
);
GO

-- Verify insert
SELECT * FROM Roles ORDER BY TenantId, RoleId;

USE CRM_DB;
GO

-- Leads
INSERT INTO Permissions (PermissionName, Code, Description, CreatedAt) VALUES
('Read Leads', 'CRM_READ_LEAD', 'Permission to view leads', SYSUTCDATETIME()),
('Create Leads', 'CRM_CREATE_LEAD', 'Permission to create new leads', SYSUTCDATETIME()),
('Update Leads', 'CRM_UPDATE_LEAD', 'Permission to update leads', SYSUTCDATETIME()),
('Delete Leads', 'CRM_DELETE_LEAD', 'Permission to delete leads', SYSUTCDATETIME());

-- Contacts
INSERT INTO Permissions (PermissionName, Code, Description, CreatedAt) VALUES
('Read Contacts', 'CRM_READ_CONTACT', 'Permission to view contacts', SYSUTCDATETIME()),
('Create Contacts', 'CRM_CREATE_CONTACT', 'Permission to create new contacts', SYSUTCDATETIME()),
('Update Contacts', 'CRM_UPDATE_CONTACT', 'Permission to update contacts', SYSUTCDATETIME()),
('Delete Contacts', 'CRM_DELETE_CONTACT', 'Permission to delete contacts', SYSUTCDATETIME());

-- Opportunities
INSERT INTO Permissions (PermissionName, Code, Description, CreatedAt) VALUES
('Read Opportunities', 'CRM_READ_OPPORTUNITY', 'Permission to view opportunities', SYSUTCDATETIME()),
('Create Opportunities', 'CRM_CREATE_OPPORTUNITY', 'Permission to create opportunities', SYSUTCDATETIME()),
('Update Opportunities', 'CRM_UPDATE_OPPORTUNITY', 'Permission to update opportunities', SYSUTCDATETIME()),
('Delete Opportunities', 'CRM_DELETE_OPPORTUNITY', 'Permission to delete opportunities', SYSUTCDATETIME());

-- Users
INSERT INTO Permissions (PermissionName, Code, Description, CreatedAt) VALUES
('Read Users', 'CRM_READ_USER', 'Permission to view users', SYSUTCDATETIME()),
('Create Users', 'CRM_CREATE_USER', 'Permission to create users', SYSUTCDATETIME()),
('Update Users', 'CRM_UPDATE_USER', 'Permission to update users', SYSUTCDATETIME()),
('Delete Users', 'CRM_DELETE_USER', 'Permission to delete users', SYSUTCDATETIME());

-- Roles
INSERT INTO Permissions (PermissionName, Code, Description, CreatedAt) VALUES
('Read Roles', 'CRM_READ_ROLE', 'Permission to view roles', SYSUTCDATETIME()),
('Create Roles', 'CRM_CREATE_ROLE', 'Permission to create roles', SYSUTCDATETIME()),
('Update Roles', 'CRM_UPDATE_ROLE', 'Permission to update roles', SYSUTCDATETIME()),
('Delete Roles', 'CRM_DELETE_ROLE', 'Permission to delete roles', SYSUTCDATETIME());

-- Subscriptions
INSERT INTO Permissions (PermissionName, Code, Description, CreatedAt) VALUES
('Read Subscriptions', 'CRM_READ_SUBSCRIPTION', 'Permission to view subscriptions', SYSUTCDATETIME()),
('Update Subscriptions', 'CRM_UPDATE_SUBSCRIPTION', 'Permission to update subscriptions', SYSUTCDATETIME());

-- Reports & Analytics
INSERT INTO Permissions (PermissionName, Code, Description, CreatedAt) VALUES
('View Reports', 'CRM_VIEW_REPORTS', 'Permission to view reports and analytics', SYSUTCDATETIME());

-- Settings
INSERT INTO Permissions (PermissionName, Code, Description, CreatedAt) VALUES
('Manage Settings', 'CRM_MANAGE_SETTINGS', 'Permission to manage system settings', SYSUTCDATETIME());
GO

-- Verify
SELECT * FROM Permissions ORDER BY PermissionId;


USE CRM_DB;
GO

-- ================
-- 1. Admin gets all permissions
-- ================
INSERT INTO RolePermissions (RoleId, PermissionId)
SELECT r.RoleId, p.PermissionId
FROM Roles r
CROSS JOIN Permissions p
WHERE r.RoleName = 'Admin'
AND NOT EXISTS (
    SELECT 1 FROM RolePermissions rp
    WHERE rp.RoleId = r.RoleId AND rp.PermissionId = p.PermissionId
);

-- ================
-- 2. Manager permissions
-- ================
INSERT INTO RolePermissions (RoleId, PermissionId)
SELECT r.RoleId, p.PermissionId
FROM Roles r
JOIN Permissions p ON p.Code IN (
    'CRM_READ_LEAD','CRM_CREATE_LEAD','CRM_UPDATE_LEAD','CRM_DELETE_LEAD',
    'CRM_READ_CONTACT','CRM_CREATE_CONTACT','CRM_UPDATE_CONTACT','CRM_DELETE_CONTACT',
    'CRM_READ_OPPORTUNITY','CRM_CREATE_OPPORTUNITY','CRM_UPDATE_OPPORTUNITY','CRM_DELETE_OPPORTUNITY',
    'CRM_READ_USER','CRM_VIEW_REPORTS'
)
WHERE r.RoleName = 'Manager'
AND NOT EXISTS (
    SELECT 1 FROM RolePermissions rp
    WHERE rp.RoleId = r.RoleId AND rp.PermissionId = p.PermissionId
);

-- ================
-- 3. User permissions
-- ================
INSERT INTO RolePermissions (RoleId, PermissionId)
SELECT r.RoleId, p.PermissionId
FROM Roles r
JOIN Permissions p ON p.Code IN (
    'CRM_READ_LEAD','CRM_CREATE_LEAD','CRM_UPDATE_LEAD','CRM_DELETE_LEAD',
    'CRM_READ_CONTACT'
)
WHERE r.RoleName = 'User'
AND NOT EXISTS (
    SELECT 1 FROM RolePermissions rp
    WHERE rp.RoleId = r.RoleId AND rp.PermissionId = p.PermissionId
);

-- ================
-- 4. ReadOnly permissions
-- ================
INSERT INTO RolePermissions (RoleId, PermissionId)
SELECT r.RoleId, p.PermissionId
FROM Roles r
JOIN Permissions p ON p.Code IN (
    'CRM_READ_LEAD',
    'CRM_READ_CONTACT',
    'CRM_READ_OPPORTUNITY'
)
WHERE r.RoleName = 'ReadOnly'
AND NOT EXISTS (
    SELECT 1 FROM RolePermissions rp
    WHERE rp.RoleId = r.RoleId AND rp.PermissionId = p.PermissionId
);
GO

-- Verify
SELECT r.RoleName, p.Code, p.PermissionName
FROM RolePermissions rp
JOIN Roles r ON rp.RoleId = r.RoleId
JOIN Permissions p ON rp.PermissionId = p.PermissionId
ORDER BY r.RoleName, p.Code;


USE CRM_DB;
GO

DECLARE @Password NVARCHAR(200) = 'Admin@123';
DECLARE @Hash VARBINARY(64) = HASHBYTES('SHA2_512', @Password);

-- Insert default Admin Users for each Tenant with hashed password
INSERT INTO Users (TenantId, Email, DisplayName, AuthProvider, ExternalId, PasswordHash, IsActive, CreatedAt)
SELECT t.TenantId,
       CONCAT(LOWER(t.TenantName), '.admin@crm.local') AS Email,
       CONCAT(t.TenantName, ' Admin') AS DisplayName,
       'Custom' AS AuthProvider,
       NULL AS ExternalId,
       CONVERT(NVARCHAR(128), @Hash, 2) AS PasswordHash, -- store hex string
       1 AS IsActive,
       SYSUTCDATETIME()
FROM Tenants t
WHERE NOT EXISTS (
    SELECT 1 FROM Users u WHERE u.TenantId = t.TenantId AND u.Email = CONCAT(LOWER(t.TenantName), '.admin@crm.local')
);
GO

-- Verify
SELECT UserId, TenantId, Email, DisplayName, PasswordHash
FROM Users;


USE CRM_DB;
GO

-- Assign each Admin user to the Admin role in its tenant
INSERT INTO UserRoles (UserId, RoleId)
SELECT u.UserId, r.RoleId
FROM Users u
JOIN Roles r 
  ON u.TenantId = r.TenantId 
 AND r.RoleName = 'Admin'
WHERE u.Email LIKE '%.admin@crm.local'
AND NOT EXISTS (
    SELECT 1 FROM UserRoles ur 
    WHERE ur.UserId = u.UserId AND ur.RoleId = r.RoleId
);
GO

-- Verify
SELECT ur.UserRoleId, u.Email, r.RoleName, t.TenantName
FROM UserRoles ur
JOIN Users u ON ur.UserId = u.UserId
JOIN Roles r ON ur.RoleId = r.RoleId
JOIN Tenants t ON u.TenantId = t.TenantId
ORDER BY t.TenantName, u.Email;

USE CRM_DB;
GO




-- Free Plan
INSERT INTO SubscriptionPlans (PlanName, Description, Price, IsFree, MaxUsers, CreatedAt)
SELECT 'Free', 'Basic plan with limited features, ideal for trials.', 0, 1, 3, SYSUTCDATETIME()
WHERE NOT EXISTS (SELECT 1 FROM SubscriptionPlans WHERE PlanName = 'Free');

-- Standard Plan
INSERT INTO SubscriptionPlans (PlanName, Description, Price, IsFree, MaxUsers, CreatedAt)
SELECT 'Standard', 'Includes core CRM features for small teams.', 999.00, 0, 20, SYSUTCDATETIME()
WHERE NOT EXISTS (SELECT 1 FROM SubscriptionPlans WHERE PlanName = 'Standard');

-- Enterprise Plan
INSERT INTO SubscriptionPlans (PlanName, Description, Price, IsFree, MaxUsers, CreatedAt)
SELECT 'Enterprise', 'Full CRM suite with advanced features and unlimited users.', 4999.00, 0, NULL, SYSUTCDATETIME()
WHERE NOT EXISTS (SELECT 1 FROM SubscriptionPlans WHERE PlanName = 'Enterprise');
GO

-- Verify
SELECT * FROM SubscriptionPlans;



USE CRM_DB;
GO

-- DemoTenant → Free Plan (30 days)
INSERT INTO TenantSubscriptions (TenantId, PlanId, StartDate, EndDate, IsActive, CreatedAt)
SELECT t.TenantId, p.PlanId, SYSUTCDATETIME(), DATEADD(DAY, 30, SYSUTCDATETIME()), 1, SYSUTCDATETIME()
FROM Tenants t
JOIN SubscriptionPlans p ON p.PlanName = 'Free'
WHERE t.TenantName = 'DemoTenant'
  AND NOT EXISTS (
      SELECT 1 FROM TenantSubscriptions ts 
      WHERE ts.TenantId = t.TenantId AND ts.PlanId = p.PlanId
  );

-- UATTenant → Standard Plan (1 year)
INSERT INTO TenantSubscriptions (TenantId, PlanId, StartDate, EndDate, IsActive, CreatedAt)
SELECT t.TenantId, p.PlanId, SYSUTCDATETIME(), DATEADD(YEAR, 1, SYSUTCDATETIME()), 1, SYSUTCDATETIME()
FROM Tenants t
JOIN SubscriptionPlans p ON p.PlanName = 'Standard'
WHERE t.TenantName = 'UATTenant'
  AND NOT EXISTS (
      SELECT 1 FROM TenantSubscriptions ts 
      WHERE ts.TenantId = t.TenantId AND ts.PlanId = p.PlanId
  );

-- LiveTenant → Enterprise Plan (1 year)
INSERT INTO TenantSubscriptions (TenantId, PlanId, StartDate, EndDate, IsActive, CreatedAt)
SELECT t.TenantId, p.PlanId, SYSUTCDATETIME(), DATEADD(YEAR, 1, SYSUTCDATETIME()), 1, SYSUTCDATETIME()
FROM Tenants t
JOIN SubscriptionPlans p ON p.PlanName = 'Enterprise'
WHERE t.TenantName = 'LiveTenant'
  AND NOT EXISTS (
      SELECT 1 FROM TenantSubscriptions ts 
      WHERE ts.TenantId = t.TenantId AND ts.PlanId = p.PlanId
  );
GO

-- Verify
SELECT ts.SubscriptionId, tn.TenantName, sp.PlanName, ts.StartDate, ts.EndDate, ts.IsActive
FROM TenantSubscriptions ts
JOIN Tenants tn ON ts.TenantId = tn.TenantId
JOIN SubscriptionPlans sp ON ts.PlanId = sp.PlanId
ORDER BY tn.TenantName;
