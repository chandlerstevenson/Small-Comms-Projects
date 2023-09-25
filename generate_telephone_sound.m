% Chandler W. Stevenson

% Top Level Environment: Constants
global Fs T t 
Fs = 44100;  % Arbitrary sampling rate taking from Audacity
T = .3;      % Duration of tone in sec (can be adjusted) 
t = 0:1/Fs:T-1/Fs;  % Time vector, we subtract a sample for temporal accuracy  

% Define Keypad Frequencies [Hz, Hz]  
one = [697, 1209]; 
two = [697, 1336]; 
three = [697, 1477]; 
letter_a = [697, 1633];  
four = [770, 1209]; 
five = [770, 1336];  
six = [770, 1477];  
letter_b = [770, 1633];  
seven = [852, 1209];  
eight = [852, 1336]; 
nine = [852, 1477]; 
letter_c = [852, 1633];  
star = [941, 1209];  
zero = [941, 1336];  
pound = [941, 1447]; 
letter_d = [941, 1633];   


% Define the phone number sequence
phone_number = {four, zero, zero, nine, five, seven, four, two, six, nine};  % Use a cell array for the phone_number to store each tone

% Here, we define a cut off value which is simply the length of the phone
% number 
stop_point = length(phone_number); 

output = []; % Initialize array  
silence_duration = 0.01; %Time in seconds 
silence = zeros(1, round(Fs * silence_duration)); 

index = 1; % Initalize stop point 
while index <= stop_point   
    output = [output, num_to_sound(phone_number{index}), silence];  % Concatenate the tone and silence
    index = index + 1;
end  

% normalizing output (not necessary, but used just in case)  
output = output / max(abs(output)); % element divided by max of list 

% % For listening purposes only (headphones recommended)  
% sound(output, Fs);  

% Here, we use a buil-in MATLAB function called 'audiowrite'
% audiowrite('telephone_sound_1932M.wav', output, Fs);


% Function num_to_sound 
% Input: frequency array (tuple array)  
% Output: additive sinusoids that can be used for sound

% Decode the signal to get the phone number
decoded_number = decode_signal(output);

% Display the decoded phone number
disp('Decoded phone number:');
for i = 1:length(decoded_number)
    disp(decoded_number{i});
end


function y = num_to_sound(freq_array)
    global t
    y = zeros(size(t));  % y initialization to t array 
    for f = freq_array
        y = y + sin(2*pi*f*t);
    end
end  
% Additional functions

function decoded_number = decode_signal(signal)
    global Fs;

    % Segment the signal using STFT
    windowSize = round(0.3*Fs);  % Using entire tone duration
    noverlap = round(0.0001*Fs);   % Minimal overlap
    [S,F,T,P] = spectrogram(signal, windowSize, noverlap, [], Fs);

    % Plot the spectrogram for visual purposes 
    imagesc(T,F,10*log10(abs(P)));
    axis xy;
    xlabel('Time (s)');
    ylabel('Frequency (Hz)');
    title('Spectrogram');
    colorbar;
    
    % Set y-axis limits
    ylim([0 2000]); % can be adjusted if not for DTMF utility 

    phone_number = {};

    for i = 1:length(T)
        % Identify the dominant frequencies for each time segment
        [~,I] = findpeaks(P(:,i), 'SortStr', 'descend', 'NPeaks', 2);
        
        % If two peaks are found (not in grey zone) 
        if length(I) == 2 
            dominantFreq = sort(F(I(1:2)));  % Sort the frequencies, follows from table 
            dominantFreq1 = dominantFreq(1);
            dominantFreq2 = dominantFreq(2);
            
            % Print detected frequencies (for debugging)
            disp(['Detected frequencies: ', num2str(dominantFreq1), ' Hz and ', num2str(dominantFreq2), ' Hz']);

            number = map_frequencies_to_number(dominantFreq1, dominantFreq2)
            phone_number = [phone_number, {number}];
        end
    end

    decoded_number = phone_number
end




function number = map_frequencies_to_number(f1, f2)
    row_freqs = [697, 770, 852, 941];
    col_freqs = [1209, 1336, 1477, 1633];

    tolerance = 10;  % Values can fall within +/- tolerance 
    
    % Find the closest frequency within the tolerance range for f1 and f2
    [~, row_idx] = min(abs(row_freqs - f1));
    [~, col_idx] = min(abs(col_freqs - f2));

    % Define Grey Areas for 
    if abs(row_freqs(row_idx) - f1) > tolerance
        number = 'X';  % Frequency f1 was not close enough
        return;
    end
    
  
    if abs(col_freqs(col_idx) - f2) > tolerance
        number = 'X';  % Frequency f2 was not close enough
        return;
    end

    DTMF_map = {
        '1', '2', '3', 'A';
        '4', '5', '6', 'B';
        '7', '8', '9', 'C';
        '*', '0', '#', 'D';
    };
    number = DTMF_map{row_idx, col_idx};
end



