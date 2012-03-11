//
//  RepositoryController.h
//  MindMation
//
//  Created by Faisal Saeed on 12/2/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#define DATA_TYPE_STRING	@"1"
#define DATA_TYPE_INT		@"2"
#define DATA_TYPE_FLOAT		@"3"


@interface CSqliteController : NSObject 
{
	sqlite3 *m_pSqliteDatabase;
	NSString *m_pDatabaseName;
	NSString *m_pTableName;
	NSMutableArray *m_pTableColumns;
	NSMutableArray *m_pTableColumnTypes;
	NSMutableArray *m_pTableRows;
}

@property (nonatomic, retain) NSMutableArray *m_pTableColumns;
@property (nonatomic, retain) NSMutableArray *m_pTableRows;
@property (nonatomic, retain) NSMutableArray *m_pTableColumnTypes;
@property (nonatomic, retain) NSString *m_pTableName;
@property (nonatomic, retain) NSString *m_pDatabaseName;

- (BOOL) connectToDatabase:(NSString*) dbName;
- (BOOL) initTable:(NSString*) tableName;
- (void) addColumnToTable:(NSString*) columnName dateType:(NSString*) columnDataType;
- (NSMutableArray*) loadRecordsFromTable; // returns all records loaded
- (NSMutableArray*) loadRecordsFromTableOrderBy:(NSString*) orderingColumn orderType:(int) iSortingOrder condition:(NSString*)strCondition;
- (void) addRecordInTable:(NSMutableArray*) newRecord isAutoPrimaryKeyEnabled:(BOOL) bAutoPrimaryKey;
- (void) deleteAllRecords;
@end

#pragma mark Private Methods
@interface CSqliteController (private)

- (BOOL) createEditableCopyOrDatabaseIfNeeded;
- (void) loadRecords:(NSString*) selectQuery;
@end
