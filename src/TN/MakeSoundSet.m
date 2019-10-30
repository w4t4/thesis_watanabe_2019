% MakeSoundSet (ver.1)
%
% Make sound variables below.
%
% snd_low
% snd_lowlong
% snd_high
% snd_highlong
% snd_trial
% snd_block
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
% Usage: 
%   MakeSoundSet
%
% Other explanation:
%    After call this script, you can ring the each sound using 'sound' function.
%    for example, 
%
%    sound(snd_low);
%
%    However, sometimes it needs pause until the sounding is done.
%    For example,
%
%    sound(snd_low); pause(0.25);
%
%    I don't know the cause.
%    And, you can clear all sound variables above using 'ClearSoundSet.m'.
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
%
% created by Takehir Nagai on 12/20/2007 (ver.1)
%
%

snd_low = makesnd(200,.1,1);
snd_lowlong = makesnd(200,.2,1);
snd_high = makesnd(1100,.1,1);
snd_highlong = makesnd(1100,.2,1);
snd_trial = makesnd(600,.1,1);
snd_block = makesnd(800,.2,1);



