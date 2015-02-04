function nnlinind = linearsearch(query, data, num)

	d = sum(abs(bsxfun(@minus, query, data)));
	[ignore,ind]=sort(d);

	cand = ind(1:num+1);

	nnlinind = cand;

end

