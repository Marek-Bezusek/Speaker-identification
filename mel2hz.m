function f = mel2hz(fm)

% f = mel2hz(fm)
% 
% This function recalculates frequency in mels to Hz.
% 
% fm    - frequency in mel
% f     - frequency v Hz


%% Recalculation to hertz scale
f = 700.*(10.^(fm./2595)-1);