%% plotnn: function description
function plotnn(data, query, nn, numcand)
	
	% plot the query point
	figure(1); clf;
	imagesc(reshape(query,20,20));
	colormap gray;
	axis image;

	set(gca,'YTickLabel', sprintf('',[]));
	set(gca,'XTickLabel', sprintf('',[]));

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
