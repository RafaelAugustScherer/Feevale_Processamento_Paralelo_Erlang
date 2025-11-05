-module(pg_alt).
-export([join/2, get_members/1, leave/2, create/0]).

create() ->
    ets:new(table, [named_table, public, set]).

join(Group, Pid) ->
    case ets:lookup(table, Group) of
        [] -> ets:insert(table, {Group, [Pid]});
        [{Group, List}] -> ets:insert(table, {Group, [Pid | List]})
    end.

get_members(Group) ->
    case ets:lookup(table, Group) of
        [] -> [];
        [{Group, List}] -> List
    end.

leave(Group, Pid) ->
    case ets:lookup(table, Group) of
        [] -> ok;
        [{Group, List}] -> ets:insert(table, {Group, lists:delete(Pid, List)})
    end.
