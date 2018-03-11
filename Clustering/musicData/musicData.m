%% 8
clear
clc

fid = fopen('music2.csv','r');
tline = fgets(fid);
variables = strsplit(tline, ',');
music_data = textscan(fid,'%s%s%s%f%f%f%f%f','delimiter',',', 'HeaderLines', 1);
fclose(fid);
%
numeric_music_data = [music_data{4:end}];
% numeric_music_data = double(numeric_college_data);
trData = numeric_music_data;

% Zscore normalization
for i = 1:size(trData,2)
    trData_zscorenorm(:,i) = (trData(:,i)-mean(trData(:,i)))/std(trData(:,i));
end
numeric_music_data = trData_zscorenorm;

% type
Y = pdist(numeric_music_data);
Y = squareform(Y);
Z_music = linkage(Y, 'complete');
figure('Position', [100, 100, 1000, 600]);
[~,~,outperm_music] = dendrogram(Z_music,0);
set(gca,'Xtick',1:1:size((music_data{1,3}),1))
set(gca, 'XTickLabel', (music_data{1,3}(outperm_music))')
xtickangle(90)
title('complete linkage')
%% 
% single
Z_music_single = linkage(Y);
figure('Position', [100, 100, 1000, 600]);
[~,~,outperm_music] = dendrogram(Z_music_single,0);
set(gca,'Xtick',1:1:size((music_data{1,3}),1))
set(gca, 'XTickLabel', (music_data{1,3}(outperm_music))')
xtickangle(90)
title('single linkage')
%%
% Artist
Y = pdist(numeric_music_data);
Y = squareform(Y);
Z_music = linkage(Y, 'complete');
figure('Position', [100, 100, 1000, 600]);
[~,~,outperm_music] = dendrogram(Z_music,0);
set(gca,'Xtick',1:1:size((music_data{1,2}),1))
set(gca, 'XTickLabel', (music_data{1,2}(outperm_music))')
xtickangle(90)
title('complete linkage')
%% 
% single
Z_music_single = linkage(Y);
figure('Position', [100, 100, 1000, 600]);
[~,~,outperm_music] = dendrogram(Z_music_single,0);
set(gca,'Xtick',1:1:size((music_data{1,2}),1))
set(gca, 'XTickLabel', (music_data{1,2}(outperm_music))')
xtickangle(90)
title('single linkage')

