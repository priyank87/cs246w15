%% One time initialization per model
% load patches;
% T1=lsh('lsh',10,24,size(patches,1),patches,'range',255);
function op = findnn(patches, searchtype, T1, num)
	neigbours = [];
	disp(searchtype);
	tic;

	for i=1:10,
		colno = i*100;
		query = patches(:, colno);

		if strcmp(searchtype, 'linearsearch'),
			nn=linearsearch(query, patches, num);
		elseif strcmp(searchtype, 'lsh'),
			[nn,numcand]=lshlookup(query, patches, T1, 'k', num, 'distfun', 'lpnorm', 'distargs', {1});
			
			if numcand < num,
				pads = zeros(1, num-numcand);
				disp('-- Padding --');
				nn = [nn pads]
			end
		end

		disp(sprintf('%s%d%s%d', 'neigbours-', size(neigbours,2), '; numcand-', size(nn,2)));

		neigbours = [neigbours; nn];
	end

	op = neigbours;
	time = toc;

	disp(time/10);
end