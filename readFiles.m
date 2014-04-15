% Program to read PearceDataSet files from the Tufts database
% Filenames range from run00001.txt to run00817.txt
% Each file contains 30x872 data
% According to the following description
% Vapor Key
% 
% A = toluene
% B = methyl salicylate
% c = ethanol
% D = heptane
% E = p-cymene
% F = cyclohexanone
% G = cholorform

% the following mat file contains the type of vapor contained in the
% file (either pure or compound)

load vaporfile.mat % After loading, variable vapor is loaded in memory

% Getting the size of array
[ren col] = size(vapors);    % col 1 = filename
                            % col 2 = pure or compound vapor
                            % ptol = control run
                            
for i = 1 : ren
    filename = vapors(i,1);
    compound = vapors(i,2);
    
    if compound == 'ptol'
        



% Import the file
newData1 = importdata(fileToRead1, '\t', 4);

% Create new variables in the base workspace from those fields.
vars = fieldnames(newData1);
for i = 1:length(vars)
    assignin('base', vars{i}, newData1.(vars{i}));
end

% The following line removes the first column, which contains NaN
vapour_data = data(:,2:873);