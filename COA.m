
function [bestSolution, cg_curve, bestPosition, time] = COA(population, objectiveFunction, Lb, Ub, maxIterations)

ub = Ub(1,:);
lb = Lb(1,:);
[numCoatis, dimension] = size(population);

tic;
bestSolution = inf;
bestPosition = zeros(1, dimension);
cg_curve = zeros(1, maxIterations);

population = min(max(population, repmat(lb, numCoatis, 1)), repmat(ub, numCoatis, 1));
fitness = zeros(numCoatis, 1);

for i = 1:numCoatis
    fitness(i) = objectiveFunction(population(i,:));
    if fitness(i) < bestSolution
        bestSolution = fitness(i);
        bestPosition = population(i,:);
    end
end

for iter = 1:maxIterations
    progress = iter / maxIterations;

    % Phase 1: Coati hunting and escaping
    for i = 1:numCoatis
        iguana = rand(1, dimension) .* (ub - lb) + lb;
        iguanaFitness = objectiveFunction(iguana);

        if iguanaFitness < fitness(i)
            newPosition = population(i,:) ...
                + rand(1, dimension) .* (iguana - 2 * population(i,:));
        else
            newPosition = population(i,:) ...
                + rand(1, dimension) .* (population(i,:) - iguana);
        end

        newPosition = min(max(newPosition, lb), ub);
        newFitness = objectiveFunction(newPosition);

        if newFitness < fitness(i)
            population(i,:) = newPosition;
            fitness(i) = newFitness;
        end

        if fitness(i) < bestSolution
            bestSolution = fitness(i);
            bestPosition = population(i,:);
        end
    end

    % Phase 2: Escape from predators
    for i = 1:numCoatis
        localLb = lb + (lb - lb) * progress;
        localUb = lb + (ub - lb) * (1 - progress) + (ub - lb) * progress;

        radius = 0.02 * (1 - progress) .* (ub - lb);
        newPosition = population(i,:) + (2 * rand(1, dimension) - 1) .* radius;

        newPosition = min(max(newPosition, localLb), localUb);
        newFitness = objectiveFunction(newPosition);

        if newFitness < fitness(i)
            population(i,:) = newPosition;
            fitness(i) = newFitness;
        end

        if fitness(i) < bestSolution
            bestSolution = fitness(i);
            bestPosition = population(i,:);
        end
    end

    cg_curve(iter) = bestSolution;
end

time = toc;

end
