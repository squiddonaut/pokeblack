#include "types.h"
#include "battle_common.h"
#include "battle_record.h"
#include "heap.h"
#include "mi_memory.h"

#define BTLREC_SRC_FILE "btl_rec.c"
#define BTLREC_SRC_LINE 107

enum {
    HEADER_CODE = 0,
    HEADER_TAG,
    HEADER_SIZE,
};

struct _BattleRecord {
    u16 writePtr;
    u8 overflowed;
    u8 padding;
    u32 unk_04;
    u8 buf[BTLREC_BUFFER_SIZE];
};

BattleRecord *BattleRecord_New(enum HeapID heapID)
{
    BattleRecord *rec = Heap_AllocDebug(heapID, sizeof(BattleRecord), TRUE, BTLREC_SRC_FILE, BTLREC_SRC_LINE);
    return rec;
}

void BattleRecord_Free(BattleRecord *rec)
{
    Heap_Free(rec);
}

void BattleRecord_Append(BattleRecord *rec, const void *data, u32 size)
{
    if (rec->overflowed == FALSE) {
        const u8 *pData = (const u8 *)data;
        u32 endPtr;

        ++pData;
        --size;

        endPtr = rec->writePtr + size;
        if (endPtr <= sizeof(rec->buf)) {
            MI_CpuCopy8(pData, &rec->buf[rec->writePtr], size);
            rec->writePtr = endPtr;
        } else {
            rec->overflowed = TRUE;
        }
    }
}

HeaderCode FUN_overlay_d_93__021ee638(const void *data)
{
    const u8 *pByte = (const u8 *)data;
    return (HeaderCode)(*pByte);
}

const void *BattleRecord_GetData(const BattleRecord *rec, u32 *size)
{
    *size = rec->writePtr;
    return rec->buf;
}

void BattleRecordReader_Init(BattleRecordReader *reader, const void *recordData, u32 dataSize)
{
    u32 i;

    reader->recordData = recordData;
    reader->dataSize = dataSize;
    reader->readEnded = FALSE;

    for (i = 0; i < NELEMS(reader->readPtr); ++i) {
        reader->readPtr[i] = 0;
    }
}

void BattleRecordReader_Reset(BattleRecordReader *reader)
{
    u32 i;
    for (i = 0; i < NELEMS(reader->readPtr); ++i) {
        reader->readPtr[i] = 0;
    }
}

BOOL FUN_overlay_d_93__021ee688(BattleRecordReader *reader, u8 clientID)
{
    TagType type;
    u8 numClient, tagFlag;

    u32 *rp;

    rp = &reader->readPtr[clientID];
    UnpackHeaderTag(reader->recordData[(*rp)], &type, &numClient, &tagFlag);

    if (type == TAG_TYPE_UNK_2) {
        (*rp)++;
        return tagFlag;
    }
    return FALSE;
}

const UNK_021D845C *FUN_overlay_d_93__021ee6b8(BattleRecordReader *reader, u8 clientID, u8 *numEntries, u8 *tagFlag)
{
    TagType type;
    u8 numClient, readClientID, readNumEntries;
    u32 *rp;
    u32 i;

    if (reader->readEnded) {
        UNK_021D845C *entry = (UNK_021D845C *)(reader->readBuf[clientID]);
        FUN_overlay_d_93__021d8470(entry);
        *numEntries = 1;
        *tagFlag = FALSE;
        return entry;
    }

    rp = &reader->readPtr[clientID];

    while ((*rp) < reader->dataSize) {
        UnpackHeaderTag(reader->recordData[(*rp)], &type, &numClient, tagFlag);
        (*rp)++;

        if ((*rp) > reader->dataSize) {
            break;
        }
        if (type == TAG_TYPE_ENTRIES) {
            const UNK_021D845C *returnPtr = NULL;
            if (numClient == 0 || (numClient > BTL_CLIENT_MAX)) {
                break;
            }
            for (i = 0; i < numClient; ++i) {
                UnpackClientTag(reader->recordData[(*rp)++], &readClientID, &readNumEntries);

                if (((*rp) >= reader->dataSize)) { break; }
                if (readClientID != clientID) {
                    (*rp) += (sizeof(UNK_021D845C) * readNumEntries);
                } else {
                    returnPtr = (const UNK_021D845C *)(&reader->recordData[(*rp)]);
                    MI_CpuCopy8(returnPtr, reader->readBuf[clientID], readNumEntries * sizeof(UNK_021D845C));
                    returnPtr = (const UNK_021D845C *)(reader->readBuf[clientID]);
                    (*rp) += (sizeof(UNK_021D845C) * readNumEntries);
                    *numEntries = readNumEntries;
                }
            }
            if (returnPtr) {
                return returnPtr;
            }
        } else if (type == TAG_TYPE_UNK_3) {
            UNK_021D845C *entry = (UNK_021D845C *)(reader->readBuf[clientID]);

            FUN_overlay_d_93__021d845c(entry);
            *numEntries = 1;
            *tagFlag = FALSE;
            return entry;
        } else if (type == TAG_TYPE_UNK_2) {
            // header only: nothing to hand back, the flag bit already went out through tagFlag. Here so the tag does not fall into the break below
        } else {
            break;
        }
        if (((*rp) >= reader->dataSize)) { break; }
    }

    reader->readEnded = TRUE;
    {
        UNK_021D845C *entry = (UNK_021D845C *)(reader->readBuf[clientID]);
        FUN_overlay_d_93__021d8470(entry);
        *numEntries = 1;
        *tagFlag = FALSE;
        return entry;
    }
}

