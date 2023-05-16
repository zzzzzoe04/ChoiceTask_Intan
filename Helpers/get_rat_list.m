function [rat_nums, ratIDs, ratIDs_goodhisto] = get_rat_list()
% list of rats to be analyzed from thalamic recordings
% update rat_nums (and hopefully not ratnums_with_bad_histo) to indicate
% which rats should be analyzed

rat_nums = [326, 327, 372, 374, 376, 378, 379, 394, 395, 396, 411, 412, 413, 419, 420, 425, 427, 456, 459, 460, 462, 464, 463, 466, 465];

ratnums_with_bad_histo = [374, 376, 396, 413];

rats_with_good_histo = 0;
for i_rat = 1 : length(rat_nums)
    ratIDs{i_rat} = sprintf('R%04d', rat_nums(i_rat));

    if ~ismember(rat_nums(i_rat), ratnums_with_bad_histo)
        rats_with_good_histo = rats_with_good_histo + 1;

        ratIDs_goodhisto{rats_with_good_histo} = ratIDs{i_rat};
    end
end