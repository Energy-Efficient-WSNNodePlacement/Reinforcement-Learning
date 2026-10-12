
function [bestSolution, cg_curve, bestPosition, time] = CCO(population, objectiveFunction, Lb, Ub, maxIterations)

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
    stepSize = 0.1 + 0.4 * (1 - progress);
    discoveryRate = 0.25 * (1 - progress) + 0.05;

    [~, order] = sort(fitness);
    bestAgents = population(order(1:max(1, ceil(numAgents * 0.2))), :);

    for i = 1:numAgents
        if rand < discoveryRate
            % Cuckoo-inspired exploration using Levy-like steps
            u = randn(1, dimension);
            v = randn(1, dimension);
            levyStep = u ./ (abs(v).^(1/1.5) + eps);

            newPosition = population(i,:) ...
                + stepSize * levyStep .* (population(i,:) - bestPosition);
        else
            % Catfish-inspired movement toward promising solutions
            peer = randi(numAgents);
            elite = bestAgents(randi(size(bestAgents,1)), :);

            newPosition = population(i,:) ...
                + rand(1, dimension) .* (elite - population(i,:)) ...
                + rand(1, dimension) .* (population(peer,:) - population(i,:));
        end

        % Random disturbance
        if rand < 0.1
            newPosition = newPosition ...
                + 0.05 * randn(1, dimension) .* (ub - lb);
        end

        % Boundary handling
        newPosition = min(max(newPosition, lb), ub);
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

    cg_curve(iter) = bestSolution;
end

time = toc;

end
