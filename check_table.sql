alter PROCEDURE [dbo].[CheckTableExistenceForList]
    @TableList NVARCHAR(MAX),
    @TableExists NVARCHAR(4000) OUTPUT,
    @TableNotExists NVARCHAR(4000) OUTPUT
AS
BEGIN
    DECLARE @TableName NVARCHAR(128)
    DECLARE @TempTableList TABLE (ID INT IDENTITY(1,1),TableName NVARCHAR(128))

    INSERT INTO @TempTableList (TableName)
    SELECT Item FROM STRING_SPLIT(@TableList, ',')

    DECLARE @i INT = 1, @c INT = (SELECT COUNT(*) FROM @TempTableList)

    SET @TableExists = ''
    SET @TableNotExists = ''

    WHILE @i <= @c
    BEGIN
        SELECT @TableName = TableName FROM @TempTableList WHERE ID = @i

        IF OBJECT_ID(@TableName) IS NOT NULL --IF OBJECT_ID('linh_ex', 'U')  bảng thật
            SET @TableExists = CONCAT(@TableExists, @TableName, ', ')
        ELSE
            SET @TableNotExists = CONCAT(@TableNotExists, @TableName, ', ')

        SET @i = @i + 1
    END

    IF LEN(@TableExists) > 0
        SET @TableExists = LEFT(@TableExists, LEN(@TableExists) - 1)
    
    IF LEN(@TableNotExists) > 0
        SET @TableNotExists = LEFT(@TableNotExists, LEN(@TableNotExists) - 1)
END
