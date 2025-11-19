-module(oxygen).
-export([create_molecule/1]).

%%%Cria a molécula, roda sua ativação e a libera para tentar combinar com os hidrogênios
create_molecule(ActivationTime) ->
    io:format("Created Oxygen molecule #~p~n", [self()]),
    receive
        after ActivationTime ->
      io:format("Oxygen molecule ~p activated after ~.2f seconds~n", [self(), ActivationTime/1000]),
            handle_activation()
    end.

%%% Oxigênio tenta se combinar com os hidrogênios
%%% Se houver hidrogênios suficientes, forma H2O e notifica.
%%% Se não houver, registra-se no grupo de oxigênios e aguarda ser combinado posteriormente.
handle_activation() ->
    try
         ActivatedHydrogens = pg_alt:get_members(hydrogens),
         H1 = lists:nth(1, ActivatedHydrogens),
         H2 = lists:nth(2, ActivatedHydrogens),

         pg_alt:leave(hydrogens, H1),
         pg_alt:leave(hydrogens, H2),

         io:format(
           "--------------------------------------------------
           ~nMerged H20 successfully with: H(#~p, #~p), O(#~p)
           ~n--------------------------------------------------~n",
           [H1, H2, self()]
         )
    catch
         _:_ ->
           pg_alt:join(oxygens, self())
     end,
     exit(normal).

