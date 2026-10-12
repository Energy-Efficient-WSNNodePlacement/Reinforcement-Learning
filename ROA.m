
function [bestSolution, cg_curve, bestPosition, time] = ROA(population, objectiveFunction, Lb, Ub, maxIterations)

ub = Ub(1,:);
lb = Lb(1,:);
[numIndividuals, dimension] = size(population);

tic;
bestSolution = inf;
bestPosition = zeros(1, dimension);
cg_curve = zeros(1, maxIterations);

population = min(max(population, repmat(lb, numIndividuals, 1)), repmat(ub, numIndividuals, 1));

fitness = zeros(numIndividuals, 1);

for i = 1:numIndividuals
    fitness(i) = objectiveFunction(population(i,:));
    if fitness(i) < bestSolution
        bestSolution = fitness(i);
        bestPosition = population(i,:);
    end
end

for iter = 1:maxIterations
    progress = iter / maxIterations;
    mutationRate = 0.3 * (1 - progress) + 0.02;
    stepSize = 0.5 * (1 - progress) + 0.01;

    [~, order] = sort(fitness);
    eliteCount = max(1, ceil(0.2 * numIndividuals));
    elite = population(order(1:eliteCount), :);

    for i = 1:numIndividuals
        eliteIndex = randi(eliteCount);
        elitePosition = elite(eliteIndex,:);

        if rand < 0.5
            newPosition = population(i,:) ...
                + rand(1,dimension) .* (bestPosition - population(i,:)) ...
                + stepSize .* randn(1,dimension) .* (ub - lb);
        else
            newPosition = elitePosition ...
                + stepSize .* (2 * rand(1,dimension) - 1) .* (ub - lb);
        end

        if rand < mutationRate
            mutationIndex = randi(dimension);
            newPosition(mutationIndex) = lb(mutationIndex) ...
                + rand * (ub(mutationIndex) - lb(mutationIndex));
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

    cg_curve(iter) = bestSolution;
end

time = toc;

end
