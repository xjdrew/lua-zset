#include <stdlib.h>

#include "lua.h"
#include "lauxlib.h"
#include "skiplist.h"

static inline skiplist*
_to_skiplist(lua_State *L) {
    skiplist **sl = lua_touserdata(L, 1);
    if(sl==NULL) {
        luaL_error(L, "must be skiplist object");
    }
    return *sl;
}

static int
_insert(lua_State *L) {
    skiplist *sl = _to_skiplist(L);
    double score = luaL_checknumber(L, 2);
    luaL_checktype(L, 3, LUA_TSTRING);
    size_t len;
    const char* ptr = lua_tolstring(L, 3, &len);
    slobj *obj = slCreateObj(ptr, len);
    slInsert(sl, score, obj);
    return 0;
}

static int
_delete(lua_State *L) {
    skiplist *sl = _to_skiplist(L);
    double score = luaL_checknumber(L, 2);
    luaL_checktype(L, 3, LUA_TSTRING);
    slobj obj;
    obj.ptr = lua_tolstring(L, 3, &obj.length);
    lua_pushboolean(L, slDelete(sl, score, &obj));
    return 1;
}

static int
_get_count(lua_State *L) {
    skiplist *sl = _to_skiplist(L);
    lua_pushunsigned(L, sl->length);
    return 1;
}

static int
_get_rank(lua_State *L) {
    skiplist *sl = _to_skiplist(L);
    double score = luaL_checknumber(L, 2);
    luaL_checktype(L, 3, LUA_TSTRING);
    slobj obj;
    obj.ptr = lua_tolstring(L, 3, &obj.length);
    lua_pushunsigned(L, slGetRank(sl, score, &obj));
    return 1;
}

static int
_get_member_by_rank(lua_State *L) {
    skiplist *sl = _to_skiplist(L);
    unsigned long rank = luaL_checkunsigned(L, 2);
    skiplistNode* node = slGetNodeByRank(sl, rank);
    if(node == NULL || node->obj == NULL) {
        return 0;
    }

    lua_pushlstring(L, node->obj->ptr, node->obj->length);
    return 1;
}

static int
_get_rank_range(lua_State *L) {
    return 0;
}

static int
_get_score_range(lua_State *L) {
    return 0;
}

static int
_dump(lua_State *L) {
    skiplist *sl = _to_skiplist(L);
    slDump(sl);
    return 0;
}

static int
_new(lua_State *L) {
    skiplist *psl = slCreate();

    skiplist **sl = (skiplist**) lua_newuserdata(L, sizeof(skiplist*));
    *sl = psl;
    lua_pushvalue(L, lua_upvalueindex(1));
    lua_setmetatable(L, -2);
    return 1;
}

static int
_release(lua_State *L) {
    skiplist *sl = _to_skiplist(L);
    slFree(sl);
    return 0;
}

int luaopen_skiplist_c(lua_State *L) {
    luaL_checkversion(L);

    luaL_Reg l[] = {
        {"insert", _insert},
        {"delete", _delete},

        {"get_count", _get_count},
        {"get_rank", _get_rank},
        {"get_rank_range", _get_rank_range},
        {"get_score_range", _get_score_range},
        {"get_member_by_rank", _get_member_by_rank},

        {"dump", _dump},
    };

    lua_createtable(L, 0, 2);

    luaL_newlib(L, l);
    lua_setfield(L, -2, "__index");
    lua_pushcfunction(L, _release);
    lua_setfield(L, -2, "__gc");

    lua_pushcclosure(L, _new, 1);
    return 1;
}

