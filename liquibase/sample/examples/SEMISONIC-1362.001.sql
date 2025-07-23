--USE Integra_production;
--GO


/* =============================================                    
 Author:  Madhusudan Garai                    
 Create date: 12/17/2020                    
 Description: When the Recorded Mortgage Processed Date & Received Date are missing, get all the loan details to table USFS_PostClosingMissingFinalDocs                    
 Usage:     
     
 Declare @LoanList as dbo.LoanIdentifierAndUserId;     
  INSERT INTO @LoanList      
 (      
  LenderDatabaseId,      
  LoanRecordId ,    
  UserId    
 )      
 VALUES      
 (1,21428516, 1),      
 (1,21396096, 1),      
 (1,21396097, 1);    
  EXEC [dbo].[USFS_Insert_PostClosingMissingFinalDocs]     @LoanList=@LoanList                 
---------------------------------------------------------------------------------------------                    
--                      M O D I F I C A T I O N     L O G                    
---------------------------------------------------------------------------------------------                    
-- NAME      DATE    COMMENTS                    
---------------------------------------------------------------------------------------------                    
-- Madhusudan Garai   12/17/2020   Created                    
-- Madhusudan Garai   03/10/2021   Changed to alter email address               
-- Lauren Wierzbicki  06/28/2022   Performance- fix join               
-- Sarah Yoo    07/20/2022   Altering SPROC to add in CO-OP product            
-- Sarah Yoo    07/20/2022   Altering SPROC to add in HELOC product            
-- Madhusudan Garai 09/29/2022 Altering to add product 835,836          
-- Madhusudan Garai 10/26/2022 Altering to TRAC Type        
-- Madhusudan Garai  05/05/2023 MORTPROD-209-Stop sending emails for Missing title policy on HELOC 3 YR      
-- Venkata Nagendra babu 10/02/2023  OPS-4289 - Automatic Email- HELOC for Missing Title Policy     
-- Madhusudan Garai    03/13/2024 OPS-6560,SEMISONIC-406  Semisonic    
-- Madhusudan Garai   05/22/2024  OPS-7291 - TRAC | Not sending FTP or BOT emails   
-- Madhusudan Garai   09/04/2024  TTLACPT-14 - Do not send email for missing FTP   
-- Venkata Nagendra babu 11/18/2023  TTLACPT-95 -  Automatic Email - New Templates for TRAC Lite  
-- Madhusudan Garai      02/21/2025 SEMISONIC-1362 - Database | FD Auto Email | TRAC + Essent | Update Email Address 
 ============================================= */

