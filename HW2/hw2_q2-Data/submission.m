%% predictor: get agreement for given X
function [outputs] = predictor(X, y)

	modelX = X(41:640, :);
	modelY = y(41:640, :);
	model = sum(bsxfun(@times, modelX, modelY));

	testX = X(1:40, :);
	testY = y(1:40, :);

	mult = repmat(model, size(testY), 1);
	coeff = testX * mult';

	coeff = coeff(:,1);
	prodCoeff = coeff .* testY;

	outputs = sum(prodCoeff) * -1;


%% driver: main driver code
function [op] = driver(X, y)
	k = [1:20:601];

	[U,S,V] = svd(X, 'econ');
	n = size(S,1);

	perf = [];

	for idx = k,
		newX = U(:, [1:idx]);

		res = predictor(newX, y);
		perf = [perf res];
	end

	op = perf;

end


% plot the data
op = driver(X, y);
plot([1:20:601],op);
xlabel('k');
ylabel('Agreement');
title('Agreement vs K');