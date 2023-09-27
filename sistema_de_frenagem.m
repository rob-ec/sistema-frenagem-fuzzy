% Sistema de frenagem com lógica Fuzzy
%
% @author Robson Mesquita Gomes <robson.mesquita56@gmail.com>
%
% MATLAB R2023b

function main()
    
    desenho_carro = "   _____\n  /|_||_\\`.__\n (   _    _ _\\\n=.-'|_|--|_|-'";

    % Apresentação
    fprintf("\n\n-- Sistema de Frenagem com Lógica Fuzzy --\n\n");
    fprintf(desenho_carro + "\n\n");

    % Entrada de dados
    pedal   = input("\nQual o valor da pressão no pedal? (de 0 a 100) \n= ");
    roda    = input("\nQual o valor da velocidade da roda? (de 0 a 100) \n= ");
    carro   = input("\nQual o valor da velocidade do carro? (de 0 a 100) \n= ");
    
    % Pertinências
    [pressao_high,  pressao_med,    pressao_low ]    = pertinencia_pedal(pedal);
    [roda_fast,     roda_med,       roda_low    ]    = pertinencia_roda(roda);
    [carro_fast,    carro_med,      carro_low   ]    = pertinencia_carro(carro);
    
    % Regras fuzzy

    % SE (pressão média), 
    % ENTÃO aplicar o freio
    aperte_1 = pressao_med;
    
    % SE (pressão alta 
    % E velocidade do carro for alta 
    % E velocidade das rodas for alta), 
    % ENTÃO aplicar o freio
    aperte_2 = min([pressao_high, roda_fast, carro_fast]); % O AND é definido como o mínimo
    
    % SE (pressão alta 
    % E velocidade do carro for alta 
    % E a velocidade das rodas for baixa), 
    % ENTÃO liberar o freio
    libera_1 = min([pressao_high, roda_low, carro_fast]); % O AND é definido como o mínimo
    
    % SE (pressão no pedal for baixa), 
    % ENTÃO liberar o freio
    libera_2 = pressao_low;
    
    % Intervalo
    intervalo = 0:1:100;
    
    % Pertinências liberação
    aperte = aperte_1 + aperte_2;
    libere = libera_1 + libera_2;
    
    % Pressão no freio
    freio = calcular_pressao_freio(intervalo, aperte, libere);
    
    % Pressão a ser aplicada no freio (centroid)
    frenagem = sum(freio .* intervalo) / sum(freio);
    
    % Saída
    fprintf('\nA pressão aplicada no freio é: %.2f;\n\n\n', frenagem);

end

% Calcula pertinência da pressão no pedal
function [pressao_pedal_high, pressao_pedal_med, pressao_pedal_low] = pertinencia_pedal(ref_pedal)

    if (ref_pedal > 0 && ref_pedal <= 30)
        pressao_pedal_low   = 1 - 0.02 * ref_pedal;
        pressao_pedal_med   = 0;
        pressao_pedal_high  = 0;

    elseif (ref_pedal > 30 && ref_pedal <= 50)
        pressao_pedal_low   = 1 - 0.02 * ref_pedal;
        pressao_pedal_med   = 0.05 * ref_pedal - 1.5;
        pressao_pedal_high  = 0;

    elseif (ref_pedal > 50 && ref_pedal <= 70)
        pressao_pedal_low   = 0;
        pressao_pedal_med   = 3.5 - 0.05 * ref_pedal;
        pressao_pedal_high  = 0.02 * ref_pedal - 1;

    elseif (ref_pedal > 70 && ref_pedal <= 100)
        pressao_pedal_low   = 0;
        pressao_pedal_med   = 0;
        pressao_pedal_high  = 0.02 * ref_pedal - 1;
    end

end

