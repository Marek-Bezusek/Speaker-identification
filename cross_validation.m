function [average_accuracy, accuracy, ID] = cross_validation(C,train,test,num_speakers, k)
%% Cross Validation
% This function performs speaker identification for all test recordings and
% then checks the correctness of this identification.
% If the parameter "k" is specified, the training and test datasets are rearranged
% and then validated k-times.
% 
% input: 
% C ...MFCC coefficient matrix for the whole dataset
% train ...number of records of the training dataset
% test ...number of records of the test dataset 
% num_speakers ...total number of speakers in the dataset 

% 
% output: 
% average_accuracy ...average identification accuracy in percentage [%]
% precision ...precision vector for k-th validation
% ID ... number of identified speaker
%%
if nargin<5
    k = 1;
end

  %% K-repetition validation
  accuracy = zeros(k,1);
  ID=[]; % matrix of identified speaker IDs for all test recordings
   
  for p = 1:k

    %% Rearrange the order of speeches in the dataset (move down a row k-times)
    C = circshift(C,1,1);
    % MFCC dataset split in ratio train:test 
    R = C(1:train,:);
    T = C(train+1:train+test,:);
    
    %% Calculation of min. distance and identification for all test recordings
    % Memory allocation
    dist = zeros(1,train); % distance vector
    dist_min = zeros(1,num_speakers);    % vector of minimum distances between the recordings of individual speakers
    dist_min2 = zeros(test,num_speakers); % matrix of minimum distances between speakers  
    val = zeros(test,num_speakers);   % validation matrix, correctness of  identification, true/false 
    ind = zeros(test,num_speakers);
    %%
    for n = 1:num_speakers 
        for t = 1:test
            %%%% distances for the nth speaker's test recording
            for i = 1:num_speakers
                for j = 1:train
                    dist(j) = DTW(T{t,n},R{j,i}); 
                end
                 dist_min(i) = min(dist); % finding the minima between the i-th speaker's recordings
            end
            %%%% speaker identification for the t-th test recording of the n-th speaker
             [dist_min2(t,n), ind(t,n)] = min(dist_min);  % finding the minimum

             
             

            %%%% result of identification
            % correctness of evaluation (1/0) for all test recordings
            if ind(t,n) == n
                val(t,n) = 1;   % correctly identified
            else
                val(t,n) = 0;   % incorrectly identified
            end
        end
    end
    ID = [ID;ind];
    % Calculation of accuracy for k-th validation 
    accuracy(p,1) = mean(val,'all')*100; % (number of correct identifications / number of test recordings)[%]
  end % END k-th validation 
  
    % Calculation of the average accuracy 
    average_accuracy = sum(accuracy)/k;

end %function END
