USE [MPVTT200_TEST_APP]
GO

/****** Object:  StoredProcedure [dbo].[CheckTableExistenceForList]    Script Date: 23/02/2024 4:51:08 CH ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CheckTableExistenceForList]
    @TableList NVARCHAR(MAX),
	@TableExists NVARCHAR(4000) OUTPUT,
	@TableNotExists NVARCHAR(4000) OUTPUT
AS
BEGIN
    CREATE TABLE #TempTableList (ID INT IDENTITY(1,1),TableName NVARCHAR(128))

    INSERT INTO #TempTableList (TableName)
    SELECT value FROM STRING_SPLIT(@TableList, ',')

    DECLARE @i int, @c int, @TableName NVARCHAR(128)
	select @TableExists ='', @TableNotExists =''

	SELECT @i=1,@c=COUNT(1) from #TempTableList
	while @i<=@c begin
		
		SELECT @TableName=TableName from #TempTableList where ID=@i
		IF OBJECT_ID('tempdb..'+@TableName) IS NOT NULL
        BEGIN
			SELECT @TableExists = @TableExists + @TableName+', ';
        END
        ELSE
        BEGIN
            SELECT @TableNotExists = @TableNotExists + @TableName+', ';
        END

		SELECT @i=@i+1
	end
	IF @TableExists    !='' SET @TableExists = LEFT(@TableExists, LEN(@TableExists) - 1)
    IF @TableNotExists !='' SET @TableNotExists = LEFT(@TableNotExists, LEN(@TableNotExists) - 1)

END
GO


