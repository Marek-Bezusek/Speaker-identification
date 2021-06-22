close all;
clear all;
clc;
%% Dataset variables
num_speakers = 15; % total number of speakers in dataset
num_recordings = 5; % number of recording per speaker

% Dataset split ratio train:test 
train = 3; 
test = 2; 

%% Variables for segmentation and MFCC
fs = 16000;
winlen_ms = 32; % window length in ms (options: 16ms or 32ms due to FFT speed)
winlen = 2.^nextpow2(winlen_ms*(1e-3)*fs); % window length in samples (rounded to the nearest exponent due to FFT speed calc)
% true_winlen_ms = winlen/fs*1e3; %winlen in miliseconds after rounding
winover = winlen/2; 
NFFT = winlen;
winlen = hamming(winlen);
m = 25; % Number of filters in the mel bank (for MFCC)
r_p = 1:m; % MFCC coefficient reduction, coefficients

 %% Extract features from dataset: MFCC
    C = cell(num_recordings,num_speakers); % feature cell memory allocation
    for i = 1:num_speakers
        for j = 1:num_recordings
            
            % Load and preprocess data
            file_path =  ['speech_command_dataset\zero\sp' num2str(i) '_' num2str(j-1) '.wav'];
            [x,fs] = audioread(file_path);
            x = x./max(abs(x)); % signal normalization
            x = preemphasis(x,0.97);
            
            % Calculate MFCCs
            c = mfcc(x, fs, winlen, winover, m, NFFT); 
            C{j,i} = c(r_p,:); % feature reduction
        end
    end
    
    % Save exctracted features
    save data\features C
    
    % Split MFCC dataset, ratio train:test
    R = C(1:train,:); % reference matrix of fetures
    T = C(train+1:train+test,:); % test matrix of fetures

%%  Identification of a random speaker
spID = randi(num_speakers); % selection of a random speaker
recordingID = randi(test); % selection of a random recording
ID = identification(spID, recordingID, R, T, train, num_speakers);

fprintf('ID of the identified speaker: %d\n', ID);
fprintf('True speaker ID: %d\n', spID);

%% Cross validation of the model
k = 5; % k-fold
% Calculate the average identification accuracy for k-folds
[average_accuracy, accuracy, ID] = cross_validation(C,train,test,num_speakers, k);
fprintf('Average identification accuracy: %.2f %%\n', average_accuracy);

%% Plotting the results of cross validation
trueIDs = repmat(1:num_speakers,1,k*test); % vector of true IDs
identifiedIDs = reshape(ID', 1, []); % vector of identified IDs
cm = confusionchart(trueIDs,identifiedIDs,'title','Identification accuracy');
cm.ColumnSummary = 'column-normalized';
cm.RowSummary = 'row-normalized';

