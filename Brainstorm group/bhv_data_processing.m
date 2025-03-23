% Load the bhv file
bhvStruct = bhv_read('48238_poststress.bhv');

% Extract variables using correct field names
reactionTimes = bhvStruct.ReactionTime;
trialTimes    = bhvStruct.AbsoluteTrialStartTime;
rewardsRaw    = bhvStruct.RewardRecord;  % reward data only for good trials
trialErrors   = bhvStruct.TrialError;      % assuming 0 indicates a good trial

% Identify valid trial indices (ignore trailing NaNs)
validIdx = find(~isnan(trialTimes)); % valid trials based on trialTimes

% Find the NaN that separates environments in ReactionTime
nanIdx = find(isnan(reactionTimes), 1, 'first');
if isempty(nanIdx) || nanIdx == length(reactionTimes)
    error('Could not determine environment separation. Check data.');
end

% Extract trials for environment 1 (e.g., short travel time)
env1_trials = reactionTimes(1:nanIdx-1);
env1_trials = env1_trials(:);  % force as column vector
env1_times  = trialTimes(1:nanIdx-1);
env1_times  = env1_times(:);

% Extract trials for environment 2 (e.g., long travel time)
env2_trials = reactionTimes(nanIdx+1:validIdx(end));
env2_trials = env2_trials(:);  % force as column vector
env2_times  = trialTimes(nanIdx+1:validIdx(end));
env2_times  = env2_times(:);

% Display trial counts for each environment
fprintf('Environment 1 (short): %d trials\n', length(env1_trials));
fprintf('Environment 2 (long): %d trials\n', length(env2_trials));

% Combine the trial data from both environments
all_reaction_times = [env1_trials; env2_trials];
all_trial_times    = [env1_times; env2_times];
numTrials = length(all_reaction_times);

% --- Reward Alignment ---
% Instead of using TrialError (which gives a different count), we align rewards with valid trials.
% If reward data has one extra entry than the number of valid trials, drop the extra entry.
if length(rewardsRaw) == numTrials
    reward_aligned = rewardsRaw(:);
elseif length(rewardsRaw) == numTrials + 1
    warning('Reward data has one extra entry compared to valid trials. Dropping the last reward entry.');
    reward_aligned = rewardsRaw(1:end-1);
    reward_aligned = reward_aligned(:);  % force into column vector
else
    error('Mismatch: reward data length (%d) does not match expected (%d or %d).', ...
        length(rewardsRaw), numTrials, numTrials+1);
end

% Create additional columns: subject ID and stress condition
subid = repmat({'48238'}, numTrials, 1);
stress_cond = repmat({'pre'}, numTrials, 1);

% Create environment labels: first part for env1, second for env2
env_labels = [repmat({'short'}, length(env1_trials), 1); repmat({'long'}, length(env2_trials), 1)];

% Verify that all columns have the same number of rows
fprintf('Total trials: %d\n', numTrials);
fprintf('subid: %d, stress_cond: %d, env: %d, trial_time: %d, reaction_time: %d, reward: %d\n', ...
    size(subid,1), size(stress_cond,1), size(env_labels,1), length(all_trial_times), length(all_reaction_times), length(reward_aligned));

% Create the table
T = table(subid, stress_cond, env_labels, all_trial_times, all_reaction_times, reward_aligned, ...
    'VariableNames', {'subid','stress_cond','env','trial_time','reaction_time','reward'});

% Save the table as a CSV file
writetable(T, '48238_poststress_processed.csv');
fprintf('CSV file saved as 48238_poststress_processed.csv\n');
