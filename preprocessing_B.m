clc;
clear all;

% Specify the file name and path
filename = 'B_outdoor.csv';

% Read the Excel file
raw_data_Bout = readtable(filename);
%%
raw_data_Bout.created_at = datetime(raw_data_Bout.created_at,"InputFormat","dd-MMM-yyyy' 'HH:mm:ss","TimeZone","Asia/Calcutta","Format","dd-MMM-uuuu HH:mm:ss");

%%
%Remove extra columns and rename
%raw_data_Bout = removevars(raw_data_Bout,["Var1","entry_id"]);
raw_data_Bout = renamevars(raw_data_Bout,["pm10","pm25","rh","temp"],["pm10","pm25","rh","temp"]);

%%
% Filter the data based on humidity condition (<80%)
%raw_data_Bout(raw_data_Bout.rh >= 80,:) = [];

%% Apply IQR and replace outliars with linear interpolation
% raw_data_Bout.pm10 = filloutliers(raw_data_Bout.pm10,'linear','quartiles');
% raw_data_Bout.pm25 = filloutliers(raw_data_Bout.pm25,'linear','quartiles');
% raw_data_Bout.rh = filloutliers(raw_data_Bout.rh,'linear','quartiles');
% raw_data_Bout.temp = filloutliers(raw_data_Bout.temp,'linear','quartiles');

 raw_data_Bout = table2timetable(raw_data_Bout);
% %%
 timelimit = datetime('2023-04-02 20:30:00',"TimeZone","Asia/Calcutta"):minutes(1):datetime('2023-04-24 10:00:00',"TimeZone","Asia/Calcutta");
 raw_data_Bout = retime(raw_data_Bout,timelimit,'mean');
 raw_data_Bout.created_at = datetime(raw_data_Bout.created_at,"Format","dd-MMM-uuuu HH:mm:ss");
 raw_data_Bout = fillmissing(raw_data_Bout, 'constant', NaN);

%% Apply moving average
windowSize = 60;
raw_data_Bout.pm10 = movmean(raw_data_Bout.pm10,windowSize);
raw_data_Bout.pm25 = movmean(raw_data_Bout.pm25,windowSize);
raw_data_Bout.rh = movmean(raw_data_Bout.rh,windowSize);
raw_data_Bout.temp = movmean(raw_data_Bout.temp,windowSize);

%%
save('data_B.mat','raw_data_Bout');

%%
% Display the cleaned data
plot(raw_data_Bout.created_at,raw_data_Bout.pm10); hold on;
plot(raw_data_Bout.created_at,raw_data_Bout.pm25);
plot(raw_data_Bout.created_at,raw_data_Bout.rh);
plot(raw_data_Bout.created_at,raw_data_Bout.temp);
legend(["PM10","PM25","RH","Temp"])
grid on
pbaspect([12 7 1])