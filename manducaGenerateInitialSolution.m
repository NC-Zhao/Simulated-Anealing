% EN1 Hw8
% Neal Zhao
% Partner: Logan McAllister
function [legs, muscles] = manducaGenerateInitialSolution()
% a good one is just a random one
% because we do not know the "center" of the input of the function
legs = zeros(10, 5);
muscles = zeros(10,4);
for i = 1:10
    gripping = randsample(5,2);
    this_legs = legs(i,:);
    this_muscles = muscles(i,:);
    this_legs(gripping) = 1;
    gripping = find(this_legs);%put gripping in order
    
    for j = 1:4 
        if ~(j >= gripping(1) && j < gripping(2))
            if rand() < 0.5
                this_muscles(j) = 100;
            end
        end
    end
    
    legs(i,:) = this_legs;
    muscles(i,:) = this_muscles;
end

end