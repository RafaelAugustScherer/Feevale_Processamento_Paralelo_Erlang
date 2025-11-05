-module(mysterious_element).
-export([create_mysterious_element/0]).

create_mysterious_element() ->
    pg_alt:create(),
    spawn(fun() -> molecule_generator() end),
    watch_combine_event().

molecule_generator() ->
    spawn(
        generate_molecule_module_name(),
        create_molecule,
        [self(), generate_molecule_activation_time()]
    ),
    % io:format("Spawned process with PID: ~p~n", [Pid]),
    % io:format("Spawned time: ~p~n", [SpawnTime]),
    receive
        after generate_molecule_spawn_time() ->
            molecule_generator()
    end.

watch_combine_event() ->
    receive
        {molecules_combined, CombinedIds} when is_list(CombinedIds) ->
            case CombinedIds of
                [FirstHydrogen, SecondHydrogen, Oxygen] ->
                    io:format(
                        "Merged H20 successfully with: H(#~p, #~p), O(#~p)",
                        [FirstHydrogen, SecondHydrogen, Oxygen]
                    ),
                    watch_combine_event()
            end
    end.


generate_molecule_spawn_time() ->
    500 + rand:uniform(5000 - 500 + 1) - 1.

generate_molecule_activation_time() ->
    10000 + rand:uniform(30000 - 10000 + 1) - 1.

generate_molecule_module_name() ->
    R = rand:uniform(),
    if
        R >= 0.5 -> oxygen;
        R < 0.5  -> hydrogen
    end.
