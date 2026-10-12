
function [bestSolution, cg_curve, bestPosition, time] = DFA(population, objectiveFunction, Lb, Ub, maxIterations)

ub = Ub(1,:);
lb = Lb(1,:);
[numAgents, dimension] = size(population);

tic;
bestSolution = inf;
bestPosition = zeros(1, dimension);
cg_curve = zeros(1, maxIterations);

population = min(max(population, repmat(lb, numAgents, 1)), repmat(ub, numAgents, 1));

fitness = zeros(numAgents, 1);
for i = 1:numAgents
    fitness(i) = objectiveFunction(population(i,:));
    if fitness(i) < bestSolution
        bestSolution = fitness(i);
        bestPosition = population(i,:);
    end
end

for iter = 1:maxIterations
    progress = iter / maxIterations;
    stepSize = 0.5 * (1 - progress) + 0.01;

    for i = 1:numAgents
        r1 = rand(1, dimension);
        r2 = rand(1, dimension);

        % Dark Forest exploration and movement
        if rand < 0.5
            peer = randi(numAgents);
            while peer == i && numAgents > 1
                peer = randi(numAgents);
            end
            newPosition = population(i,:) ...
                + r1 .* (population(peer,:) - population(i,:)) ...
                + stepSize .* (2 * r2 - 1) .* (ub - lb);
        else
            newPosition = population(i,:) ...
                + r1 .* (bestPosition - population(i,:)) ...
                + stepSize .* (2 * r2 - 1) .* (ub - lb);
        end

        % Boundary handling
        newPosition = min(max(newPosition, lb), ub);

        % Evaluate new position
        newFitness = objectiveFunction(newPosition);

        % Greedy selection
        if newFitness < fitness(i)
            population(i,:) = newPosition;
            fitness(i) = newFitness;
        end

        % Update global best
        if fitness(i) < bestSolution
            bestSolution = fitness(i);
            bestPosition = population(i,:);
        end
    end

    % Store convergence curve
    cg_curve(iter) = bestSolution;
end

time = toc;

end
