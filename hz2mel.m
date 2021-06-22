function fm = hz2mel(f)

% fm = hz2mel(f)
% 
% This function recalculates frequency in Hz to mels.
% 
% f     - frequency v Hz
% fm    - frequency in mel

%% Recalculation to mel scale
fm = 2595.*log10(1+f./700);