% Program to read PearceDataSet files from the Tufts database
% Filenames range from run00001.txt to run00817.txt
% Each file contains 30x872 data
% There are a total of 30 frames from each type of bead
% Therefore each row is a frame
% On the othre hand, 13 different types of beads were uses, and they were
% randomly placed on the array. Beads were named as follows
    % af
    % alltech
    % chirex
    % chirexpta
    % lunaphenhex
    % lunapte
    % phenoscn
    % prop
    % scxptb
    % scxptc
    % scxptf
    % sel
    % tbap
% A total of 869 beads were used, and the type of bead is defined in mat
% file beadtype, so reading this mat file will provide with the description
% of each column (only data) that is columns 4 to 872 from run00XXX.txt

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

% In order to gather information according to type of beads, we create a
% cell array which will conatin all type of beads, and they will help us
% compare them with each column to filter data, the second row indicates
% the total amount of sensors for each type of beads
beads = {'af','alltech','chirex','chirexpta','lunaphenhex','lunapte', ...
      'phenoscn','prop','scxptb','scxptc','scxptf','sel','tbap'; ...
      3,1,7,42,11,12,3,9,383,227,166,4,1};
% Transpose beads
beads = transpose(beads);

% the following mat file contains the type of vapor contained in the
% file (either pure or compound)

load vaporfile.mat % After loading, variable vapor is loaded in memory
% Getting the size of array
[ren col] = size(vapors);    % col 1 = filename
                            % col 2 = pure or compound vapor
                            % ptol = control run
                            
load beadtype.mat % After loading, bead description is kept in memory
% Getting the size of array
[renbead colbead] = size(beadtype);    % col 1 = consecutive of row
                                        % col 2 = bead description
                            
                            


                            
for i = 1 : 1 % ren
    filename = vapors(i,1);
    compound = vapors(i,2);
    
    %if compound == 'ptol'
        
    % Import the file
    newData1 = importdata(filename{1}, '\t', 4);

    % Create new variables in the base workspace from those fields.
    vars = fieldnames(newData1);
    for i = 1:length(vars)
        assignin('base', vars{i}, newData1.(vars{i}));
    end

    % The following line removes the first column, which contains NaN
    vapour_data = data(:,2:873);
    % Now free memory by removing variable 'data'
    clear data;

    colorcito = colormap(lines); % we will color each type of bead with a different color
    % This loop gathers information based on the type of bead
    for tipo = 1 : 13
        % let's start from the fist type of bead all the way to the last
        % type of bead (from 'af' to 'tbap')
        sensor = beads(tipo,1);         % keep the name of bead
        total_sensoresc = beads(tipo,2); % keep the amount of sensors
        total_sensores = cell2mat(total_sensoresc); % keep the amount of sensors
        % initialize variables
        index = 1;  % index will address the arrays below defined
        mean_during = zeros(1,total_sensores);
        std_during  = zeros(1,total_sensores);
        for j = 1 : renbead
            if  strcmp(beadtype{j,2},sensor);
                prior_stim  = vapour_data(1:4  , j+3);
                during_stim = vapour_data(5:22 , j+3);
                post_stim   = vapour_data(25:30, j+3);
                % now obtain mean and std for prior, during and post stimulus
                mean_prior(index)  = mean(prior_stim);
                mean_during(index) = mean(during_stim);
                mean_post(index)   = mean(post_stim);
                std_prior(index)   = std(prior_stim);
                std_during(index)  = std(during_stim);
                std_post(index)    = std(post_stim);
                index = index + 1;
            end
        end       
        errorbar(mean_during,std_during,'color',colorcito(tipo,:));
        title(sensor);
        figure;
    end
    


end