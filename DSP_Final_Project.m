clc
clear all
close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[file,path] = uigetfile('*.wav');
[wave,wfs] = audioread(file);
duration=length(wave)/wfs;
sound(wave,wfs);
d1=str2double(inputdlg('Specify the required gain in decibels for the frequency range (0-170Hz):'));
d2=str2double(inputdlg('Specify the required gain in decibels for the frequency range (170-310Hz):'));
d3=str2double(inputdlg('Specify the required gain in decibels for the frequency range (310-600Hz):'));
d4=str2double(inputdlg('Specify the required gain in decibels for the frequency range (600-1000Hz):'));
d5=str2double(inputdlg('Specify the required gain in decibels for the frequency range (1-3KHz):'));
d6=str2double(inputdlg('Specify the required gain in decibels for the frequency range (3-6KHz):'));
d7=str2double(inputdlg('Specify the required gain in decibels for the frequency range (6-12KHz):'));
d8=str2double(inputdlg('Specify the required gain in decibels for the frequency range (12-14KHz):'));
d9=str2double(inputdlg('Specify the required gain in decibels for the frequency range (14-16KHz):'));
choice=menu('Choose the type of filter required:','IIR','FIR');
Fs=0;
while Fs<52
    Fs=str2double(inputdlg('Specify the required output sample rate in KHz(must be greater than 52Khz):'));
end
Fs=Fs*1000;

figure;
subplot(211);plot(wave);
title('Signal in time domain')
Fvec=linspace(-wfs/2,wfs/2,duration*wfs);
subplot(212);plot(Fvec,abs(fftshift(fft(wave))));
title('Signal in freq domain')
xlabel('Fvec')
ylabel('Ymag')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Astop = 50;    % Stopband Attenuation (dB)
Astop1 = 50;     % First Stopband Attenuation (dB)
Apass  = 1;      % Passband Ripple (dB)
Astop2 = 50;     % Second Stopband Attenuation (dB)

%%%%%%%%%%%%%%%%%%%%%%%%
Fpass = 170;               % Passband Frequency
Fstop = Fpass .* 1.65;     % Stopband Frequency
h0 = fdesign.lowpass('fp,fst,ap,ast', Fpass, Fstop, Apass, Astop, Fs);

F1pass1 = 170;   % First Passband Frequency
F1pass2 = 310;   % Second Passband Frequency
F1stop1 = F1pass1 .* 0.45;     % First Stopband Frequency
F1stop2 = F1pass2 .* 1.65;     % Second Stopband Frequency 
h1 = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', F1stop1, F1pass1, ...
    F1pass2, F1stop2, Astop1, Apass, Astop2, Fs);

F2pass1 = 310;   % First Passband Frequency
F2pass2 = 600;   % Second Passband Frequency
F2stop1 = F2pass1 .* 0.45;     % First Stopband Frequency
F2stop2 = F2pass2 .* 1.65;     % Second Stopband Frequency
h2 = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', F2stop1, F2pass1, ...
    F2pass2, F2stop2, Astop1, Apass, Astop2, Fs);

F3pass1 = 600;   % First Passband Frequency
F3pass2 = 1000;   % Second Passband Frequency
F3stop1 = F3pass1 .* 0.45;     % First Stopband Frequency
F3stop2 = F3pass2 .* 1.65;     % Second Stopband Frequency
h3 = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', F3stop1, F3pass1, ...
    F3pass2, F3stop2, Astop1, Apass, Astop2, Fs);

F4pass1 = 1000;   % First Passband Frequency
F4pass2 = 3000;   % Second Passband Frequency
F4stop1 = F4pass1 .* 0.45;     % First Stopband Frequency
F4stop2 = F4pass2 .* 1.65;     % Second Stopband Frequency
h4 = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', F4stop1, F4pass1, ...
    F4pass2, F4stop2, Astop1, Apass, Astop2, Fs);


F5pass1 = 3000;   % First Passband Frequency
F5pass2 = 6000;   % Second Passband Frequency
F5stop1 = F5pass1 .* 0.45;     % First Stopband Frequency
F5stop2 = F5pass2 .* 1.65;     % Second Stopband Frequency
h5 = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', F5stop1, F5pass1, ...
    F5pass2, F5stop2, Astop1, Apass, Astop2, Fs);

F6pass1 = 6000;   % First Passband Frequency
F6pass2 = 12000;   % Second Passband Frequency
F6stop1 = F6pass1 .* 0.45;     % First Stopband Frequency
F6stop2 = F6pass2 .* 1.65;     % Second Stopband Frequency
h6 = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', F6stop1, F6pass1, ...
    F6pass2, F6stop2, Astop1, Apass, Astop2, Fs);

F7pass1 = 12000;   % First Passband Frequency
F7pass2 = 14000;   % Second Passband Frequency
F7stop1 = F7pass1 .* 0.45;     % First Stopband Frequency
F7stop2 = F7pass2 .* 1.65;     % Second Stopband Frequency
h7 = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', F7stop1, F7pass1, ...
    F7pass2, F7stop2, Astop1, Apass, Astop2, Fs);