u32 BattleRecordReader_GetCurrentChapterCount(const BattleRecordReader *reader)
{
    u32 p = 0;
    u32 flagCount = 0;

    TagType type;
    u8 tagFlag, numClient, readClientID, readNumEntries;

    while (p < reader->dataSize) {
        UnpackHeaderTag(reader->recordData[p++], &type, &numClient, &tagFlag);
        if (tagFlag) {
            ++flagCount;
        }
        if ((p >= reader->dataSize)) { break; }
        if (type != TAG_TYPE_ENTRIES) {
            p += numClient;
        } else {
            u32 i;
            for (i = 0; i < numClient; ++i) {
                UnpackClientTag(reader->recordData[p++], &readClientID, &readNumEntries);
                p += (sizeof(UNK_021D845C) * readNumEntries);
                if ((p >= reader->dataSize)) { break; }
            }
        }
    }
    return flagCount;
}

BOOL BattleRecordReader_IsAtEnd(const BattleRecordReader *reader, u8 clientID)
{
    if (reader->readEnded == FALSE) {
        const u32 *rp = &reader->readPtr[clientID];
        return ((*rp) == reader->dataSize);
    }
    return TRUE;
}

void BattleRecordBuilder_Init(BattleRecordBuilder *builder, BOOL tagFlag)
{
    MI_CpuFill8(builder, 0, sizeof(BattleRecordBuilder));
    builder->tagFlag = tagFlag;
}

void *FUN_overlay_d_93__021ee8d8(BattleRecordBuilder *builder, u32 *dataSize, BOOL tagFlag)
{
    builder->buffer[HEADER_CODE] = HEADER_CODE_4;
    builder->buffer[HEADER_TAG] = PackHeaderTag(TAG_TYPE_UNK_2, 0, tagFlag);
    *dataSize = HEADER_SIZE;
    return builder->buffer;
}

void BattleRecordBuilder_AddClientEntries(BattleRecordBuilder *builder, u8 clientID, const UNK_021D845C *entries, u8 numEntries)
{

    if (builder->writePtr == 0) {
        builder->type = TAG_TYPE_ENTRIES;
        builder->writePtr = HEADER_SIZE;
    }

    if ((builder->clientBits & (1 << clientID)) == 0) {
        u32 endPtr = builder->writePtr + ((sizeof(UNK_021D845C) * numEntries) + 1);
        if (endPtr <= sizeof(builder->buffer)) {
            builder->clientBits |= (u8)(1 << clientID);
            builder->numClients++;

            builder->buffer[builder->writePtr] = PackClientTag(clientID, numEntries);
            MI_CpuCopy8(entries, &builder->buffer[builder->writePtr + 1], sizeof(UNK_021D845C) * numEntries);
            builder->writePtr = endPtr;
        } else {

            builder->error = 1;
        }
    }
}

void *BattleRecordBuilder_Finish(BattleRecordBuilder *builder, HeaderCode headerCode, u32 *dataSize)
{
    if (builder->error == 0) {
        builder->buffer[HEADER_CODE] = headerCode;
        builder->buffer[HEADER_TAG] = PackHeaderTag((TagType)builder->type, builder->numClients, builder->tagFlag);
        *dataSize = builder->writePtr;
        return builder->buffer;
    }
    return NULL;
}

void *FUN_overlay_d_93__021ee9a4(BattleRecordBuilder *builder, u32 *dataSize)
{
    builder->buffer[HEADER_CODE] = HEADER_CODE_0;
    builder->buffer[HEADER_TAG] = PackHeaderTag(TAG_TYPE_UNK_3, 0, FALSE);
    *dataSize = HEADER_SIZE;

    return builder->buffer;
}

#ifdef NONMATCHING
void BattleRecordBuilder_Load(BattleRecordBuilder *builder, const void *data, u32 dataSize)
{
    MI_CpuCopy8(data, builder->buffer, dataSize);
    builder->writePtr = dataSize;
    builder->clientBits = 0;
    builder->numClients = 0;
    builder->type = 0;
    builder->tagFlag = 0;
    builder->error = 0;
}
#else
// TODO mwcc problem -  the store of the flags byte at +3 into the next bitfield write, so the C above assembles two ldrb r1, [r4, #3] reloads short of the ROM. supplying assembly for now

GLOBAL_ASM("asm/nonmatchings/battle_record_restorestart.s")
#endif

BOOL BattleRecordBuilder_ReadNext(BattleRecordBuilder *builder, u32 *rp, u8 *clientID, u8 *numEntries, UNK_021D845C *entries)
{
    if ((*rp) == 0) {
        (*rp) = HEADER_SIZE;
    }

    if ((*rp) < builder->writePtr) {
        u32 dataSize;

        UnpackClientTag(builder->buffer[(*rp)], clientID, numEntries);

        // volatile forces the ldrb at 0x021EEA0E. without, mwcc reuses the value the inlined UnpackClientTag just stored, drops the load, and shifts everything after it. Do not remove
        dataSize = sizeof(UNK_021D845C) * (*(volatile u8 *)numEntries);
        ++(*rp);
        MI_CpuCopy8(&(builder->buffer[(*rp)]), entries, dataSize);
        (*rp) += dataSize;

        return TRUE;
    }

    return FALSE;
}
