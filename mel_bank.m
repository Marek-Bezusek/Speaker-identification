function B = mel_bank(fs, m, NFFT)

% B = mel_bank(fs, m, NFFT)
% 
% This function returns a bank of triangular filters evenly distributed on the mel scale
% 
% fs - sampling frequency
% m - number of filters in the bank
% NFFT - number of samples of the frequency characteristic (default: fs/2)
% B - filter matrix; each column corresponds to a frequency characteristic of one filter

if((nargin < 3) || isempty(NFFT))
    NFFT = fix(fs/2);
end

%% Calculation of center frequencies in mel scale
wdt = fix(hz2mel(fix(fs/2))/(m+1));
bm = ((1:m)*wdt).';

%% Conversion of center frequencies to hertz scale
b = mel2hz(bm);
b = fix([1; b; fs/2]);

%% Filter bank calculation
B = zeros(fix(fs/2),m); % Memory allocation
f = 1:fix(fs/2); % Frequency axis

for i = 1:size(B,2)
    B(b(i):b(i+1),i) = (f(b(i):b(i+1))-b(i))./(b(i+1)-b(i));
    B(b(i+1):b(i+2),i) = (f(b(i+1):b(i+2))-b(i+2))./(b(i+1)-b(i+2));
end

%% Changing the number of sample 
P = size(B,1)/gcd(size(B,1),NFFT);
Q = NFFT/gcd(size(B,1),NFFT);

B = resample(B,Q,P);