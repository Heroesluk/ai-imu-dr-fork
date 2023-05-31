function [] = log2terminal(priority,tag,msg)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
fileID = 1;
if priority == 'E'
    fileID = 2;
end

logFormatTime = datestr(now,'yyyy-mm-dd HH:MM:ss.FFF');
fprintf(fileID,'%s %s: %s: %s\n',logFormatTime,priority,tag,msg);
end