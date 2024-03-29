USE [THIENVUONG_APP]
GO
/****** Object:  StoredProcedure [dbo].[SSELIB$App$Dynamic$Structure]    Script Date: 27/12/2023 9:51:50 SA ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SSELIB$App$Dynamic$Structure] @Query NVARCHAR(4000)
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @strSQL NVARCHAR(4000)
	SELECT @strSQL = 'select * into #$r from (' + @Query + ' where 1 = 0) a'
	SELECT @strSQL = @strSQL + ' declare @id int select @id = object_id(''tempdb..#$r'')'
	SELECT @strSQL = @strSQL + ' select a.name + '' '' + b.name + case when  b.name IN (''char'', ''nchar'', ''varchar'', ''nvarchar'') then ''('' + rtrim(ltrim(str(isnull(a.prec, 4000)))) + '')'''
	SELECT @strSQL = @strSQL + ' when b.name IN (''decimal'', ''numeric'') then ''('' + rtrim(ltrim(str(isnull(a.prec, 20)))) + '','' +  rtrim(ltrim(str(a.scale))) + '')'' else '''' end as v'
	SELECT @strSQL = @strSQL + ' from tempdb.dbo.syscolumns a join systypes b on a.xtype = b.xtype where a.id = @id and b.name <>  ''sysname'' order by  a.colorder drop table #$r'
	EXEC sp_executesql @strSQL
	SET NOCOUNT OFF
END
