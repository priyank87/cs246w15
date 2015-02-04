%% calcerror: function description
function [err] = calcerror(linn, lshnn, data)
	err=0;

	for i=1:10,
		qcol = data(:, lshnn(i, 1));

		lshids = lshnn(i, 2:4);
		lshids = lshids(lshids ~= 0);
		lshdcols = data(:, lshids);

		linids = linn(i, 2:4);
		linids = linids(linids ~= 0);
		lindcols = data(:, linids);

		lshdist = sum(sum(abs(bsxfun(@minus, lshdcols, qcol))));
		lindist = sum(sum(abs(bsxfun(@minus, lindcols, qcol))));

		% disp(sprintf('%s%d%s%d%s%f', 'lshdist-', lshdist, '; lindist-', lindist, '; error-', lshdist/lindist));
		err = err + (lshdist * 1.0 /lindist);
	end

	err /= 10;
end