% Calcula pertinência da velocidade da roda
function [velocidade_roda_fast, velocidade_roda_med, velocidade_roda_slow] = pertinencia_roda(ref_roda)

    if (ref_roda > 0 && ref_roda <= 20)
        velocidade_roda_slow    = 1 - (1 / 60) * ref_roda;
        velocidade_roda_med     = 0;
        velocidade_roda_fast    = 0;

    elseif (ref_roda > 20 && ref_roda <= 40)
        velocidade_roda_slow    = 1 - (1 / 60) * ref_roda;
        velocidade_roda_med     = (1 / 30) * (ref_roda - 20);
        velocidade_roda_fast    = 0;

    elseif (ref_roda > 40 && ref_roda <= 50)
        velocidade_roda_slow    = 1 - (1 / 60) * ref_roda;
        velocidade_roda_med     = (1 / 30) * (ref_roda - 20);
        velocidade_roda_fast    = (1 / 60) * (ref_roda - 40);

    elseif (ref_roda > 50 && ref_roda <= 60)
        velocidade_roda_slow    = 1 - (1 / 60) * ref_roda;
        velocidade_roda_med     = (1 / 30) * (80 - ref_roda);
        velocidade_roda_fast    = (1 / 60) * (ref_roda - 40);

    elseif (ref_roda > 60 && ref_roda <= 80)
        velocidade_roda_slow    = 0;
        velocidade_roda_med     = (1 / 30) * (80 - ref_roda);
        velocidade_roda_fast    = (1 / 60) * (ref_roda - 40);

    elseif (ref_roda > 80 && ref_roda <= 100)
        velocidade_roda_slow    = 0;
        velocidade_roda_med     = 0;
        velocidade_roda_fast    = (1 / 60) * (ref_roda - 40);
    end

end

% Calcula pertinência da velocidade do carro
function [velocidade_carro_fast, velocidade_carro_med, velocidade_carro_slow] = pertinencia_carro(ref_carro)

    if (ref_carro > 0 && ref_carro <= 20)
        velocidade_carro_slow   = 1 - (1 / 60) * ref_carro;
        velocidade_carro_med    = 0;
        velocidade_carro_fast   = 0;

    elseif (ref_carro > 20 && ref_carro <= 40)
        velocidade_carro_slow   = 1 - (1 / 60) * ref_carro;
        velocidade_carro_med    = (1 / 30) * (ref_carro - 20);
        velocidade_carro_fast   = 0;

    elseif (ref_carro > 40 && ref_carro <= 50)
        velocidade_carro_slow   = 1 - (1 / 60) * ref_carro;
        velocidade_carro_med    = (1 / 30) * (ref_carro - 20);
        velocidade_carro_fast   = (1 / 60) * (ref_carro - 40);

    elseif (ref_carro > 50 && ref_carro <= 60)
        velocidade_carro_slow   = 1 - (1 / 60) * ref_carro;
        velocidade_carro_med    = (1 / 30) * (80 - ref_carro);
        velocidade_carro_fast   = (1 / 60) * (ref_carro - 40);

    elseif (ref_carro > 60 && ref_carro <= 80)
        velocidade_carro_slow   = 0;
        velocidade_carro_med    = (1 / 30) * (80 - ref_carro);
        velocidade_carro_fast   = (1 / 60) * (ref_carro - 40);

    elseif (ref_carro > 80 && ref_carro <= 100)
        velocidade_carro_slow   = 0;
        velocidade_carro_med    = 0;
        velocidade_carro_fast   = (1 / 60) * (ref_carro - 40);
    end

end

% Retorna a pressão no freio
function freio = calcular_pressao_freio(intervalo, aperte_freio, libere_freio)

    freio   = zeros(1, length(intervalo));
    aperte     = 0.01 * intervalo;
    libere     = 1 - 0.01 * intervalo;

    for i = 1:length(intervalo)
        aperte(i)   = min([aperte(i), aperte_freio]);
        libere(i)   = min([libere(i), libere_freio]);
        freio(i)    = max([aperte(i), libere(i)]);
    end

end
