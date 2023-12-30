function [] = log2terminal(priority,tag,msg)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
fileID = 1;
if priority == 'E'
    fileID = 2;
end

logFormatTime = string(datetime("now"),'yyyy-MM-dd HH:mm:ss.SSS');
fprintf(fileID,'%s %s: %s: %s\n',logFormatTime,priority,tag,msg);
end