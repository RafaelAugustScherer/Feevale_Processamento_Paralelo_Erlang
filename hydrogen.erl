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
        CreatorPID ! {molecules_combined, [self(), H, O]},
        io:format(
            "--------------------------------------------------
            ~nMerged H20 successfully with: H(#~p, #~p), O(#~p)
           ~n--------------------------------------------------~n",
            [self(), H, O]
        ),
        H ! {combined},
        O ! {combined},
        exit(normal)
    catch
        _:_ ->
            pg_alt:join(hydrogens, self())
    end.


