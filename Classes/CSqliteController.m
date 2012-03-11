//
//  RepositoryController.m
//  MindMation
//
//  Created by Faisal Saeed on 12/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "CSqliteController.h"

#define SELECT_ALL_QUERY	@"SELECT * FROM %@"
#define DELETE_ALL_QUERY	@"DELETE FROM %@"

@implementation CSqliteController

@synthesize m_pTableColumns;
@synthesize m_pTableRows;
@synthesize m_pTableColumnTypes;
@synthesize m_pTableName;
@synthesize m_pDatabaseName;

-(id) init
{
	if (self = [super init]) 
	{
		m_pDatabaseName = nil;
		m_pTableName = nil;
		m_pTableColumns = nil;
		m_pTableColumnTypes = nil;
		m_pTableRows = nil;
	}
	return self;
}

- (void)dealloc 
{
	if(m_pSqliteDatabase != nil)
	{
		sqlite3_close(m_pSqliteDatabase);
	}
	
	if(m_pTableRows != nil)
	{
		[m_pTableRows removeAllObjects];
		[m_pTableRows release];
		m_pTableRows = nil;
	}
	
	if(m_pTableColumnTypes != nil)
	{
		[m_pTableColumnTypes removeAllObjects];
		[m_pTableColumnTypes release];
		m_pTableColumnTypes = nil;
	}
	
	if(m_pTableColumns != nil)
	{
		[m_pTableColumns removeAllObjects];
		[m_pTableColumns release];
		m_pTableColumns = nil;
	}
	
	if(m_pTableName)
	{
		[m_pTableName release];
		m_pTableName = nil;
	}
	
	if(m_pDatabaseName)
	{
		[m_pDatabaseName release];
		m_pDatabaseName = nil;
	}
	
	[super dealloc];
}


-(BOOL) connectToDatabase:(NSString *) dbName
{
	if(m_pDatabaseName == nil)
		m_pDatabaseName = [[NSString alloc] initWithString:dbName];

	BOOL status =  [self createEditableCopyOrDatabaseIfNeeded];
	if(status == TRUE)
	{
		// The database is stored in the application bundle. 
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:m_pDatabaseName];
		// Open the database. The database was prepared outside the application.
		if (sqlite3_open([path UTF8String], &m_pSqliteDatabase) != SQLITE_OK) 
		{
			// Even though the open failed, call close to properly clean up resources.
			sqlite3_close(m_pSqliteDatabase);
			NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(m_pSqliteDatabase));
			// Additional error handling, as appropriate...
			status = FALSE;
			[m_pDatabaseName release];
			m_pDatabaseName = nil;
		}
	}
	
	return status;
}

// Creates a writable copy of the bundled default database in the application Documents directory.
- (BOOL)createEditableCopyOrDatabaseIfNeeded 
{
    // First, test for existence.
	//[dbController createEditableCopyOrDatabaseIfNeeded];
	
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:m_pDatabaseName];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return TRUE;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:m_pDatabaseName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) 
	{
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
	return success;
}

- (BOOL) initTable:(NSString*) tableName
{
	if(m_pTableName == nil)
	{
		m_pTableName = [[NSString alloc] initWithString:tableName];
		m_pTableColumns = [[NSMutableArray alloc] init];
		m_pTableColumnTypes = [[NSMutableArray alloc] init];
		m_pTableRows = [[NSMutableArray alloc] init];
		return TRUE;
	}
	return FALSE;
}

- (void) addColumnToTable:(NSString*) columnName dateType:(NSString*) columnDataType
{
	if(columnName == nil || columnDataType == nil)
		return;
	[m_pTableColumns addObject:columnName];
	[m_pTableColumnTypes addObject:columnDataType];
}

- (void) loadRecords:(NSString*) selectQuery
{	
    const char *sql = [selectQuery UTF8String];
    sqlite3_stmt *statement;
	
	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
    // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
    if (sqlite3_prepare_v2(m_pSqliteDatabase, sql, -1, &statement, NULL) == SQLITE_OK) 
	{
		if([m_pTableRows count] >0)
			[m_pTableRows removeAllObjects];
		
		// We "step" through the results - once for each row.
		int hResult = sqlite3_step(statement);
        while (hResult == SQLITE_ROW) 
		{
			NSMutableArray *pRecord = [[NSMutableArray alloc] init];
			NSString *strContent = @"";
			
			for(int i=0; i<[m_pTableColumns count]; i++)
			{
				NSString *strColumn = [m_pTableColumnTypes objectAtIndex:i];
				if([strColumn compare:DATA_TYPE_STRING] == 0) 
				{
					char *str = (char*)sqlite3_column_text(statement, i);
					if(str == nil)
						strContent = [NSString stringWithFormat:@""];
					else
						strContent = [NSString stringWithUTF8String:str];
					[pRecord addObject:strContent];
				}
				else if([strColumn compare:DATA_TYPE_INT] == 0)
				{
					strContent = [NSString stringWithFormat:@"%d",sqlite3_column_int(statement, i)];
					[pRecord addObject:strContent];
				}
				// more datatype checks can be added here !!! 
			}
			
            [m_pTableRows addObject:pRecord];
			[pRecord release];
			hResult = sqlite3_step(statement);
		}
	}
    // "Finalize" the statement - releases the resources associated with the statement.
    sqlite3_finalize(statement);
}

