clear all;
close all;

expression = {'angry', 'digust', 'fear', 'happy'};

for i = 1 : 4
    switch expression{i}
        case 'digust'
            disp('digust');
        case 'angry'
            disp('angry');
        case 'fear'
            disp('fear');
        case 'happy'
            disp('happy');
        otherwise
            disp('unknow expression');
    end
end

for i = 1 : 10
    label = i;
end

fprintf('%d', label);