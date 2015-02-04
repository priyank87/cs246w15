%% predictor: function description
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
