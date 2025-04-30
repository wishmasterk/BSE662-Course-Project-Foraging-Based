% ===================== Batch BHV Processing Script =====================

subjects = {'31730', '43000', '47131', '47204', '47324', '48238'};
conditions = {'pre', 'post'};

all_data = table(); % Accumulate all subject-condition data

for s = 1:length(subjects)
    for c = 1:length(conditions)
        subid_str = subjects{s};
        cond_str = conditions{c};
        baseDir = fullfile('D:\brainstorm_250323_src\brainstorm3\bhv_files', [cond_str 'stress']);
        filename = fullfile(baseDir, [subid_str '_' cond_str 'stress.bhv']);


        fprintf('📂 Processing %s...\n', filename);
        
        try
            bhvStruct = bhv_read(filename);

            reactionTimes = bhvStruct.ReactionTime(:);
            trialStartTimes = bhvStruct.AbsoluteTrialStartTime(:);
            numTrials = length(reactionTimes);

            nanIdx = find(isnan(reactionTimes), 1, 'first');
            if isempty(nanIdx) || nanIdx == length(reactionTimes)
                error('Could not determine environment separation. Check data.');
            end

            % ===================== Reward Alignment =====================
            rewardsRaw = arrayfun(@(x) x.rwrd, bhvStruct.UserVars, 'UniformOutput', false);
            emptyIdx = cellfun(@isempty, rewardsRaw);
            rewardsRaw(emptyIdx) = {NaN};
            rewardsRaw = rewardsRaw(:);

            numExtracted = length(rewardsRaw);
            numMissing = numTrials - numExtracted;
            if numMissing > 0
                rewardsRaw = [rewardsRaw; repmat({NaN}, numMissing, 1)];
            elseif numMissing < 0
                rewardsRaw = rewardsRaw(1:numTrials);
            end

            reward_aligned = cell2mat(rewardsRaw);
            reward_aligned(isnan(reward_aligned)) = 0; 

            trial_time = [diff(trialStartTimes); NaN];
            state = isnan(reward_aligned);  % 1 = leave trial
            state = double(state); % make binary

            beforeIdx = 1:nanIdx-1;
            afterIdx = nanIdx+1:numTrials;
            % ===================== State Calculation =====================
            state = zeros(numTrials, 1);        % Default: stay = 0
            state(reward_aligned == 0) = 1;     % Leave trial if reward is 0


            beforeIdx = 1:nanIdx-1;
            afterIdx = nanIdx+1:numTrials;
            leaveBefore = beforeIdx(state(beforeIdx) == 1);
            leaveAfter = afterIdx(state(afterIdx) == 1);
            avg_time_before = mean(trial_time(leaveBefore), 'omitnan');
            avg_time_after = mean(trial_time(leaveAfter), 'omitnan');

            if avg_time_before > avg_time_after
                labelBefore = 'long';
                labelAfter = 'short';
            else
                labelBefore = 'short';
                labelAfter = 'long';
            end

            env_labels = strings(numTrials,1);
            for i = 1:numTrials
                if i == nanIdx
                    env_labels(i) = "separator";
                elseif isnan(reactionTimes(i))
                    env_labels(i) = "bad";
                elseif i < nanIdx
                    env_labels(i) = labelBefore;
                else
                    env_labels(i) = labelAfter;
                end
            end

            % ===================== Cleanup and Mapping =====================
            valid_rows = ~ismember(env_labels, ["separator", "bad"]);
            env_labels = env_labels(valid_rows);
            trialStartTimes = trialStartTimes(valid_rows);
            reactionTimes = reactionTimes(valid_rows);
            trial_time = trial_time(valid_rows);
            reward_aligned = reward_aligned(valid_rows);
            state = state(valid_rows);

            % Map to numeric
            env_num = double(env_labels == "short") + 2 * double(env_labels == "long");
            stress_num = double(strcmp(cond_str, 'pre')) * 1 + double(strcmp(cond_str, 'post')) * 2;

            trial_num_in_cond = (1:sum(valid_rows))';
            
            % Trial number in each environment
            trial_num_in_env = zeros(length(env_labels),1);
            u_envs = unique(env_labels);
            for u = 1:length(u_envs)
                idxs = strcmp(env_labels, u_envs{u});
                trial_num_in_env(idxs) = 1:sum(idxs);
            end

            % Create table
            subid_col = repmat(str2double(subid_str), length(trial_num_in_cond), 1);
            stress_col = repmat(stress_num, length(trial_num_in_cond), 1);

            T = table(subid_col, stress_col, trial_num_in_cond, env_num, trial_num_in_env, ...
                trialStartTimes, reactionTimes, trial_time, reward_aligned, state, ...
                'VariableNames', {'subject_id','stress_condition','trial_number','environment',...
                'trial_number_in_env','trial_start_time','reaction_time','trial_time','reward','state'});

            all_data = [all_data; T];

        catch ME
            fprintf('❌ Error processing %s: %s\n', filename, ME.message);
        end
    end
end

% Save final combined CSV
writetable(all_data, 'all_subjects_bhv_cleaned.csv');
fprintf('\n✅ All data saved to all_subjects_bhv_cleaned.csv\n');
