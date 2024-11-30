% Requisitos: tener un interprete de python. 
% Ejecutar pyversion("C:\Users\Luis\anaconda3\python.exe") con el folder de python
% Descargar mpmath para python e importarlo en matlab
mpmath = py.importlib.import_module('mpmath');
mpmath.mp.dps = 15;
n = 10; 
zeros_rho = arrayfun(@(k) mpmath.zetazero(int32(k)), 1:n, UniformOutput=0);
zeros_rho = cellfun(@(z) double(py.float(z.imag).real), zeros_rho, UniformOutput=0)';
zeros_rho = cell2mat(zeros_rho);

function Rk = R0_function(x, N)
    % Parámetros:
    % x: Valor en el que se evalúa Rk
    % k: Número de pares de ceros de zeta considerados
    % N: Límite superior de la suma para n
    % zeros_rho: Vector con los primeros k ceros no triviales de zeta

    % Definir la función de Möbius
    mu = @(n) mobius(n);

    % Primer termino
    Rk = R_function(x, N);

    % Segundo término
    for n = 1:N
        integrand = @(t) 1 ./ ((t.^2 - 1) .* t .* log(t));
        integral_value = integral(integrand, x^(1/n), Inf, 'RelTol', 1e-6);
        Rk = Rk + (mu(n) / n) * (integral_value - log(2));
    end

end

% Función Möbius
function m = mobius(n)
    if n == 1
        m = 1;
        return;
    end

    factors = factor(n);
    unique_factors = unique(factors);

    % Si hay factores primos repetidos, μ(n) = 0
    if numel(factors) ~= numel(unique_factors)
        m = 0;
        return;
    end

    % Si es libre de cuadrados, μ(n) = (-1)^k donde k es el número de factores primos
    m = (-1)^numel(unique_factors);
end


%%
function R = R_function(X, N)
    % Parámetros:
    % X: Punto en el cual evaluar R(X)
    % N: Límite superior de la suma

    % Inicializar la suma
    R = 0;

    for n = 1:N
        % Calcular la función de Möbius para n
        mu_n = mobius(n);

        % Calcular li(X^(1/n))
        li_term = li_function(X^(1/n));

        % Sumar el término correspondiente
        R = R + (mu_n / n) * li_term;
    end
end

function li = li_function(y)
    % Aproximación de la función logarítmica integral
    % Usar la integración numérica para calcular li(y)
    if imag(y) == 0
        li = integral(@(t) 1 ./ log(t), 2, y, 'ArrayValued', true);
    else
        li = integral(@(t) 1 ./ log(t), 0, y, 'ArrayValued', true);
    end
end

function Ck = Ck_function(X, k, N, zeros_rho)
    % Parámetros:
    % X: Punto donde se evalúa la función
    % k: Índice del cero no trivial
    % zeros_rho: Vector con los valores imaginarios de los ceros no triviales
    % R_function: Handle a la función R(X)

    % Obtener el valor de gamma_k
    gamma_k = zeros_rho(k);

    % Calcular los términos de Ck
    term1 = R_function(X^(0.5 + 1i * gamma_k), N);
    term2 = R_function(X^(0.5 - 1i * gamma_k), N);

    % Calcular Ck
    Ck = real(- (term1 + term2));
end

function Rk = Rk_approximation(X, k, N, zeros_rho)
    % Calcula la aproximación Rk(X) usando los primeros k ceros de ζ(s)
    %
    % Parámetros:
    % X : Punto en el cual se evalúa Rk(X)
    % k : Número de ceros no triviales a considerar
    % N : Límite superior para la suma en la función R(X)

    % Inicializar Rk(X)
    Rk = R0_function(X, N);

    % Iterar para construir la aproximación Rk
    for j = 1:k
        % Actualizar Rk(X)
        Rk = Rk + Ck_function(X, k, N, zeros_rho);
    end
end


X = 10; % Punto de evaluación
k = 1; % Número de ceros no triviales
N = 100; % Límite superior de la suma

Rk_value = Rk_approximation(X, k, N, zeros_rho);


disp(['R_', num2str(k), '(', num2str(X), ') = ', num2str(Rk_value)]);
R0_function(X, N)