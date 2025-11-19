-module(pg_alt).
-export([join/2, get_members/1, leave/2, create/0]).

%%% Cria a tabela ETS usada para armazenar grupos e seus membros.
%%% A tabela é pública e indexada pelo nome do grupo.
create() ->
    ets:new(table, [named_table, public, set]).

%%% Adiciona uma molécula (Pid) a um grupo (oxigênio ou hidrogênio).
%%% Se o grupo não existir, ele é criado.
join(Group, Pid) ->
    case ets:lookup(table, Group) of
        [] -> ets:insert(table, {Group, [Pid]});
        [{Group, List}] -> ets:insert(table, {Group, [Pid | List]})
    end.

%%% Retorna todas as moléculas em um grupo
get_members(Group) ->
    case ets:lookup(table, Group) of
        [] -> [];
        [{Group, List}] -> List
    end.

%%% Remove a molécula de um grupo.
leave(Group, Pid) ->
    case ets:lookup(table, Group) of
        [] -> ok;
        [{Group, List}] -> ets:insert(table, {Group, lists:delete(Pid, List)})
    end.
