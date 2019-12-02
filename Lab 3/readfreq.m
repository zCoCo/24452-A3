function [freq,amp,pha]=readfreq(filename,minfreq,maxfreq)
a=textread(filename,'','headerlines',21); % reads and writes the experimental data to variable a

% assigning the frequency, magnitude and phase information from the exp data
freq=a(minfreq*40+1:maxfreq*40+1,1); 
amp=a(minfreq*40+1:maxfreq*40+1,2);
pha=a(minfreq*40+1:maxfreq*40+1,5);
end
