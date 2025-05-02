subject_id = '47131'; %change to the correct subject id
prefix_pre = ['p', subject_id, 'pre'];
prefix_post = ['p', subject_id, 'post'];

files = who;  % List of all variables in the workspace
results = {};  % Cell array to collect results
row = 1;

% Helper function to extract numeric suffix
getFileNum = @(name) sscanf(name, [prefix_pre, '%02d']);
getFileNumPost = @(name) sscanf(name, [prefix_post, '%02d']);


% Separate and sort 'pre' and 'post' files numerically
pre_files = files(startsWith(files, prefix_pre));
[~, idx_pre_sorted] = sort(cellfun(getFileNum, pre_files));
pre_files = pre_files(idx_pre_sorted);

post_files = files(startsWith(files, prefix_post));
[~, idx_post_sorted] = sort(cellfun(getFileNumPost, post_files));
post_files = post_files(idx_post_sorted);

% Combine in desired order: all pre first, then post
ordered_files = [pre_files; post_files];

for i = 1:length(ordered_files)
    varName = ordered_files{i};

    data = eval(varName);  % Access the struct from workspace
    if ~isfield(data, 'Events')
        warning(['No Events in ', varName]);
        continue;
    end

    events = data.Events;
    labels = {events.label};
    times = [events.times];

    ut_flag = NaN;
    pr_flag = NaN;
    start_time = NaN;
    end_time = NaN;

    % Find U or T
    idx_U = find(strcmpi(labels, 'TRIGGER EVENT U'), 1);
    idx_T = find(strcmpi(labels, 'TRIGGER EVENT T'), 1);
    if ~isempty(idx_U)
        ut_flag = 1;
        end_time = times(idx_U);
    elseif ~isempty(idx_T)
        ut_flag = 0;
        end_time = times(idx_T);
    end

    % Find P or R
    if any(strcmpi(labels, 'TRIGGER EVENT P'))
        pr_flag = 1;
    elseif any(strcmpi(labels, 'TRIGGER EVENT R'))
        pr_flag = 0;
    end

    % Find M (start marker)
    idx_M = find(strcmpi(labels, 'TRIGGER EVENT M'), 1);
    if ~isempty(idx_M)
        start_time = times(idx_M);
    end

    % Store row (add two identical rows for each file)
    for j = 1:2
        results{row, 1} = ut_flag;
        results{row, 2} = pr_flag;
        results{row, 3} = start_time;
        results{row, 4} = end_time;
        row = row + 1;
    end
end

% Convert to numeric matrix and write to CSV
results_mat = cell2mat(results);
writematrix(results_mat, ['trial_summary_', subject_id, '.csv']);