- (NSMutableArray*) loadRecordsFromTableOrderBy:(NSString*) orderingColumn orderType:(int) iSortingOrder condition:(NSString*)strCondition
{
	NSString *queryString = @"";
	
	if(iSortingOrder == 0) // ascending order
	{
		queryString = [NSString stringWithFormat:@"%@ %@ order by %@ ASC",
					   [NSString stringWithFormat:SELECT_ALL_QUERY,m_pTableName], strCondition, orderingColumn];
	}
	else if (iSortingOrder == 1) // descending order
	{
		queryString = [NSString stringWithFormat:@"%@ %@ order by %@ DESC",
					   [NSString stringWithFormat:SELECT_ALL_QUERY,m_pTableName], strCondition, orderingColumn];	
	}
	
	[self loadRecords:queryString];
	return m_pTableRows;
}

- (NSMutableArray*) loadRecordsFromTable // returns all records loaded
{
	[self loadRecords:[NSString stringWithFormat:SELECT_ALL_QUERY, m_pTableName]];
	return m_pTableRows;
}

- (void) addRecordInTable:(NSMutableArray*) newRecord isAutoPrimaryKeyEnabled:(BOOL) bAutoPrimaryKey
{
	NSString *queryString = [NSString stringWithFormat:@"INSERT INTO %@ ",m_pTableName];
	NSString *queryString2 = @" VALUES ";
	
	int startingIdx = 0;
	if(bAutoPrimaryKey)
		startingIdx = 1;

	for(int i=startingIdx; i<[m_pTableColumns count]; i++)
	{
		if(i==startingIdx)
		{
			queryString = [queryString stringByAppendingFormat:@"("];
			queryString2 = [queryString2 stringByAppendingFormat:@"("];
		}

		queryString = [queryString stringByAppendingFormat:@"%@",[m_pTableColumns objectAtIndex:i]];
		queryString2 = [queryString2 stringByAppendingFormat:@"?"];
	
		
		if(i<([m_pTableColumns count] - 1))
		{
			queryString = [queryString stringByAppendingFormat:@","];
			queryString2 =[queryString2 stringByAppendingFormat:@","];
		}
		else
		{
			queryString = [queryString stringByAppendingFormat:@")"];
			queryString2 = [queryString2 stringByAppendingFormat:@")"];
		}
	}
			
	queryString = [queryString stringByAppendingString:queryString2];
	
	const char *add_sql	= [queryString UTF8String];

	sqlite3_stmt *insert_statement;

	if (sqlite3_prepare_v2(m_pSqliteDatabase, add_sql, -1, &insert_statement, NULL) != SQLITE_OK) 
	{
		//NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(m_pSqliteDatabase));
		NSLog(@"%s",sqlite3_errmsg(m_pSqliteDatabase));
	}
	
	for(int i = startingIdx; i<[m_pTableColumns count]; i++)
	{
		NSString *columnType = [m_pTableColumnTypes objectAtIndex:i];
		if([columnType compare:DATA_TYPE_INT] == 0)
		{
			sqlite3_bind_int(insert_statement, i, [[newRecord objectAtIndex:i] intValue]);
		}
		else if([columnType	compare:DATA_TYPE_STRING] == 0)
		{
			sqlite3_bind_text(insert_statement, i, [[newRecord objectAtIndex:i] UTF8String], -1,SQLITE_TRANSIENT);
		}
	}
	
	int success = sqlite3_step(insert_statement);
	
	if (success != SQLITE_DONE) 
	{
		NSAssert1(0, @"Error: failed to save priority with message '%s'.", sqlite3_errmsg(m_pSqliteDatabase));
	}
	
	sqlite3_reset(insert_statement);
	
}

- (void) deleteAllRecords
{
	if(self.m_pTableRows == nil || [self.m_pTableRows count] == 0)
		return;
	
    const char *sql = [[NSString stringWithFormat:DELETE_ALL_QUERY,m_pTableName] UTF8String];
    sqlite3_stmt *statement;
	
	// Preparing a statement compiles the SQL query into a byte-code program in the SQLite library.
    // The third parameter is either the length of the SQL string or -1 to read up to the first null terminator.        
    if (sqlite3_prepare_v2(m_pSqliteDatabase, sql, -1, &statement, NULL) == SQLITE_OK) 
	{
		if([m_pTableRows count] >0)
			[m_pTableRows removeAllObjects];
		
		// We "step" through the results - once for each row.
		sqlite3_step(statement);
	}
    // "Finalize" the statement - releases the resources associated with the statement.
    sqlite3_finalize(statement);
	
}
@end
