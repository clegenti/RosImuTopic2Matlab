% This function read the IMU data from a rostopic generated text file.
%
% Input :
%   inputPath : string containing the path to the text file
%   outputPath (optional) : string containing the path of the file you want
%       to save the variables in. If this argument is not provided, the
%       function won't write the variables into a file
% Output :
%   imuTimeStamp : matrix (nb messages * 1) containing the IMU data
%       timestamp
%   imuOrientation : matrix (nb messages * 4) containing the IMU data
%       orientation quaternion x, y, z, w
%   imuAngVelocity : matrix (nb messages * 3) containing the IMU data
%       angular velocity x, y, z
%   imuLimAcc : matrix (nb messages * 3) containing the IMU data linear
%       acceleration x, y, z


function [ imuTimeStamp, imuOrientation, imuAngVelocity, imuLimAcc ]...
    = RIT2M( inputPath, outputPath )

    textRead = fileread( inputPath );
    
    imuMsgs = strsplit(textRead, '---');
    
    nbMsgs = length(imuMsgs)-1;
    imuData = zeros(nbMsgs, 11);
    
    % Treat the messages one after the other
    for i = 1:nbMsgs
        
        msgLines = strsplit(imuMsgs{i}, {'\n' '\r'});
        
        nbLines = length(msgLines);
        imuDataPtr = 1;
        
        % Treat the message's lines one after the other
        for j = 1:nbLines
            line = strrep(msgLines{j}, ' ', '');
            if( (imuDataPtr == 1) && (contains(line,'secs:')) )
                imuData(i,1) = str2double(strrep(line, 'secs:', ''));
                imuDataPtr = 2;
            elseif( (imuDataPtr == 2) && (contains(line,'nsecs:')) )
                nsecs = strrep(line, 'nsecs:', '');
                imuData(i,1) = imuData(i,1) + (str2double(nsecs)*1e-9);
                imuDataPtr = 3;
            elseif( (imuDataPtr == 3) && (contains(line,'orientation:')) )
                imuDataPtr = 4;
            elseif( (imuDataPtr == 4) && (contains(line,'x:')) )
                imuData(i,2) = str2double(strrep(line, 'x:', ''));
                imuDataPtr = 5;
            elseif( (imuDataPtr == 5) && (contains(line,'y:')) )
                imuData(i,3) = str2double(strrep(line, 'y:', ''));
                imuDataPtr = 6;
            elseif( (imuDataPtr == 6) && (contains(line,'z:')) )
                imuData(i,4) = str2double(strrep(line, 'z:', ''));
                imuDataPtr = 7;
            elseif( (imuDataPtr == 7) && (contains(line,'w:')) )
                imuData(i,5) = str2double(strrep(line, 'w:', ''));
                imuDataPtr = 8;
            elseif( (imuDataPtr == 8) && (contains(line,'angular_velocity:')) )
                imuDataPtr = 9;
            elseif( (imuDataPtr == 9) && (contains(line,'x:')) )
                imuData(i,6) = str2double(strrep(line, 'x:', ''));
                imuDataPtr = 10;
            elseif( (imuDataPtr == 10) && (contains(line,'y:')) )
                imuData(i,7) = str2double(strrep(line, 'y:', ''));
                imuDataPtr = 11;
            elseif( (imuDataPtr == 11) && (contains(line,'z:')) )
                imuData(i,8) = str2double(strrep(line, 'z:', ''));
                imuDataPtr = 12;
            elseif( (imuDataPtr == 12) && (contains(line,'linear_acceleration:')) )
                imuDataPtr = 13;
            elseif( (imuDataPtr == 13) && (contains(line,'x:')) )
                imuData(i,9) = str2double(strrep(line, 'x:', ''));
                imuDataPtr = 14;
            elseif( (imuDataPtr == 14) && (contains(line,'y:')) )
                imuData(i,10) = str2double(strrep(line, 'y:', ''));
                imuDataPtr = 15;
            elseif( (imuDataPtr == 15) && (contains(line,'z:')) )
                imuData(i,11) = str2double(strrep(line, 'z:', ''));
                imuDataPtr = 16;
            end;
            
        end;
        
        
        % Safety : check if all the fields have been read in the message
        if (imuDataPtr ~= 16)
            error(['Problem reading the IMU message number ' num2str(i)])
        end;
        
    end;
    
    imuTimeStamp = imuData(:,1);
    imuOrientation = imuData(:,2:5);
    imuAngVelocity = imuData(:,6:8);
    imuLimAcc = imuData(:,9:11);
    
    if nargin() == 2
        save(outputPath, 'imuTimeStamp', 'imuOrientation',...
            'imuAngVelocity', 'imuLimAcc');
    end;
    
    
end

  