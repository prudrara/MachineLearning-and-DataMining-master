In this	project, you will develop a regression algorithm for learning a	predictive model in both MATLAB and Python.	
The	descriptions	of	the	I/O	variables	are:	
• pred	–	[ntest	x	noutput]	array	of	predictions	where	ntest	is	the	number	of	input	
feature	vectors	in	the	testing	data	and	noutput	is	the	number	of	outputs	
• trainX	–	[ntrain	x	(nfeature	+	noutput)]	training	data;	array	of	features	and	outputs,	
where	the	first	nfeature	columns	are	the	feature	values	and	the	last	noutput	
columns	are	the	output	values	
• testX	–	[ntest	x	nfeature]	test	data	
• noutput	–	the	number	of	output	value	columns	in	the	training	data	
	
For	example,	if	I	have	two	training	data	vectors,	each	with	four	features	and	two	outputs,	
each	row	of	the	trainX	array	would	look	like	this:	
	
trainX(1,:) = [x11 x12 x13 x14 t11 t12];
trainX(2,:) = [x21 x22 x23 x24 t21 t22];
	
where	x	are	your	feature	values	and	t	are	your	observations.	If	I	then	want	to	predict	the	
outputs	for	two	test	data	features,	then	testX	would	look	like	this:	
	
testX(1,:) = [x11 x12 x13 x14];
testX(2,:) = [x21 x22 x23 x24];
	
Notice	that	there	are	no	observations	given	(as	we	wouldn’t	have	those	for	the	test	data).	

