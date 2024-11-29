factores = @(x) isscalar(factor(x));

% se puede calcular y tener una función rápida de primos
% isprime se puede reemplazar por factores, solo que factores falla el 1
primos = find(arrayfun(@isprime, 1:100000));

