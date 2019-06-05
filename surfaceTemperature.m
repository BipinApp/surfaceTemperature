clc
clear 
close all

% reading the band 6 of landsat to convert into surface temperature reflectance
directory = 'Z:\SpecialNeeds\BIPIN RAUT\Lan\New folder\LE071410412007011001T1-SC20181017175104.tar\LE071410412007011001T1-SC20181017175104\LE07_L1TP_141041_20070110_20170105_01_T1.tar\LE07_L1TP_141041_20070110_20170105_01_T1\LE07_L1TP_141041_20070110_20170105_01_T1_B6_VCID_2';
[imageThermal, R] = geotiffread(directory);
[row,col] = size(imageThermal);
geoInfo = geotiffinfo(directory);
geoTags = geoInfo.GeoTIFFTags.GeoKeyDirectoryTag;

% reading the mtl file 
%mtlFile = MTL_parser('Z:\SpecialNeeds\BIPIN RAUT\Lan\New folder\LE071410412007011001T1-SC20181017175104.tar\LE071410412007011001T1-SC20181017175104\LE07_L1TP_141041_20070110_20170105_01_T1.tar\LE07_L1TP_141041_20070110_20170105_01_T1\LE07_L1TP_141041_20070110_20170105_01_T1_MTL.txt');

% converting the thermal band to surface temperature
radiance = ((17.040-3.200)/(255-1))*(double(imageThermal)-1)+ 3.200;

% converting to kelvin 
k1 = 666.09;
k2 = 1282.71;
logTermDiv = repmat(k1,row,col)./ radiance;
logTermT  =logTermDiv + 1;
logValue = log(logTermT);

temperature = repmat(k2,row,col)./logValue -273.15;

% writing temp file
geotiffwrite('Z:\SpecialNeeds\BIPIN RAUT\Lan\New folder\LE071410412007011001T1-SC20181017175104.tar\LE071410412007011001T1-SC20181017175104\temp_2007_01_10.tif',temperature,R,'GeoKeyDirectoryTag',geoTags)