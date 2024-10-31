% funcion que devuelve 1 si es entero y 0 si no

entero = @(x) floor(cos(pi.*x)^2);

%% funciones para numeros primos

% fórmula del factorial. No sirve después del 13 por precisión de máquina
wilson = @(x) entero((factorial(x-1)+1)/x);

% revisa si tiene dos divisores. Funciona con 1
div2 = @(y) entero( ...
    (sum(arrayfun(@(x) entero(y/x), 1:y))/ 2)^(-pi));

% desplegando algunos números 
n = 1:100;
num1 = arrayfun(wilson, n)';
num2 = arrayfun(div2, n)';

%% función n -> x, tira el n-ésimo primo con funciones matemáticas
function primo = nprimo(x, coref)
     % cota de crecimiento
    itermax = floor(log2(x)*x + 2);
    % corre la función que indica la primalidad
    prev = arrayfun(@(x) coref(x), 1:itermax); 
    % verifica si un número es menor a un primo dado
    core = @(n) floor((x/(1 + sum(prev(1:n))))^(1/x));
    % suma todos los números y da el resultado
    primo = 1 + sum(arrayfun(@(x) core(x), 1:itermax));
end


numeros = arrayfun(@(x) nprimo(x, div2), 1:168)';
