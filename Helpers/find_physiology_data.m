function find_physiology_data(session_dir)

[data_path, session_name, ~] = fileparts(session_dir);
str_parts = split(session_name, '_');
ratID = str_parts{1};
session_datestr = str_parts{2}(1:8);   % assume yyyymmdd date format

rat_date = strcat(ratID, '_', session_datestr);

subdirs = dir(fullfile(session_dir, strcat(rat_date, '*')));

num_subdirs = length(subdirs);

for i_dir = 1 : num_subdirs



end

end