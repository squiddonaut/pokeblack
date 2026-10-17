#ifndef BATTLE_RECORD_H
#define BATTLE_RECORD_H

#include "types.h"
#include "battle_common.h"
#include "heap.h"

#define BTLREC_BUFFER_SIZE 0xC00

#define BTLREC_READBUF_SIZE 0x40

#define BTLREC_TOOL_BUFFER_SIZE 0x3C

typedef enum {
    TAG_TYPE_NONE = 0,     
    TAG_TYPE_ENTRIES,
    TAG_TYPE_UNK_2,
    TAG_TYPE_UNK_3,
} TagType;

typedef enum {
    HEADER_CODE_0 = 0,
    HEADER_CODE_4 = 4,
} HeaderCode;

typedef struct _BattleRecord BattleRecord;

typedef struct {
    const u8 *recordData;
    u32 dataSize : 31;
    u32 readEnded : 1;
    u32 readPtr[BTL_CLIENT_MAX];
    u8 readBuf[BTL_CLIENT_MAX][BTLREC_READBUF_SIZE];
} BattleRecordReader;

typedef struct {
    u8 writePtr;
    u8 clientBits;
    u8 numClients;
    u8 type : 6;
    u8 tagFlag : 1;
    u8 error : 1;
    u8 buffer[BTLREC_TOOL_BUFFER_SIZE];
} BattleRecordBuilder;

static inline u8 PackHeaderTag(TagType type, u8 numClient, u8 tagFlag)
{
    return ((tagFlag & 1) << 7) | ((type & 0x07) << 4) | ((numClient) & 0x0f);
}

static inline void UnpackHeaderTag(u8 tagCode, TagType *type, u8 *numClient, u8 *tagFlag)
{
    *numClient = tagCode & 0x0f;
    *type = (TagType)((tagCode >> 4) & 0x07);
    *tagFlag = ((tagCode >> 7) & 0x01);
}

static inline u8 PackClientTag(u8 clientID, u8 numEntries)
{
    return (clientID << 5) | (numEntries);
}

static inline void UnpackClientTag(u8 tagCode, u8 *clientID, u8 *numEntries)
{
    *clientID = ((tagCode >> 5) & 0x07);
    *numEntries = (tagCode & 0x01f);
}

BattleRecord *BattleRecord_New(enum HeapID heapID);
void BattleRecord_Free(BattleRecord *rec);
void BattleRecord_Append(BattleRecord *rec, const void *data, u32 size);
HeaderCode FUN_overlay_d_93__021ee638(const void *data);
const void *BattleRecord_GetData(const BattleRecord *rec, u32 *size);

void BattleRecordReader_Init(BattleRecordReader *reader, const void *recordData, u32 dataSize);
void BattleRecordReader_Reset(BattleRecordReader *reader);
BOOL FUN_overlay_d_93__021ee688(BattleRecordReader *reader, u8 clientID);
const UNK_021D845C *FUN_overlay_d_93__021ee6b8(BattleRecordReader *reader, u8 clientID, u8 *numEntries, u8 *tagFlag);
u32 BattleRecordReader_GetCurrentChapterCount(const BattleRecordReader *reader);
BOOL BattleRecordReader_IsAtEnd(const BattleRecordReader *reader, u8 clientID);

// Building the payload that goes out to the clients.
void BattleRecordBuilder_Init(BattleRecordBuilder *builder, BOOL tagFlag);
void *FUN_overlay_d_93__021ee8d8(BattleRecordBuilder *builder, u32 *dataSize, BOOL tagFlag);
void BattleRecordBuilder_AddClientEntries(BattleRecordBuilder *builder, u8 clientID, const UNK_021D845C *entries, u8 numEntries);
void *BattleRecordBuilder_Finish(BattleRecordBuilder *builder, HeaderCode headerCode, u32 *dataSize);
void *FUN_overlay_d_93__021ee9a4(BattleRecordBuilder *builder, u32 *dataSize);
void BattleRecordBuilder_Load(BattleRecordBuilder *builder, const void *data, u32 dataSize);
BOOL BattleRecordBuilder_ReadNext(BattleRecordBuilder *builder, u32 *rp, u8 *clientID, u8 *numEntries, UNK_021D845C *entries);

#endif // BATTLE_RECORD_H
