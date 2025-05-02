% --- Begin Batch Export ---

% 1) Define output directory
outDir = 'C:\Users\SHIVAM KUMAR\Desktop\bse662_brainstorm\all_csv'; % change the output folder
if ~exist(outDir, 'dir')
    mkdir(outDir);
end

% Define the base name and the range of numbers
baseName = 'p48238pre';
startNum = 1;
endNum = 78; % Set this to the last number in your sequence

fprintf('Starting batch export...\n');

% Loop through each number from startNum to endNum
for i = startNum:endNum
    
    % Format the number with leading zero if needed (e.g., 01, 02, ..., 09, 10, ...)
    numStr = sprintf('%02d', i); 
    
    % Construct the current variable name (e.g., 'p48238pre01', 'p48238pre02')
    currentVarName = [baseName, numStr];
    
    fprintf('Processing %s...\n', currentVarName);
    
    % Check if the variable exists in the workspace
    if exist(currentVarName, 'var')
        
        % Construct the command to get the FOOOF data
        % Using eval is necessary here to access dynamically named variables
        % Make sure the variables (p48238pre01, etc.) are loaded in the workspace
        try
            fooofCommand = sprintf('%s.Options.FOOOF', currentVarName);
            fooof = eval(fooofCommand);

            % --- Export logic (same as before, but using dynamic names) ---

            % 3) Export peaks
            if isfield(fooof, 'peaks') && ~isempty(fooof.peaks)
                T_peaks = struct2table(fooof.peaks);
                % Filter for specific channels if the 'channel' field exists
                if ismember('channel', T_peaks.Properties.VariableNames)
                   T_peaks = T_peaks(ismember(T_peaks.channel, {'CZ','FZ'}), :);
                else
                   warning('Variable "channel" not found in peaks table for %s. Exporting all rows.', currentVarName);
                end
                 % Construct dynamic filename
                peakFileName = fullfile(outDir, [currentVarName, '_peaks.csv']);
                writetable(T_peaks, peakFileName);
            else
                warning('No "peaks" data found or it is empty for %s.', currentVarName);
            end

            % 4) Export aperiodics
            if isfield(fooof, 'aperiodics') && ~isempty(fooof.aperiodics)
                T_ap = struct2table(fooof.aperiodics);
                 % Filter for specific channels if the 'channel' field exists
                if ismember('channel', T_ap.Properties.VariableNames)
                    T_ap = T_ap(ismember(T_ap.channel, {'CZ','FZ'}), :);
                else
                    warning('Variable "channel" not found in aperiodics table for %s. Exporting all rows.', currentVarName);
                end
                % Construct dynamic filename
                apFileName = fullfile(outDir, [currentVarName, '_aperiodics.csv']);
                writetable(T_ap, apFileName);
            else
                 warning('No "aperiodics" data found or it is empty for %s.', currentVarName);
            end

            % 5) Export stats
             if isfield(fooof, 'stats') && ~isempty(fooof.stats)
                T_stats = struct2table(fooof.stats);
                 % Filter for specific channels if the 'channel' field exists
                if ismember('channel', T_stats.Properties.VariableNames)
                    T_stats = T_stats(ismember(T_stats.channel, {'CZ','FZ'}), :);
                else
                    warning('Variable "channel" not found in stats table for %s. Exporting all rows.', currentVarName);
                end
                % Construct dynamic filename
                statsFileName = fullfile(outDir, [currentVarName, '_stats.csv']);
                writetable(T_stats, statsFileName);
             else
                warning('No "stats" data found or it is empty for %s.', currentVarName);
             end

            fprintf('→ Exported CZ/FZ rows for %s into %s\n', currentVarName, outDir);

        catch ME
            warning('Could not process variable %s. Error: %s', currentVarName, ME.message);
        end
        
    else
        warning('Variable %s does not exist in the workspace. Skipping.', currentVarName);
    end
    
    fprintf('------------------------------------\n'); % Separator for clarity
end

fprintf('Batch export finished.\n');

% --- End Batch Export ---
