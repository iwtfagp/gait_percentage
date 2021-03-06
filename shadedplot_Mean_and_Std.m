close all;clear all;clc;

file_path = uigetdir
% fullfile(matlabroot, filedir);
list = dir([ file_path,'\*.percent']);

header={'Left Hip','Right Hip','Left Knee','Right Knee',    ...
'Back Roll','Back yaw','Back Pitch',                        ...
'Left Thigh Roll','Left Thigh yaw','Left Thigh Pitch',      ...
'Right Thigh Roll','Right Thigh yaw','Right Thigh Pitch',   ...
'Left Shank Roll','Left Shank yaw','Left Shank Pitch',      ...
'Right Shank Roll','Right Shank yaw','Right Shank Pitch'};

leftHip = [];
rightHip = [];
leftKnee = [];
rightKnee = [];

outFileName = regexp(list(1).name, '_', 'split');
outFileName = [char(outFileName(1)),'_',char(outFileName(2))];


for fileNum = 1:size(list)
    FileName = list(fileNum).name;
    data=load([file_path, '\', FileName]);
    leftHip     = [leftHip, data(:,1)];
    rightHip    = [rightHip, data(:,2)];
    leftKnee    = [leftKnee, data(:,3)];
    rightKnee   = [rightKnee, data(:,4)];
end

leftHip_mean = mean(leftHip,2);
leftHip_std = std(leftHip,1,2); %採用分母N為母數時，可令flag=1
rightHip_mean = mean(rightHip,2);
rightHip_std = std(rightHip,1,2); %採用分母N為母數時，可令flag=1
leftKnee_mean = mean(leftKnee,2);
leftKnee_std = std(leftKnee,1,2); %採用分母N為母數時，可令flag=1
rightKnee_mean = mean(rightKnee,2); 
rightKnee_std = std(rightKnee,1,2); %採用分母N為母數時，可令flag=1

xAxis = [0.01:0.01:100];

%% Display
subplot(2,2,1);
shadedplot(xAxis, [leftHip_mean+leftHip_std]', [leftHip_mean-leftHip_std]', [1 0.7 0.7], 'r');
title(header(1), 'FontSize', 12, 'fontname' , 'Times New Roman');
ylabel('angle (degree)', 'FontSize', 12, 'fontname' , 'Times New Roman'); xlabel('gait cycle(%)', 'FontSize', 12, 'fontname' , 'Times New Roman');
hold on;plot(xAxis, leftHip_mean, 'r');hold off;

subplot(2,2,2);
shadedplot(xAxis, [rightHip_mean+rightHip_std]', [rightHip_mean-rightHip_std]', [0.7 0.7 1], 'b');
title(header(2), 'FontSize', 12, 'fontname' , 'Times New Roman');
ylabel('angle (degree)', 'FontSize', 12, 'fontname' , 'Times New Roman'); xlabel('gait cycle(%)', 'FontSize', 12, 'fontname' , 'Times New Roman');
hold on;plot(xAxis, rightHip_mean, 'b');hold off;

subplot(2,2,3);
shadedplot(xAxis, [leftKnee_mean+leftKnee_std]', [leftKnee_mean-leftKnee_std]', [1 0.7 0.7], 'r');
title(header(3), 'FontSize', 12, 'fontname' , 'Times New Roman');
ylabel('angle (degree)', 'FontSize', 12, 'fontname' , 'Times New Roman'); xlabel('gait cycle(%)', 'FontSize', 12, 'fontname' , 'Times New Roman');
hold on;plot(xAxis, leftKnee_mean, 'r');hold off;

subplot(2,2,4);
shadedplot(xAxis, [rightKnee_mean+rightKnee_std]', [rightKnee_mean-rightKnee_std]', [0.7 0.7 1], 'b');
title(header(4), 'FontSize', 12, 'fontname' , 'Times New Roman');
ylabel('angle (degree)', 'FontSize', 12, 'fontname' , 'Times New Roman');
xlabel('gait cycle(%)', 'FontSize', 12, 'fontname' , 'Times New Roman');
hold on;plot(xAxis, rightKnee_mean, 'b');hold off;

NewFilename = [file_path, '\', outFileName, '_Model']
set(gcf,'name',NewFilename)
saveas(gcf,[strtok(NewFilename, '.'),'.jpg']);



% % % the last number means the step is good(for Machine Learning)
data = [zeros(size(leftHip_mean,1),1)'; leftHip_mean'; leftHip_std'; rightHip_mean'; rightHip_std'; leftKnee_mean'; leftKnee_std'; rightKnee_mean'; rightKnee_std'];

if ~exist('out', 'dir')
  mkdir('out');
end

fid=fopen([file_path, '\', outFileName, '.model'],'w');
fprintf(fid,'%1.0f, %6.2f, %6.2f, %6.2f, %6.2f, %6.2f, %6.2f, %6.2f, %6.2f\n', data);
fclose(fid);  %關閉檔案
'OK!!!!'









