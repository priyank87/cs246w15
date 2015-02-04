%% driver: function description
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
