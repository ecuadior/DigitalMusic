% sampling frequency
FS = 8000;
% semitone frequency function
Freq = @(n) 440 * 2^(n/12);
% note generator (with soft envelope)
note = @(freq, dur) softEnvelope( sin(2*pi*freq*(0:1/FS:dur)) );
pauseSeg = zeros(1, FS * 0.1);   % 0.1 sec pause
%Notes base on music sheet
line1 = [note(Freq(12),.125), note(Freq(10),.125), note(Freq(12),.125), note(Freq(10),.125)];
line2 = [note(Freq(5),.125), note(Freq(7),.125), note(Freq(5),.125), note(Freq(3),.125)];
line3 = [note(Freq(0),.125), note(Freq(-2),.125)];
line4 = [note(Freq(0),.25), note(Freq(-1),.125), note(Freq(-2),.25)];
line5 = [note(Freq(14),.35), note(Freq(14),.01), note(Freq(15),.25)];
song = [line1,line2,line3,line4];
bridge = [line1,line2,line3,line5];
cs = [song,song,pauseSeg,song,bridge];
chorus = [cs, cs];
sound(chorus, FS);
%TIME + FREQUENCY DOMAIN PLOTS 
t = (0:length(chorus)-1) / FS;
%Downsample factor
ds = 20;
t_ds = t(1:ds:end);
chorus_ds = chorus(1:ds:end);
figure('Position',[200 200 900 600]);  % larger window
%TIME DOMAIN
subplot(2,1,1);
plot(t_ds, chorus_ds, 'LineWidth', 1);
xlabel('Time (s)');
ylabel('Amplitude');
title('Time-Domain Signal (Downsampled)');
grid on;
ylim([-1.2 1.2]);
%Frequency Domain
N = length(chorus);
Y = abs(fft(chorus))/N;
f = (0:N-1)*(FS/N);
subplot(2,1,2);
plot(f(1:floor(N/2)), Y(1:floor(N/2)), 'LineWidth', 1);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency-Domain Signal');
grid on;
xlim([0 1200]);
%Spectrogram and setup
figure;
window = 1024;        % size of FFT window
noverlap = 512;       % overlap between windows
nfft = 2048;          % FFT size for frequency resolution
spectrogram(chorus, window, noverlap, nfft, FS, 'yaxis');
set(gca,'YScale','log')
colorbar;
title('Spectrogram of Digitally Generated Music');
ylabel('Frequency (kHz)');
xlabel('Time (s)');
% function to soften the sound a nd make it less pitchy
function y = softEnvelope(x)
   L = length(x);
   fade = round(L * 0.08);
   env = ones(1, L);
   env(1:fade) = linspace(0,1,fade);
   env(end-fade+1:end) = linspace(1,0,fade);
   y = x .* env;
end
