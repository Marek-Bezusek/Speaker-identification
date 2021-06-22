function [ID] = identification(spID,recordingID,R,T,train,num_speakers)
%% Speaker identification
% This function identifies a speaker from the test dataset.
% 
% input:
% spID ...Speaker ID of the test dataset
% recordingID ...test recording ID
% R ...training data feature matrix
% T ...test data feature matrix
% train ...number of recordings of training dataset 
% num_speakers ...total number of speakers in the dataset 
% 
% output:
% ID ...number of identified speaker

%%
% Identification
dist = zeros(1,train); % distance vector for DTW
dist_min = zeros(1,num_speakers); % vector of distance minima between the i-th speaker's recordings
for i = 1:num_speakers
       for j = 1:train
            dist(j) = DTW(T{recordingID,spID},R{j,i});
       end
           dist_min(i) = min(dist); % finding the minima between the i-th speaker's recordings
end
%%%% speaker identification 
[dist_min2, ID] = min(dist_min);  % finding the minimum between speakers and the speaker index



end