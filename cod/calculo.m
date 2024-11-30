% se puede calcular y tener una función rápida de primos
% isprime se puede reemplazar por factores, solo que factores falla el 1
factores = @(x) isscalar(factor(x));
primos_f = find(arrayfun(factores, 1:100000));
primos_p = find(arrayfun(@isprime, 1:100000));


