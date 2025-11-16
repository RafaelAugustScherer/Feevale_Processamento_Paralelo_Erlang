-module(oxygen).
-export([create_molecule/2]).

%%%Cria a molécula, roda sua ativação e a libera para tentar combinar com os hidrogênios
create_molecule(CreatorPID, ActivationTime) ->
    io:format("Created Oxygen molecule #~p~n", [self()]),
    receive
        after ActivationTime ->
      io:format("Oxygen molecule ~p activated after ~.2f seconds~n", [self(), ActivationTime/1000]),
            handle_activation(CreatorPID)
    end.

%%% Oxigênio tenta se combinar com os hidrogênios
%%% Se houver hidrogênios suficientes, forma H2O e notifica.
%%% Se não houver, registra-se no grupo de oxigênios e aguarda ser combinado posteriormente.
handle_activation(CreatorPID) ->
    try
         ActivatedHydrogens = pg_alt:get_members(hydrogens),
         H1 = lists:nth(1, ActivatedHydrogens),
         H2 = lists:nth(2, ActivatedHydrogens),

         pg_alt:leave(hydrogens, H1),
         pg_alt:leave(hydrogens, H2),

         CreatorPID ! {molecules_combined, [H1, H2, self()]},
         io:format("~n ----------------------------------------------------
        ~nFrom Oxygen #~p: I have been combined, stopping to exist
        ~n ----------------------------------------------------~n", [self()]),
         H1 ! {combined},
         H2 ! {combined},
         exit(normal)
    catch
         _:_ ->
           pg_alt:join(oxygens, self()),
           watch_combined_event()
     end.

%%% Aguarda uma mensagem indicando que este oxigênio foi combinado. Ao receber, imprime e encerra.
watch_combined_event() ->
    receive{combined} ->
      io:format("~n ----------------------------------------------
        ~nFrom Oxygen #~p: I have been combined, stopping to exist
        ~n ----------------------------------------------------~n", [self()]),
        exit(normal)
    end.
