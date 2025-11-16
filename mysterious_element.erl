-module(mysterious_element).
-export([create_mysterious_element/0]).

%%% Inicia o sistema criando o gerador de moléculas.
create_mysterious_element() ->
    pg_alt:create(),
    spawn(fun() -> molecule_generator() end),
    watch_combine_event().

%%% Gerador de moléculas continuas, chama as funções que definem as carasterísticas de cada molécula.
molecule_generator() ->
    spawn(
        generate_molecule_module_name(),
        create_molecule,
        [self(), generate_molecule_activation_time()]
    ),
    receive
        after generate_molecule_spawn_time() ->
            molecule_generator()
    end.

%%% Tempo aleatório para gerar a próxima molécula.
generate_molecule_spawn_time() ->
    500 + rand:uniform(5000 - 500 + 1) - 1.

%%% Tempo aleatório para ativação da molécula criada.
generate_molecule_activation_time() ->
    10000 + rand:uniform(30000 - 10000 + 1) - 1.

%%% Escolhe aleatoriamente (se número aleatório for maior ou igual a 5, será oxigênio, senão será hidrogênio)
%%% se a molécula criada será hidrogênio ou oxigênio.
generate_molecule_module_name() ->
    R = rand:uniform(),
    if
        R >= 0.5 -> oxygen;
        R < 0.5  -> hydrogen
    end.
