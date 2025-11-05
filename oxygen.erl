-module(oxygen).
-export([create_molecule/2]).

create_molecule(CreatorPID, ActivationTime) ->
    io:format("Created Oxygen molecule #~p~n", [self()]),
    receive
        after ActivationTime ->
            handle_activation(CreatorPID)
    end.


handle_activation(CreatorPID) ->
    pg_alt:join(oxygens, self()),
    watch_combined_event().
    % try
    %     ActivatedHydrogens = pg:get_members(activated_hydrogens),
    %     H1 = lists:nth(1, ActivatedHydrogens),
    %     H2 = lists:nth(2, ActivatedHydrogens),

    %     pg:leave(activated_hydrogens, H1),
    %     pg:leave(activated_hydrogens, H2),

    %     CreatorPID ! {molecules_combined, [H1, H2, self()]},
    %     H1 ! {combined},
    %     H2 ! {combined},
    %     exit(normal)
    % catch
    %     _:_ ->
    %         pg:join(activated_oxygens, self()),
    %         watch_combined_event()
    % end.

watch_combined_event() ->
    receive{combined} ->
        io:format("From Oxygen #~p: I have been combined, stopping to exist", [self()]),
        exit(normal)
    end.
