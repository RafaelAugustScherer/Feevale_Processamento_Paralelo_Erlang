-module(mysterious_element).
-export([start/0]).

%%% Inicia o sistema criando o gerador de moléculas.
start() ->
    pg_alt:create(),
    molecule_generator().

%%% Metodo que gera as moléculas, criando de forma aleatória ou o hidrogênio ou o oxigênio.
molecule_generator() ->
    spawn(
        generate_molecule_module_name(),
        create_molecule,
        [generate_molecule_activation_time()]
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
    10000 + rand:uniform(30000 - 10000).

%%% Escolhe aleatoriamente (se número aleatório for maior ou igual a 5, será oxigênio, senão será hidrogênio)
%%% se a molécula criada será hidrogênio ou oxigênio.
generate_molecule_module_name() ->
    R = rand:uniform(),
    if
        R >= 0.5 -> oxygen;
        R < 0.5  -> hydrogen
    end.
