% Requisitos: tener un interprete de python. 
% Ejecutar pyversion("") con el folder de python
% Descargar mpmath para python e importarlo en matlab
mpmath = py.importlib.import_module('mpmath');
mpmath.mp.dps = 15;
n = 10; 
zeros = arrayfun(@(k) mpmath.zetazero(int32(k)), 1:n, UniformOutput=0);
zeros = cellfun(@(z) double(py.float(z.imag).real), zeros, UniformOutput=0)';
