
%% One time initialization
load patches;

% Perform linear search and return nearest neighbors
function nnlinind = linearsearch(query, data, num)

	d = sum(abs(bsxfun(@minus, query, data)));
	[ignore,ind]=sort(d);

	cand = ind(1:num+1);

	nnlinind = cand;

end


%% Calculate error ratio 
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


%% driver function to calulate error
function [errors] = driver(data)
	errors = [];

	% Vary L and get nearest neighbors
	for i=10:2:20,
		T1=lsh('lsh',i,24,size(data,1),data,'range',255);
		linn = findnn(data, 'linearsearch', T1, 3);
		lshnn = findnn(data, 'lsh', T1, 4);
		err = calcerror(linn, lshnn, data);
		errors = [errors err];
	end

	% Vary k and get nearest neighbors
	for i=16:2:24,
		T1=lsh('lsh',10,i,size(data,1),data,'range',255);
		linn = findnn(data, 'linearsearch', T1, 3);
		lshnn = findnn(data, 'lsh', T1, 4);
		err = calcerror(linn, lshnn, data);
		errors = [errors err];
	end

end

% find nearest neighbors based on search type
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

%% plot nearest neighbors
function plotnn(data, query, nn, numcand)
	
	% plot the query point
	figure(1); clf;
	imagesc(reshape(query,20,20));
	colormap gray;
	axis image;

	set(gca,'YTickLabel', sprintf('',[]));
	set(gca,'XTickLabel', sprintf('',[]));

	% plot neigbours
	figure(2);clf;
	for k=1:numcand, 
		subplot(2,5,k);
		imagesc(reshape(data(:,nn(k+1)),20,20)); 
		colormap gray;
		axis image;
		set(gca,'YTickLabel', sprintf('',[]));
		set(gca,'XTickLabel', sprintf('',[]));
	end

end

% Plot the 10 nearest neighbors for both types
query = patches(:, 100);
T1=lsh('lsh',10,24,size(patches,1),patches,'range',255);
[nn,numcand]=lshlookup(query, patches, T1, 'k', 11, 'distfun', 'lpnorm', 'distargs', {1});
plotnn(patches, query, nn, 10);

nn=linearsearch(query, patches, 10);
plotnn(patches, query, nn, 10);
