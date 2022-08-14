% EN1 Hw8
% Neal Zhao
% Partner: Logan McAllister
function [new_legs, new_muscles] = manducaPermute(legs, muscles, temperature)
n_segments = ceil(10*(temperature/100)/2);
segments_to_change = randsample(10, n_segments)';
new_legs = legs;
new_muscles = muscles;
%permute for each given time segments
for i = segments_to_change
    this_legs = legs(i,:);
    this_muscles = muscles(i,:);
    %find current gap size 
    gripping = find(this_legs);
    
    move_code = randi(3);
    if move_code == 1
        if gripping(1) ~= 1
            this_legs(gripping(2)) = 0;
            this_legs(randi(gripping(1)-1)) = 1;
        end
    elseif move_code == 2%left leg "move" to right
        if gripping(2) ~= 5
            this_legs(gripping(1)) = 0;
            this_legs(gripping(2)+randi(5-gripping(2))) = 1;
        end
    else
        %legs dont move
    end
    gripping = find(this_legs);
    
    %mucles between legs set to 0
    %other muscles might change
    for j = 1:4 
        if this_muscles(j) >= gripping(1) && this_muscles(j) < gripping(2)
            this_muscles(j) = 0;
        else
            if rand() < (temperature+200)/600
                if this_muscles(j) == 0
                    this_muscles(j) = 100;
                else
                    this_muscles(j) = 0;
                end
            end
        end
    end
    
    new_legs(i,:) = this_legs;
    new_muscles(i,:) = this_muscles;
end
end