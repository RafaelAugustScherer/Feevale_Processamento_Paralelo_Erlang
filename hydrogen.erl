-module(hydrogen).
-export([create_molecule/2]).

create_molecule(CreatorPID, ActivationTime) ->
    io:format("Created Hydrogen molecule #~p~n", [self()]),
    receive
        after ActivationTime ->
            handle_activation(CreatorPID)
    end.


handle_activation(CreatorPID) ->
    io:format("Got to printing1~n"),
    try
        H = lists:nth(1, pg_alt:get_members(hydrogens)),
        O = lists:nth(1, pg_alt:get_members(oxygens)),
        pg_alt:leave(hydrogens, H),
        pg_alt:leave(oxygens, O),
        CreatorPID ! {molecules_combined, [self(), H, O]},
        H ! {combined},
        O ! {combined},
        exit(normal)
    catch
        _:_ ->
            io:format("Got to error~n"),
            pg_alt:join(hydrogens, self()),
            io:format("Is going to watch combined event~n"),
            watch_combined_event()
    end.

watch_combined_event() ->
    receive{combined} ->
        io:format("From Hydrogen #~p: I have been combined, stopping to exist", [self()]),
        exit(normal)
    end.
