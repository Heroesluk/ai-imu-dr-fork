function [] = log2terminal(priority,tag,msg)
%UNTITLED 此处提供此函数的摘要
%   此处提供详细说明
logFormatTime = datestr(now,'yyyy-mm-dd HH:MM:ss.FFF');
fprintf('%s %s: %s: %s\n',logFormatTime,priority,tag,msg);
end