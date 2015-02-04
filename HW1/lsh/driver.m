%% driver: function description
function [errors] = driver(data)
	errors = [];

	% for i=10:2:20,
	% 	T1=lsh('lsh',i,24,size(data,1),data,'range',255);
	% 	linn = findnn(data, 'linearsearch', T1, 3);
	% 	lshnn = findnn(data, 'lsh', T1, 4);
	% 	err = calcerror(linn, lshnn, data);
	% 	errors = [errors err];
	% end

	for i=16:2:24,
		T1=lsh('lsh',10,i,size(data,1),data,'range',255);
		linn = findnn(data, 'linearsearch', T1, 3);
		lshnn = findnn(data, 'lsh', T1, 4);
		err = calcerror(linn, lshnn, data);
		errors = [errors err];
	end

end