ALTER PROCEDURE [dbo].[USFS_Insert_PostClosingMissingFinalDocs]
(@LoanList dbo.LoanIdentifierAndUserId READONLY)
AS
BEGIN

    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ZeroDown VARCHAR(8) = '0Down%';

    IF EXISTS
    (
        SELECT 1
        FROM [dbo].[USFS_PostClosingMissingFinalDocs] WITH (NOLOCK)
    )
    BEGIN
        DELETE FROM [dbo].[USFS_PostClosingMissingFinalDocs]
        WHERE [IsProcessingIssue] IS NOT NULL;
    END;
    BEGIN TRY


        DROP TABLE IF EXISTS #FilterData;

        CREATE TABLE #FilterData
        (
            [lenderdatabaseid] INT NOT NULL,
            [loanrecordid] INT NOT NULL,
            [DocType] CHAR(3) NOT NULL,
            [productid] INT NOT NULL,
            [actualclosingdate] DATETIME NOT NULL,
            [loanid] VARCHAR(20) NOT NULL,
            [CommitmentNumber] VARCHAR(127) NOT NULL,
            [addressline1] VARCHAR(50) NULL,
            [addressline2] VARCHAR(50) NULL,
            [city] VARCHAR(50) NULL,
            [county] VARCHAR(30) NULL,
            [state] VARCHAR(2) NULL,
            [zipcode] VARCHAR(15) NULL,
            [customergroupid] INT NOT NULL,
            [secondRecordedDate] INT NULL
        );

        INSERT INTO #FilterData
        (
            [lenderdatabaseid],
            [loanrecordid],
            [DocType],
            [productid],
            [actualclosingdate],
            [loanid],
            [CommitmentNumber],
            [addressline1],
            [addressline2],
            [city],
            [county],
            [state],
            [zipcode],
            [customergroupid],
            [secondRecordedDate]
        )
        SELECT LM.lenderdatabaseid,
               LM.loanrecordid,
               'NAN',
               LM.productid,
               LM.actualclosingdate,
               LM.loanid,
               LT.CommitmentNumber,
               PM.addressline1,
               PM.addressline2,
               PM.city,
               PM.county,
               PM.[state],
               PM.zipcode,
               LM.customergroupid,
               LM1.userid
        FROM [dbo].loan_main AS LM WITH (NOLOCK)
            INNER JOIN @LoanList LM1
                ON LM1.LenderDatabaseId = LM.lenderdatabaseid
                   AND LM1.LoanRecordId = LM.loanrecordid
            INNER JOIN [dbo].USFS_LoanTitle AS LT WITH (NOLOCK)
                ON LT.lenderdatabaseid = LM.lenderdatabaseid
                   AND LT.loanrecordid = LM.loanrecordid
            INNER JOIN [dbo].property_main AS PM WITH (NOLOCK)
                ON PM.lenderdatabaseid = LM.propertylenderdatabaseid
                   AND PM.propertyrecordid = LM.propertyrecordid;


        UPDATE LM
        SET [DocType] = CASE
                            WHEN
                            (
                                (
                                    (
                                        CLPD.FinalTitlePolicyOutstandingDocumentReceived IS NOT NULL
                                        AND CAST(CLPD.FinalTitlePolicyOutstandingDocumentReceived AS DATE) <> '1800-01-01'
                                    )
                                    OR
                                    (
                                        trac.TRACTypeID IS NOT NULL
                                        AND trac.TRACTypeID = 1
                                    )
                                )
                                AND
                                (
                                    CAST(CLPD.RecordedMortgageOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                    OR CLPD.RecordedMortgageOutstandingDocumentReceived IS NULL
                                )
                                AND LM.secondRecordedDate = 0
                                AND
                                (
                                    cpm.ProductGroupName IS NOT NULL
                                    AND cpm.ProductGroupName LIKE @ZeroDown
                                )
                            ) THEN
                                'BMT'
                            WHEN
                            (
                                (
                                    (
                                        CLPD.FinalTitlePolicyOutstandingDocumentReceived IS NOT NULL
                                        AND CAST(CLPD.FinalTitlePolicyOutstandingDocumentReceived AS DATE) <> '1800-01-01'
                                    )
                                    OR
                                    (
                                        trac.TRACTypeID IS NOT NULL
                                        AND trac.TRACTypeID = 1
                                    )
                                )
                                AND
                                (
                                    CAST(CLPD.RecordedMortgageOutstandingDocumentReceived AS DATE) <> '1800-01-01'
                                    AND CLPD.RecordedMortgageOutstandingDocumentReceived IS NOT NULL
                                )
                                AND LM.secondRecordedDate = 0
                                AND
                                (
                                    cpm.ProductGroupName IS NOT NULL
                                    AND cpm.ProductGroupName LIKE @ZeroDown
                                )
                            ) THEN
                                '2MT'
                            WHEN
                            (
                                (
                                    (
                                        trac.TRACTypeID IS NULL
                                        OR trac.TRACTypeID NOT IN ( 1, 3 )
                                    )
                                    AND
                                    (
                                        CLPD.FinalTitlePolicyOutstandingDocumentReceived IS NULL
                                        OR CAST(CLPD.FinalTitlePolicyOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                    )
                                )
                                AND
                                (
                                    CAST(CLPD.RecordedMortgageOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                    OR CLPD.RecordedMortgageOutstandingDocumentReceived IS NULL
                                )
                                AND LM.secondRecordedDate = 0
                                AND
                                (
                                    cpm.ProductGroupName IS NOT NULL
                                    AND cpm.ProductGroupName LIKE @ZeroDown
                                )
                            ) THEN
                                '2MA'
                            WHEN
                            (
                                (
                                    (
                                        trac.TRACTypeID IS NULL
                                        OR trac.TRACTypeID NOT IN ( 1, 3 )
                                    )
                                    AND
                                    (
                                        CLPD.FinalTitlePolicyOutstandingDocumentReceived IS NULL
                                        OR CAST(CLPD.FinalTitlePolicyOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                    )
                                )
                                AND
                                (
                                    CAST(CLPD.RecordedMortgageOutstandingDocumentReceived AS DATE) <> '1800-01-01'
                                    AND CLPD.RecordedMortgageOutstandingDocumentReceived IS NOT NULL
                                )
                                AND LM.secondRecordedDate = 0
                                AND
                                (
                                    cpm.ProductGroupName IS NOT NULL
                                    AND cpm.ProductGroupName LIKE @ZeroDown
                                )
                            ) THEN
                                '2MF'
                            WHEN
                            (
                                (
                                    (
                                        trac.TRACTypeID IS NULL
                                        OR trac.TRACTypeID <> 1
                                    )
                                    AND
                                    (
                                        CLPD.FinalTitlePolicyOutstandingDocumentReceived IS NOT NULL
                                        AND CAST(CLPD.FinalTitlePolicyOutstandingDocumentReceived AS DATE) <> '1800-01-01'
                                    )
                                    AND
                                    (
                                        CAST(CLPD.RecordedMortgageOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                        OR CLPD.RecordedMortgageOutstandingDocumentReceived IS NULL
                                    )
                                    AND
                                    (
                                        (
                                            LM.secondRecordedDate = 1
                                            AND cpm.ProductGroupName IS NOT NULL
                                            AND cpm.ProductGroupName LIKE @ZeroDown
                                        )
                                        OR
                                        (
                                            cpm.ProductGroupName IS NULL
                                            OR cpm.ProductGroupName <> @ZeroDown
                                        )
                                    )
                                )
                                OR
                                (
                                    (
                                        trac.TRACTypeID IS NOT NULL
                                        AND trac.TRACTypeID IN ( 1 )
                                    )
                                    AND
                                    (
                                        (
                                            CLPD.FinalTitlePolicyOutstandingDocumentReceived IS NULL
                                            OR CAST(CLPD.FinalTitlePolicyOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                        )
                                        AND
                                        (
                                            CAST(CLPD.RecordedMortgageOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                            OR CLPD.RecordedMortgageOutstandingDocumentReceived IS NULL
                                        )
                                    )
                                    AND
                                    (
                                        (
                                            LM.secondRecordedDate = 1
                                            AND cpm.ProductGroupName IS NOT NULL
                                            AND cpm.ProductGroupName LIKE @ZeroDown
                                        )
                                        OR
                                        (
                                            cpm.ProductGroupName IS NULL
                                            OR cpm.ProductGroupName <> @ZeroDown
                                        )
                                    )
                                )
                            ) THEN
                                'MTG'
                            WHEN
                            (
                                (
                                    trac.TRACTypeID IS NULL
                                    OR trac.TRACTypeID NOT IN ( 1, 3 )
                                )
                                AND
                                (
                                    CLPD.FinalTitlePolicyOutstandingDocumentReceived IS NULL
                                    OR CAST(CLPD.FinalTitlePolicyOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                )
                                AND
                                (
                                    CAST(CLPD.RecordedMortgageOutstandingDocumentReceived AS DATE) <> '1800-01-01'
                                    AND CLPD.RecordedMortgageOutstandingDocumentReceived IS NOT NULL
                                )
                                AND
                                (
                                    (
                                        LM.secondRecordedDate = 1
                                        AND cpm.ProductGroupName IS NOT NULL
                                        AND cpm.ProductGroupName LIKE @ZeroDown
                                    )
                                    OR
                                    (
                                        cpm.ProductGroupName IS NULL
                                        OR cpm.ProductGroupName <> @ZeroDown
                                    )
                                )
                            ) THEN
                                'FTP'
                            WHEN
                            (
                                (
                                    trac.TRACTypeID IS NULL
                                    OR trac.TRACTypeID NOT IN ( 1, 3 )
                                )
                                AND
                                (
                                    CLPD.FinalTitlePolicyOutstandingDocumentReceived IS NULL
                                    OR CAST(CLPD.FinalTitlePolicyOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                )
                                AND
                                (
                                    CAST(CLPD.RecordedMortgageOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                    OR CLPD.RecordedMortgageOutstandingDocumentReceived IS NULL
                                )
                                AND
                                (
                                    (
                                        LM.secondRecordedDate = 1
                                        AND cpm.ProductGroupName IS NOT NULL
                                        AND cpm.ProductGroupName LIKE @ZeroDown
                                    )
                                    OR
                                    (
                                        cpm.ProductGroupName IS NULL
                                        OR cpm.ProductGroupName <> @ZeroDown
                                    )
                                )
                            ) THEN
                                'BOT'
                            WHEN
                            (
                                (
                                    trac.TRACTypeID IS NULL
                                    OR trac.TRACTypeID IN ( 3 )
                                )
                                AND
                                (
                                    CLPD.FinalTitlePolicyOutstandingDocumentReceived IS NULL
                                    OR CAST(CLPD.FinalTitlePolicyOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                )
                                AND
                                (
                                    CAST(CLPD.RecordedMortgageOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                    OR CLPD.RecordedMortgageOutstandingDocumentReceived IS NULL
                                )
                                AND LM.secondRecordedDate = 0
                                AND
                                (
                                    cpm.ProductGroupName IS NOT NULL
                                    AND cpm.ProductGroupName LIKE @ZeroDown
                                )
                            ) THEN
                                '2PA'
                            WHEN
                            (
                                (
                                    trac.TRACTypeID IS NULL
                                    OR trac.TRACTypeID IN ( 3 )
                                )
                                AND
                                (
                                    CLPD.FinalTitlePolicyOutstandingDocumentReceived IS NULL
                                    OR CAST(CLPD.FinalTitlePolicyOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                )
                                AND
                                (
                                    CAST(CLPD.RecordedMortgageOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                    OR CLPD.RecordedMortgageOutstandingDocumentReceived IS NULL
                                )
                                AND
                                (
                                    (
                                        LM.secondRecordedDate = 1
                                        AND cpm.ProductGroupName IS NOT NULL
                                        AND cpm.ProductGroupName LIKE @ZeroDown
                                    )
                                    OR
                                    (
                                        cpm.ProductGroupName IS NULL
                                        OR cpm.ProductGroupName <> @ZeroDown
                                    )
                                )
                            ) THEN
                                'BMP'
                            WHEN
                            (
                                (
                                    trac.TRACTypeID IS NULL
                                    OR trac.TRACTypeID IN ( 3 )
                                )
                                AND
                                (
                                    CLPD.FinalTitlePolicyOutstandingDocumentReceived IS NULL
                                    OR CAST(CLPD.FinalTitlePolicyOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                )
                                AND
                                (
                                    CAST(CLPD.RecordedMortgageOutstandingDocumentReceived AS DATE) <> '1800-01-01'
                                    OR CLPD.RecordedMortgageOutstandingDocumentReceived IS NOT NULL
                                )
                                AND LM.secondRecordedDate = 0
                                AND
                                (
                                    cpm.ProductGroupName IS NOT NULL
                                    AND cpm.ProductGroupName LIKE @ZeroDown
                                )
                            ) THEN
                                '2MP'
                            WHEN
                            (
                                (
                                    trac.TRACTypeID IS NULL
                                    OR trac.TRACTypeID IN ( 3 )
                                )
                                AND
                                (
                                    CLPD.FinalTitlePolicyOutstandingDocumentReceived IS NULL
                                    OR CAST(CLPD.FinalTitlePolicyOutstandingDocumentReceived AS DATE) = '1800-01-01'
                                )
                                AND
                                (
                                    CAST(CLPD.RecordedMortgageOutstandingDocumentReceived AS DATE) <> '1800-01-01'
                                    OR CLPD.RecordedMortgageOutstandingDocumentReceived IS NOT NULL
                                )
                                AND
                                (
                                    (
                                        LM.secondRecordedDate = 1
                                        AND cpm.ProductGroupName IS NOT NULL
                                        AND cpm.ProductGroupName LIKE @ZeroDown
                                    )
                                    OR
                                    (
                                        cpm.ProductGroupName IS NULL
                                        OR cpm.ProductGroupName <> @ZeroDown
                                    )
                                )
                            ) THEN
                                'PCS'
                            ELSE
                                'NAN'
                        END
        FROM #FilterData LM
            INNER JOIN dbo.custom_productmain cpm WITH (NOLOCK)
                ON cpm.productId = LM.productid
            LEFT OUTER JOIN [dbo].custom_LoanPostClosingData AS CLPD WITH (NOLOCK)
                ON CLPD.lenderdatabaseid = LM.lenderdatabaseid
                   AND CLPD.loanrecordid = LM.loanrecordid
            LEFT JOIN dbo.USFS_TRACLoan trac WITH (NOLOCK)
                ON trac.LoanRecordID = LM.loanrecordid
                   AND trac.LenderDatabaseID = LM.lenderdatabaseid;

        SELECT *
        FROM #FilterData;

        DELETE FROM #FilterData
        WHERE DocType = 'NAN';

        INSERT INTO [dbo].[USFS_PostClosingMissingFinalDocs]
        (
            [lenderdatabaseid],
            [loanrecordid],
            [loanid],
            [actualclosingdate],
            [lastname],
            [firstname],
            [addressline1],
            [addressline2],
            [city],
            [county],
            [state],
            [zipcode],
            [senderEmail],
            [CommitmentNumber],
            [DocType],
            [IsProcessingIssue],
            [IsBeingProcessed]
        )
        SELECT LM.lenderdatabaseid,
               LM.loanrecordid,
               LM.loanid,
               LM.actualclosingdate,
               CM.lastname,
               CM.firstname,
               LM.addressline1,
               LM.addressline2,
               LM.city,
               LM.county,
               LM.[state],
               LM.zipcode,
               CASE
                   WHEN trac.TRACTypeID = 2
                        AND trac.TRACTitleEntityID = 1 THEN
                       COALESCE(NULLIF(cac.ContactEmail, ''), NULLIF(WSC.titleEmail, ''), WSC.completedbyEmail, '')
                   ELSE
                       COALESCE(NULLIF(WSC.titleEmail, ''), WSC.completedbyEmail, '')
               END AS SenderEmail,
               LM.CommitmentNumber,
               LM.DocType,
               'N',
               'N'
        FROM #FilterData LM
            INNER JOIN [dbo].customer_group CG WITH (NOLOCK)
                ON LM.lenderdatabaseid = CG.lenderdatabaseid
                   AND LM.customergroupid = CG.customergroupid
                   AND CG.primarycustomer = 'Y'
            INNER JOIN [dbo].customer_main CM WITH (NOLOCK)
                ON CM.lenderdatabaseid = CG.customerlenderdatabaseid
                   AND CG.customerrecordid = CM.customerrecordid
                   AND CM.typeid IN ( 0, 1, 2 ) -- Exclude non-borrowing individuals    
            INNER JOIN [dbo].custom_wholesaleclosing AS WSC WITH (NOLOCK)
                ON WSC.lenderdatabaseid = LM.lenderdatabaseid
                   AND WSC.loanrecordid = LM.loanrecordid
            LEFT JOIN dbo.USFS_TRACLoan trac WITH (NOLOCK)
                ON trac.LoanRecordID = LM.loanrecordid
                   AND trac.LenderDatabaseID = LM.lenderdatabaseid
            LEFT JOIN dbo.custom_Closing_AdditionalContact cac WITH (NOLOCK)
                ON cac.LoanRecordID = LM.loanrecordid
                   AND cac.LenderDatabaseID = LM.lenderdatabaseid;

        DROP TABLE IF EXISTS #FilterData;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRAN;

            DECLARE @ErrMsg NVARCHAR(4000),
                    @ErrSeverity INT;
            SELECT @ErrMsg = ERROR_MESSAGE(),
                   @ErrSeverity = ERROR_SEVERITY();

            RAISERROR(@ErrMsg, @ErrSeverity, 1);

        END;
    END CATCH;

END;
