function c = mfcc(x, fs, winlen, winover, m, NFFT)

% c = mfcc(x, fs, winlen, winover, m, NFFT)
% 
% This function returns the MFCC Mel frequency cepstral coefficients for the input
% signal.
% 
% x - input signal in column vector
% fs - sampling frequency
% winlen - length of the window in the samples or the window itself
% winover - length of the overlap in the samples
% m - number of filters in the bank (default: 15)
% NFFT - number of samples of FFT (default: 4096)
% c - MFCC coefficient output matrix

%% Paths and variables
if((nargin < 5) || isempty(m))
    m = 15;
end
if((nargin < 6) || isempty(NFFT))
    NFFT = 4096;
end

%% Segmentation
X = segmentation(x, winlen, winover);

%% Module spectrum signal
XX = abs(fft(X,NFFT));
XX = XX(1:fix(end/2),:);

%% Filter bank calculation
B = mel_bank(fs, m, size(XX,1));

%% Multiplication and subsequent summation of elements
c = (B')*XX;

%% Natural logarithm and DCT
c = dct(log(c));

%% Substitution of the first coefficients by energy 
c(1,:) = log(sum(abs(X).^2));