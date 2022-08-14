% EN1 Hw8
% Neal Zhao
% Partner: Logan McAllister

for i = 1
    [bestScore, bestSolution] = manducaSA(100);
    fprintf('the best score is %d, the best solution is \n', bestScore)
%     disp(bestSolution.leg)
%     disp(bestSolution.muscle)
end


function [best_score, best_solution] = manducaSA(initial_temp)
temp = initial_temp;
[current_solution.leg, current_solution.muscle] = manducaGenerateInitialSolution;
best_solution = current_solution;
best_score = manducaFitness(best_solution.leg, best_solution.muscle);
current_score = best_score;
n = 0;
%s = 0;%
denies = 0;%how many times denied in a row
waitlist = [];
waitlist_record = [];
while(n < 500)
    [new_solution.leg, new_solution.muscle] = manducaPermute(current_solution.leg, current_solution.muscle, temp);
    new_score = manducaFitness(new_solution.leg, new_solution.muscle);
    S = new_score - current_score;
    
    if S > 0
        current_solution = new_solution;
        current_score = new_score;
        denies = 0;
    elseif rand() < exp(S/temp)
        current_solution = new_solution;
        current_score = new_score;
        denies = 0;
        %fprintf('%s\n', 'accept')
    else
        %fprintf('%s\n', 'denied')
        denies = denies +1;
    end
    
    % decide whether to place on the waitlist
    if denies > 4
        if current_score > 0.5 * best_score
            waitlist = [waitlist, current_solution];
            waitlist_record = [waitlist_record, current_score];
            temp = temp + 20;% heat up to allow more failures
            denies = 0;
        end
        if temp>100
            temp = 100;
        end
    elseif S < -200 && denies == 0
        % a big failure means we might have reached a local top
        waitlist = [waitlist, current_solution];
        waitlist_record = [waitlist_record, current_score];
    end
    
    % check if the current solution is better than the best
    
    %fprintf('%d\n', current_score)%testing code
    if current_score > best_score
        best_score = current_score;
        best_solution = current_solution;
        %n=n+1;%test code
    end
    
    %test block
%     if current_score == 192
%         return
%     end
    
    temp = updateTemp(temp);
    n = n+1;
end

waitlist = [waitlist, best_solution];
waitlist_record = [waitlist_record, best_score]
    
%perform steepest ascent on all wailist solutions
size_wl = size(waitlist, 2);
for i = size_wl:-1:1
%     if waitlist_record(i) < 0.6*best_score
%         continue
%     end
    if i ~= size_wl && waitlist_record(i) == waitlist_record(i+1)
        continue
    end
    [wl_new_solution,wl_new_score] = manduca_HillClimb(waitlist(i), waitlist_record(i));
%     wl_new_score = manducaFitness(wl_new_solution.leg, wl_new_solution.muscle);
    if wl_new_score >= best_score
        best_solution = wl_new_solution;
        best_score = wl_new_score;
    end
end
    
end

function [new_temp] = updateTemp(current_temp)
new_temp = current_temp * 0.99;
end


function [bestSolution, bestScore] = manduca_HillClimb(solution, score)
bestSolution = solution;
bestScore = score;
[neighbor, newScore] = manduca_generateNeighbor_steepestAscent(bestSolution, bestScore);

while true
    if newScore <= bestScore
        return
    else
        bestScore = newScore;
        bestSolution = neighbor;
        [neighbor, newScore] = manduca_generateNeighbor_steepestAscent(bestSolution, bestScore);
    end
end
end

function [bestMYS, bestScore] = manduca_generateNeighbor_steepestAscent(original, score)

bestScore = score;
bestMYS = original;
for i = 1:10
    for j = 1:14
        newMYS = original;
        A.leg = newMYS.leg(i,:);
        gripping = find(A.leg);
        A.muscle = newMYS.muscle(i,:);
        C52 = [1 2
            1 3
            1 4
            1 5
            2 3
            2 4
            2 5
            3 4 
            3 5
            4 5];
        if j < 11 % leg
%             if j < gripping(1)
%                 A.leg(j) = 1;
%                 A.leg(gripping(1)) = 0;
%             elseif j > gripping (2)
%                 A.leg(j) = 1;
%                 A.leg(gripping(2)) = 0;
%             else
%                 continue
%             end
            gripping = C52(j,:);
            A.leg(:) = 0;
            A.leg(gripping(1)) = 1;
            A.leg(gripping(2)) = 1;
        else % muscle
            if (j-10)>=gripping(1) && (j-10)<gripping(2)
                continue
            else
                A.muscle(j-10) = mod(A.muscle(j-10)+100, 200);
            end
        end
        
        newMYS.leg(i,:) = A.leg;
        newMYS.muscle(i,:) = A.muscle;
        %newMYS(i) = num2str(mod((newMYS(i)+1), 2));
        newScore = manducaFitness(newMYS.leg, newMYS.muscle);
        if newScore >= bestScore
            bestScore = newScore;
            bestMYS = newMYS;
        end
    end
end
if bestScore == score
   bestMYS = original;
end
end


