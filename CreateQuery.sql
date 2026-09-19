CREATE TABLE SubscriptionModules (
	Id INT PRIMARY KEY IDENTITY(1, 1),
	SubscriptionId INT NOT NULL,
	ModuleId INT NOT NULL,

	CONSTRAINT FK_SubscriptionModules_Subscriptions_SubscriptionId FOREIGN KEY (SubscriptionId) REFERENCES dbo.Subscriptions(Id),
	CONSTRAINT FK_SubscriptionModules_Modules_ModuleId FOREIGN KEY (ModuleId) REFERENCES dbo.Modules(Id)
);
