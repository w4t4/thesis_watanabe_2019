function [a,b] = wSolve(m,t)

syms a;
eqn = exp(m*t/a) - a/m == 0;
sola = vpasolve(eqn, a);
a = double(sola);
b = a/m - t;

end