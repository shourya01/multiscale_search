function K = entropy (P)

% Get entropy of P
% P can be a number or a vector
% P = 1 or 0 won't pose a problem

T = -P.*log2(P) - (1-P).*log2(1-P);
K = sum(T(~isnan(T)&~isinf(T)));

end