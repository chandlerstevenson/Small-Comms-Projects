
% Chandler W. Stevenson

% Top Level Environment: Constants
global Fs T t 
Fs = 44100;  % Arbitrary sampling rate taking from Audacity
T = .3;      % Duration of tone in sec (can be adjusted) 
t = 0:1/Fs:T-1/Fs;  % Time vector, we subtract a sample for temporal accuracy  

% Define Keypad Frequencies (Hz) 
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
phone_number = {four, zero, one, nine, five, seven, four, two, six, nine};  % Use a cell array for the phone_number to store each tone


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

% For listening purposes only (headphones recommended)  
% sound(output, Fs);  

audiowrite('telephone_sound_1932M.wav', output, Fs);


% Function num_to_sound 
% Input: frequency array (tuple array)  
% Output: additive sinusoids that can be used for sound
function y = num_to_sound(freq_array)
    global t
    y = zeros(size(t));  % y initialization to t array 
    for f = freq_array
        y = y + sin(2*pi*f*t);
    end
end 
