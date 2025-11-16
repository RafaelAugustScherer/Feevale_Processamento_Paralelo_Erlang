-module(hydrogen).
-export([create_molecule/2]).

%%%Cria a molécula, roda sua ativação e a libera para tentar combinar com as outras moléculas
create_molecule(CreatorPID, ActivationTime) ->
    io:format("Created Hydrogen molecule #~p~n", [self()]),
    receive
        after ActivationTime ->
            io:format("Hydrogen molecule ~p activated after ~.2f seconds~n", [self(), ActivationTime/1000]),
            handle_activation(CreatorPID)
    end.

%%% Hidrogênio tenta se combinar com os outros hidrogênios e o oxigênio
%%% Se houver moléculas o suficientes, forma H2O e notifica.
%%% Se não houver, registra-se no grupo de hidrogênios e aguarda ser combinado posteriormente.
handle_activation(CreatorPID) ->
    try
        H = lists:nth(1, pg_alt:get_members(hydrogens)),
        O = lists:nth(1, pg_alt:get_members(oxygens)),
        pg_alt:leave(hydrogens, H),
        pg_alt:leave(oxygens, O),
        CreatorPID ! {molecules_combined, [self(), H, O]}, %add comment of all 3 elements
        io:format("~n ----------------------------------------------
        ~nFrom Hydrogen #~p: I have been combined, stopping to exist
        ~n --------------------------------------------------------~n", [self()]),
        H ! {combined},
        O ! {combined},
        exit(normal)
    catch
        _:_ ->
            % io:format("Got to error~n Not enough elements for combination ~n"),
            pg_alt:join(hydrogens, self()),
            watch_combined_event()
    end.

%%% Aguarda uma mensagem indicando que este oxigênio foi combinado. Ao receber, imprime e encerra.
watch_combined_event() ->
    receive{combined} ->
        io:format("~n ----------------------------------------------
        ~nFrom Hydrogen #~p: I have been combined, stopping to exist
        ~n --------------------------------------------------------~n", [self()]),
        exit(normal)
    end.
