from mpmath import zetazero, mp

mp.dps = 15

n = 10  
zeros = [zetazero(k) for k in range(1, n + 1)]
    
imaginary_parts = [zero.imag for zero in zeros]