F8pass1 = 14000;   % First Passband Frequency
F8pass2 = 16000;   % Second Passband Frequency
F8stop1 = F8pass1 .* 0.45;     % First Stopband Frequency
F8stop2 = F8pass2 .* 1.65;     % Second Stopband Frequency
h8 = fdesign.bandpass('fst1,fp1,fp2,fst2,ast1,ap,ast2', F8stop1, F8pass1, ...
    F8pass2, F8stop2, Astop1, Apass, Astop2, Fs);

if choice ==1
    Hd1 = design(h0, 'ellip', ...
        'MatchExactly', 'both');
    Hd2 = design(h1, 'ellip', ...
        'MatchExactly', 'both');
    Hd3 = design(h2, 'ellip', ...
        'MatchExactly', 'both');
    Hd4 = design(h3, 'ellip', ...
        'MatchExactly', 'both');
    Hd5 = design(h4, 'ellip', ...
        'MatchExactly', 'both');
    Hd6 = design(h5, 'ellip', ...
        'MatchExactly', 'both');
    Hd7 = design(h6, 'ellip', ...
        'MatchExactly', 'both');
    Hd8 = design(h7, 'ellip', ...
        'MatchExactly', 'both');
    Hd9 = design(h8, 'ellip', ...
        'MatchExactly', 'both');
end

if choice ==2
    Hd1 = design(h0, 'equiripple', ...
        'MinOrder', 'any');
    Hd2 = design(h1, 'equiripple', ...
        'MinOrder', 'any');
    Hd3 = design(h2, 'equiripple', ...
        'MinOrder', 'any');
    Hd4 = design(h3, 'equiripple', ...
        'MinOrder', 'any');
    Hd5 = design(h4, 'equiripple', ...
        'MinOrder', 'any');
    Hd6 = design(h5, 'equiripple', ...
        'MinOrder', 'any');
    Hd7 = design(h6, 'equiripple', ...
        'MinOrder', 'any');
    Hd8 = design(h7, 'equiripple', ...
        'MinOrder', 'any');
    Hd9 = design(h8, 'equiripple', ...
        'MinOrder', 'any');
end


fvtool(Hd1,Hd2,Hd3,Hd4,Hd5,Hd6,Hd7,Hd8,Hd9); %tool that plots the magnitude & phase responses ; pzmap ; impulse & step responses

y1= filter(Hd1,wave);
y2= filter(Hd2,wave);
y3= filter(Hd3,wave);
y4= filter(Hd4,wave);
y5= filter(Hd5,wave);
y6= filter(Hd6,wave);
y7= filter(Hd7,wave);
y8= filter(Hd8,wave);
y9= filter(Hd9,wave);

figure;
subplot(331);plot(y1);
subplot(332);plot(y2);
subplot(333);plot(y3);
subplot(334);plot(y4);
subplot(335);plot(y5);
subplot(336);plot(y6);
subplot(337);plot(y7);
subplot(338);plot(y8);
subplot(339);plot(y9);

Y1=fftshift(fft(y1));
Y2=fftshift(fft(y2));
Y3=fftshift(fft(y3));
Y4=fftshift(fft(y4));
Y5=fftshift(fft(y5));
Y6=fftshift(fft(y6));
Y7=fftshift(fft(y7));
Y8=fftshift(fft(y8));
Y9=fftshift(fft(y9));

figure;
subplot(331);plot(Fvec,abs(Y1));
subplot(332);plot(Fvec,abs(Y2));
subplot(333);plot(Fvec,abs(Y3));
subplot(334);plot(Fvec,abs(Y4));
subplot(335);plot(Fvec,abs(Y5));
subplot(336);plot(Fvec,abs(Y6));
subplot(337);plot(Fvec,abs(Y7));
subplot(338);plot(Fvec,abs(Y8));
subplot(339);plot(Fvec,abs(Y9));

y1=y1.*d1;
y2=y2.*d2;
y3=y3.*d3;
y4=y4.*d4;
y5=y5.*d5;
y6=y6.*d6;
y7=y7.*d7;
y8=y8.*d8;
y9=y9.*d9;
Ytot=y1+y2+y3+y4+y5+y6+y7+y8+y9;


figure;
subplot(211);plot(Ytot);
title('Composite Signal in time domain')
Fvec=linspace(-wfs/2,wfs,duration*wfs);
subplot(212);plot(Fvec,abs(fftshift(fft(Ytot))));
title('Composite Signal in freq domain')

figure;
subplot(211);plot(wave);
title('Signal in time domain')
subplot(212);plot(Ytot);
title('Composite Signal in time domain')
figure;
subplot(211);plot(Fvec,abs(fftshift(fft(wave))));
title('Signal in freq domain')
subplot(212);plot(Fvec,abs(fftshift(fft(Ytot))));
title('Composite Signal in freq domain')


sound(Ytot,wfs);
audiowrite('ProDone.wav',Ytot,wfs);