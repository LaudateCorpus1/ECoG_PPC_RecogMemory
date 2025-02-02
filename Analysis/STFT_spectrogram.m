function [P,F,T] = STFT_spectrogram(X,opts)
% STFT_spectrogram computes the Spectrogram for the data matrix X
% using matlab's spectrogram function.
%
% the spectrogram is computed by row, and the results stored in 3D matrix
% the resulting 

if ~isfield(opts,'fs')
	error('need sampling frequency fs');
end
if ~isfield(opts,'freqs')
	opts.freqs = unique(round(logspace(0,log10(180),50)));
end
if ~isfield(opts,'windowSize')
	opts.windowSize = round(opts.fs); % defaults to 1s
end
if ~isfield(opts,'overlap')
	opts.overlap = round(0.95*opts.windowSize); 
end

nChans 	= size(X,1);
nF 		= numel(opts.freqs);

% get size time dimension size for pre-allocation
[~,F,T,temp] = spectrogram(X(1,:),opts.windowSize,opts.overlap,opts.freqs,opts.fs);
nT = numel(T);

% pre-allocate 3D matrix
P = zeros(nChans,nF,nT);
P(1,:,:) = temp;
parfor iChan = 2:nChans
    tic
	[~,~,~,P(iChan,:,:)] = spectrogram(X(iChan,:),opts.windowSize,opts.overlap,opts.freqs,opts.fs);	
    fprintf('Time to processes channel %i = %g \n',iChan,toc);
end
